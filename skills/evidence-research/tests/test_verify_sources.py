from __future__ import annotations

import importlib.util
import json
import unittest
import xml.etree.ElementTree as ET
from pathlib import Path


SCRIPT = Path(__file__).resolve().parents[1] / "scripts" / "verify_sources.py"
SPEC = importlib.util.spec_from_file_location("verify_sources", SCRIPT)
assert SPEC and SPEC.loader
verify_sources = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(verify_sources)


PUBMED_XML = """<?xml version="1.0" encoding="UTF-8"?>
<PubmedArticleSet>
  <PubmedArticle>
    <MedlineCitation>
      <PMID>12345678</PMID>
      <Article>
        <ArticleTitle>Validated outcome score for cohort studies</ArticleTitle>
        <AuthorList>
          <Author><LastName>Wang</LastName><ForeName>Lin</ForeName></Author>
          <Author><LastName>Chen</LastName><ForeName>Mei</ForeName></Author>
        </AuthorList>
        <Journal>
          <JournalIssue><PubDate><Year>2024</Year></PubDate></JournalIssue>
          <Title>Journal of Clinical Methods</Title>
        </Journal>
      </Article>
      <CommentsCorrectionsList>
        <CommentsCorrections RefType="ErratumIn">
          <RefSource>J Clin Methods. 2025.</RefSource><PMID>87654321</PMID>
        </CommentsCorrections>
      </CommentsCorrectionsList>
    </MedlineCitation>
    <PubmedData>
      <ArticleIdList>
        <ArticleId IdType="pubmed">12345678</ArticleId>
        <ArticleId IdType="doi">10.1000/test</ArticleId>
        <ArticleId IdType="pmc">PMC123456</ArticleId>
      </ArticleIdList>
    </PubmedData>
  </PubmedArticle>
</PubmedArticleSet>
"""


def crossref_payload(title: str = "Validated outcome score for cohort studies"):
    return {
        "message": {
            "DOI": "10.1000/test",
            "title": [title],
            "author": [
                {"family": "Wang", "given": "Lin"},
                {"family": "Chen", "given": "Mei"},
            ],
            "container-title": ["Journal of Clinical Methods"],
            "published-print": {"date-parts": [[2024]]},
            "relation": {
                "is-corrected-by": [
                    {"id-type": "doi", "id": "10.1000/test.erratum"}
                ]
            },
        }
    }


class FakeTransport:
    def __init__(
        self,
        *,
        fail_pubmed: bool = False,
        empty_pubmed: bool = False,
        crossref_title: str | None = None,
    ):
        self.fail_pubmed = fail_pubmed
        self.empty_pubmed = empty_pubmed
        self.crossref_title = crossref_title

    def get_json(self, url: str):
        if "esearch.fcgi" in url:
            if self.fail_pubmed:
                raise verify_sources.RetrievalError("offline")
            if self.empty_pubmed:
                return {"esearchresult": {"idlist": []}}
            return {"esearchresult": {"idlist": ["12345678"]}}
        if "/works/" in url:
            return crossref_payload(self.crossref_title or "Validated outcome score for cohort studies")
        if "query.title=" in url:
            return {
                "message": {
                    "items": [
                        crossref_payload(
                            self.crossref_title or "Validated outcome score for cohort studies"
                        )["message"]
                    ]
                }
            }
        raise AssertionError(f"unexpected JSON URL: {url}")

    def get_xml(self, url: str):
        if self.fail_pubmed:
            raise verify_sources.RetrievalError("offline")
        if "efetch.fcgi" not in url:
            raise AssertionError(f"unexpected XML URL: {url}")
        return ET.fromstring(PUBMED_XML)


class VerifySourcesTests(unittest.TestCase):
    def test_doi_cross_checks_metadata_without_claim_verification(self):
        record = verify_sources.verify_one(
            "https://doi.org/10.1000/TEST",
            FakeTransport(),
            retrieved_at="2026-07-13T00:00:00+00:00",
        )
        self.assertTrue(record["metadata_verified"])
        self.assertFalse(record["claim_verified"])
        self.assertEqual(record["full_text_status"], "pmc_available")
        self.assertEqual(record["retrieved_at"], "2026-07-13T00:00:00+00:00")
        self.assertTrue(record["evidence_id"].startswith("EVID-"))
        relation_types = {item["type"] for item in record["relations"]}
        self.assertIn("ErratumIn", relation_types)
        self.assertIn("is-corrected-by", relation_types)

    def test_pmid_uses_crossref_when_doi_is_present(self):
        record = verify_sources.verify_one("12345678", FakeTransport())
        self.assertEqual(record["query"]["type"], "pmid")
        self.assertEqual(record["metadata"]["doi"], "10.1000/test")
        self.assertEqual(record["verification_scope"], "cross_source")
        self.assertTrue(record["metadata_verified"])

    def test_title_conflict_remains_unverified(self):
        record = verify_sources.verify_one(
            "Validated outcome score for cohort studies",
            FakeTransport(crossref_title="Unrelated laboratory experiment"),
        )
        self.assertFalse(record["metadata_verified"])
        self.assertEqual(record["field_checks"]["title"], "conflict")

    def test_single_source_title_must_match_the_query(self):
        record = verify_sources.verify_one(
            "Validated outcome score for cohort studies",
            FakeTransport(
                empty_pubmed=True,
                crossref_title="Unrelated laboratory experiment",
            ),
        )
        self.assertFalse(record["metadata_verified"])
        self.assertEqual(record["verification_scope"], "single_source")
        self.assertEqual(record["field_checks"]["query_identity"], "conflict")

    def test_network_failure_is_explicit_and_never_fills_claim(self):
        record = verify_sources.verify_one(
            "10.1000/test", FakeTransport(fail_pubmed=True)
        )
        self.assertFalse(record["metadata_verified"])
        self.assertEqual(record["source_status"]["pubmed"], "retrieval_failed")
        self.assertFalse(record["claim_verified"])
        self.assertTrue(record["errors"])
        serialized = json.dumps(record, ensure_ascii=False)
        self.assertNotIn("full text verified", serialized.casefold())

    def test_failed_queries_keep_distinct_stable_evidence_ids(self):
        first = verify_sources.verify_one("10.1000/first", FakeTransport(fail_pubmed=True))
        repeated = verify_sources.verify_one("10.1000/first", FakeTransport(fail_pubmed=True))
        second = verify_sources.verify_one("10.1000/second", FakeTransport(fail_pubmed=True))
        self.assertEqual(first["evidence_id"], repeated["evidence_id"])
        self.assertNotEqual(first["evidence_id"], second["evidence_id"])


if __name__ == "__main__":
    unittest.main()
