#!/usr/bin/env python3
"""Verify scholarly-source metadata with PubMed E-utilities and Crossref."""

from __future__ import annotations

import argparse
import hashlib
import json
import os
import re
import sys
import urllib.error
import urllib.parse
import urllib.request
import xml.etree.ElementTree as ET
from difflib import SequenceMatcher
from pathlib import Path
from typing import Any, Protocol


PUBMED_BASE = "https://eutils.ncbi.nlm.nih.gov/entrez/eutils"
CROSSREF_BASE = "https://api.crossref.org"
DOI_PATTERN = re.compile(r"^10\.\d{4,9}/\S+$", re.IGNORECASE)
PMID_PATTERN = re.compile(r"^\d{1,9}$")
YEAR_PATTERN = re.compile(r"(?:19|20)\d{2}")


class RetrievalError(RuntimeError):
    """Represent an explicit remote retrieval failure without fabricating data."""


class Transport(Protocol):
    def get_json(self, url: str) -> dict[str, Any]: ...

    def get_xml(self, url: str) -> ET.Element: ...


class HttpTransport:
    def __init__(self, timeout: float = 20.0) -> None:
        self.timeout = timeout
        self.user_agent = "EpiAgentKit-evidence-research/1.0"

    def _get(self, url: str) -> bytes:
        request = urllib.request.Request(url, headers={"User-Agent": self.user_agent})
        try:
            with urllib.request.urlopen(request, timeout=self.timeout) as response:
                return response.read()
        except (urllib.error.URLError, urllib.error.HTTPError, TimeoutError) as error:
            raise RetrievalError(type(error).__name__) from error

    def get_json(self, url: str) -> dict[str, Any]:
        try:
            value = json.loads(self._get(url).decode("utf-8"))
        except (UnicodeDecodeError, json.JSONDecodeError) as error:
            raise RetrievalError("invalid_json") from error
        if not isinstance(value, dict):
            raise RetrievalError("unexpected_json_shape")
        return value

    def get_xml(self, url: str) -> ET.Element:
        try:
            return ET.fromstring(self._get(url))
        except ET.ParseError as error:
            raise RetrievalError("invalid_xml") from error


def clean_doi(value: str) -> str:
    value = value.strip()
    value = re.sub(r"^https?://(?:dx\.)?doi\.org/", "", value, flags=re.IGNORECASE)
    value = re.sub(r"^doi:\s*", "", value, flags=re.IGNORECASE)
    return value.rstrip(".,; ").casefold()


def detect_query(value: str) -> tuple[str, str]:
    normalized = value.strip()
    doi = clean_doi(normalized)
    if DOI_PATTERN.fullmatch(doi):
        return "doi", doi
    if PMID_PATTERN.fullmatch(normalized):
        return "pmid", normalized
    return "title", normalized


def normalize_text(value: str | None) -> str:
    if not value:
        return ""
    return re.sub(r"[^a-z0-9]+", " ", value.casefold()).strip()


def comparable(left: str | None, right: str | None, threshold: float = 0.88) -> bool:
    first = normalize_text(left)
    second = normalize_text(right)
    if not first or not second:
        return True
    return (
        first in second
        or second in first
        or SequenceMatcher(None, first, second).ratio() >= threshold
    )


def node_text(node: ET.Element | None) -> str | None:
    if node is None:
        return None
    value = "".join(node.itertext()).strip()
    return re.sub(r"\s+", " ", value) or None


def pubmed_url(endpoint: str, params: dict[str, str], email: str | None) -> str:
    values = {"tool": "epiagentkit", "retmode": "json", **params}
    if email:
        values["email"] = email
    return f"{PUBMED_BASE}/{endpoint}?{urllib.parse.urlencode(values)}"


def pubmed_search(
    term: str, transport: Transport, email: str | None, limit: int = 5
) -> list[str]:
    payload = transport.get_json(
        pubmed_url(
            "esearch.fcgi",
            {"db": "pubmed", "term": term, "retmax": str(limit)},
            email,
        )
    )
    values = payload.get("esearchresult", {}).get("idlist", [])
    return [str(value) for value in values if str(value).isdigit()]


def pubmed_fetch(pmid: str, transport: Transport, email: str | None) -> dict[str, Any] | None:
    root = transport.get_xml(
        pubmed_url(
            "efetch.fcgi",
            {"db": "pubmed", "id": pmid, "retmode": "xml"},
            email,
        )
    )
    article = root.find(".//PubmedArticle")
    if article is None:
        return None
    title = node_text(article.find(".//ArticleTitle"))
    journal = node_text(article.find(".//Journal/Title"))
    year = node_text(article.find(".//ArticleDate/Year")) or node_text(
        article.find(".//JournalIssue/PubDate/Year")
    )
    if not year:
        medline_date = node_text(article.find(".//JournalIssue/PubDate/MedlineDate"))
        match = YEAR_PATTERN.search(medline_date or "")
        year = match.group(0) if match else None
    authors: list[str] = []
    for author in article.findall(".//AuthorList/Author"):
        collective = node_text(author.find("CollectiveName"))
        family = node_text(author.find("LastName"))
        given = node_text(author.find("ForeName")) or node_text(author.find("Initials"))
        name = collective or " ".join(part for part in (family, given) if part)
        if name:
            authors.append(name)
    identifiers: dict[str, str] = {}
    for item in article.findall(".//ArticleIdList/ArticleId"):
        kind = item.attrib.get("IdType", "").casefold()
        value = node_text(item)
        if value:
            identifiers[kind] = value
    resolved_pmid = identifiers.get("pubmed") or node_text(article.find(".//PMID")) or pmid
    doi = clean_doi(identifiers.get("doi", "")) or None
    relations: list[dict[str, str]] = []
    for item in article.findall(".//CommentsCorrectionsList/CommentsCorrections"):
        relation = {"source": "pubmed", "type": item.attrib.get("RefType", "unknown")}
        related_pmid = node_text(item.find("PMID"))
        citation = node_text(item.find("RefSource"))
        if related_pmid:
            relation["pmid"] = related_pmid
        if citation:
            relation["citation"] = citation
        relations.append(relation)
    return {
        "source": "pubmed",
        "title": title,
        "authors": authors,
        "year": year,
        "journal": journal,
        "doi": doi,
        "pmid": resolved_pmid,
        "pmcid": identifiers.get("pmc"),
        "relations": relations,
    }


def crossref_year(message: dict[str, Any]) -> str | None:
    for key in ("published-print", "published-online", "issued", "created"):
        parts = message.get(key, {}).get("date-parts", []) if isinstance(message.get(key), dict) else []
        if parts and parts[0]:
            return str(parts[0][0])
    return None


def crossref_record(message: dict[str, Any]) -> dict[str, Any]:
    title_values = message.get("title") or []
    journal_values = message.get("container-title") or []
    authors = []
    for author in message.get("author") or []:
        if not isinstance(author, dict):
            continue
        name = " ".join(
            part for part in (str(author.get("family") or ""), str(author.get("given") or "")) if part
        ).strip()
        if name:
            authors.append(name)
    relations: list[dict[str, str]] = []
    relation_map = message.get("relation") or {}
    if isinstance(relation_map, dict):
        for relation_type, items in relation_map.items():
            for item in items if isinstance(items, list) else []:
                relation = {"source": "crossref", "type": str(relation_type)}
                if isinstance(item, dict):
                    for key in ("id", "id-type", "asserted-by"):
                        if item.get(key):
                            relation[key.replace("-", "_")] = str(item[key])
                relations.append(relation)
    return {
        "source": "crossref",
        "title": str(title_values[0]) if title_values else None,
        "authors": authors,
        "year": crossref_year(message),
        "journal": str(journal_values[0]) if journal_values else None,
        "doi": clean_doi(str(message.get("DOI") or "")) or None,
        "pmid": None,
        "pmcid": None,
        "relations": relations,
    }


def crossref_by_doi(doi: str, transport: Transport) -> dict[str, Any] | None:
    encoded = urllib.parse.quote(doi, safe="")
    payload = transport.get_json(f"{CROSSREF_BASE}/works/{encoded}")
    message = payload.get("message")
    return crossref_record(message) if isinstance(message, dict) else None


def crossref_by_title(title: str, transport: Transport) -> dict[str, Any] | None:
    params = urllib.parse.urlencode({"query.title": title, "rows": "5"})
    payload = transport.get_json(f"{CROSSREF_BASE}/works?{params}")
    items = payload.get("message", {}).get("items", [])
    candidates = [crossref_record(item) for item in items if isinstance(item, dict)]
    if not candidates:
        return None
    return max(
        candidates,
        key=lambda item: SequenceMatcher(
            None, normalize_text(title), normalize_text(item.get("title"))
        ).ratio(),
    )


def pubmed_by_search(
    term: str,
    expected_title: str | None,
    transport: Transport,
    email: str | None,
) -> dict[str, Any] | None:
    records = [
        record
        for pmid in pubmed_search(term, transport, email)
        if (record := pubmed_fetch(pmid, transport, email)) is not None
    ]
    if not records:
        return None
    if not expected_title:
        return records[0]
    return max(
        records,
        key=lambda item: SequenceMatcher(
            None, normalize_text(expected_title), normalize_text(item.get("title"))
        ).ratio(),
    )


def safe_call(source: str, function: Any) -> tuple[dict[str, Any] | None, str, str | None]:
    try:
        record = function()
    except RetrievalError as error:
        return None, "retrieval_failed", f"{source}:{error}"
    return record, "verified" if record else "not_found", None


def field_status(
    field: str, pubmed: dict[str, Any] | None, crossref: dict[str, Any] | None
) -> tuple[str, bool]:
    left = pubmed.get(field) if pubmed else None
    right = crossref.get(field) if crossref else None
    if field == "authors":
        left = left[0] if left else None
        right = right[0] if right else None
    if field == "doi":
        left = clean_doi(str(left or "")) or None
        right = clean_doi(str(right or "")) or None
    if left and right:
        if field == "year":
            consistent = str(left) == str(right)
        elif field == "doi":
            consistent = left == right
        elif field == "journal":
            consistent = comparable(str(left), str(right), threshold=0.72)
        else:
            consistent = comparable(str(left), str(right))
        return ("verified" if consistent else "conflict"), consistent
    if left or right:
        return "single_source", True
    return "missing", False


def merge_metadata(
    pubmed: dict[str, Any] | None, crossref: dict[str, Any] | None
) -> dict[str, Any]:
    records = [record for record in (pubmed, crossref) if record]
    merged: dict[str, Any] = {}
    for field in ("title", "authors", "year", "journal", "doi", "pmid", "pmcid"):
        merged[field] = next((record.get(field) for record in records if record.get(field)), None)
    return merged


def evidence_id(
    metadata: dict[str, Any], query_type: str | None = None, query_value: str | None = None
) -> str:
    identity = (
        f"doi:{clean_doi(str(metadata.get('doi') or ''))}"
        if metadata.get("doi")
        else f"pmid:{metadata.get('pmid')}"
        if metadata.get("pmid")
        else f"title:{normalize_text(str(metadata.get('title') or ''))}|{metadata.get('year') or ''}"
        if metadata.get("title")
        else f"query:{query_type or 'unknown'}:{normalize_text(query_value or '')}"
    )
    return "EVID-" + hashlib.sha256(identity.encode("utf-8")).hexdigest()[:12]


def verify_one(
    query: str,
    transport: Transport,
    email: str | None = None,
    retrieved_at: str | None = None,
) -> dict[str, Any]:
    query_type, value = detect_query(query)
    pubmed: dict[str, Any] | None = None
    crossref: dict[str, Any] | None = None
    source_status = {"pubmed": "not_attempted", "crossref": "not_attempted"}
    errors: list[str] = []

    if query_type == "pmid":
        pubmed, source_status["pubmed"], error = safe_call(
            "pubmed", lambda: pubmed_fetch(value, transport, email)
        )
        if error:
            errors.append(error)
        doi = pubmed.get("doi") if pubmed else None
        title = pubmed.get("title") if pubmed else None
        crossref, source_status["crossref"], error = safe_call(
            "crossref",
            lambda: crossref_by_doi(doi, transport)
            if doi
            else crossref_by_title(str(title), transport)
            if title
            else None,
        )
        if error:
            errors.append(error)
    elif query_type == "doi":
        crossref, source_status["crossref"], error = safe_call(
            "crossref", lambda: crossref_by_doi(value, transport)
        )
        if error:
            errors.append(error)
        pubmed, source_status["pubmed"], error = safe_call(
            "pubmed",
            lambda: pubmed_by_search(f'"{value}"[AID]', None, transport, email),
        )
        if error:
            errors.append(error)
    else:
        crossref, source_status["crossref"], error = safe_call(
            "crossref", lambda: crossref_by_title(value, transport)
        )
        if error:
            errors.append(error)
        pubmed, source_status["pubmed"], error = safe_call(
            "pubmed",
            lambda: pubmed_by_search(f'"{value}"[Title]', value, transport, email),
        )
        if error:
            errors.append(error)

    metadata = merge_metadata(pubmed, crossref)
    checks: dict[str, str] = {}
    consistent = True
    for field in ("title", "authors", "year", "journal", "doi", "pmid"):
        checks[field], passed = field_status(field, pubmed, crossref)
        if checks[field] == "conflict":
            consistent = False
    if query_type == "doi":
        query_matches = clean_doi(str(metadata.get("doi") or "")) == value
    elif query_type == "pmid":
        query_matches = str(metadata.get("pmid") or "") == value
    else:
        query_matches = bool(metadata.get("title")) and comparable(
            value, str(metadata.get("title"))
        )
    checks["query_identity"] = "verified" if query_matches else "conflict"
    core_present = all(metadata.get(field) for field in ("title", "authors", "year", "journal"))
    identity_present = bool(metadata.get("doi") or metadata.get("pmid"))
    retrieval_failed = any(status == "retrieval_failed" for status in source_status.values())
    metadata_verified = bool(
        core_present
        and identity_present
        and consistent
        and query_matches
        and not retrieval_failed
    )
    relations = []
    for record in (pubmed, crossref):
        if record:
            relations.extend(record.get("relations") or [])
    unique_relations = list({json.dumps(item, sort_keys=True): item for item in relations}.values())
    from datetime import datetime, timezone

    timestamp = retrieved_at or datetime.now(timezone.utc).isoformat(timespec="seconds")
    return {
        "query": {"type": query_type, "value": value},
        "evidence_id": evidence_id(metadata if query_matches else {}, query_type, value),
        "metadata_verified": metadata_verified,
        "full_text_status": "pmc_available" if metadata.get("pmcid") else "not_verified",
        "claim_verified": False,
        "retrieved_at": timestamp,
        "verification_scope": "cross_source" if pubmed and crossref else "single_source",
        "source_status": source_status,
        "field_checks": checks,
        "metadata": metadata,
        "relations": unique_relations,
        "errors": errors,
    }


def parse_args(argv: list[str] | None = None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("queries", nargs="+", help="DOI, PMID, or article title")
    parser.add_argument("--email", default=os.environ.get("NCBI_EMAIL"))
    parser.add_argument("--timeout", type=float, default=20.0)
    parser.add_argument("--pretty", action="store_true")
    parser.add_argument("--output", type=Path)
    return parser.parse_args(argv)


def main(argv: list[str] | None = None) -> int:
    args = parse_args(argv)
    transport = HttpTransport(args.timeout)
    records = [verify_one(query, transport, args.email) for query in args.queries]
    payload = {"records": records}
    text = json.dumps(payload, ensure_ascii=False, indent=2 if args.pretty else None) + "\n"
    if args.output:
        args.output.write_text(text, encoding="utf-8")
    else:
        sys.stdout.write(text)
    return 0 if all(record["metadata_verified"] for record in records) else 1


if __name__ == "__main__":
    raise SystemExit(main())
