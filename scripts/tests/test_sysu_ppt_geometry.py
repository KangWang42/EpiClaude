from __future__ import annotations

import unittest
import xml.etree.ElementTree as ET
from pathlib import Path
from zipfile import ZipFile


ROOT = Path(__file__).resolve().parents[2]
EMU_PER_INCH = 914_400
NS = {
    "a": "http://schemas.openxmlformats.org/drawingml/2006/main",
    "p": "http://schemas.openxmlformats.org/presentationml/2006/main",
}


def layout_root(path: Path, layout_name: str) -> ET.Element:
    with ZipFile(path) as package:
        members = sorted(
            name
            for name in package.namelist()
            if name.startswith("ppt/slideLayouts/slideLayout")
            and name.endswith(".xml")
        )
        for member in members:
            root = ET.fromstring(package.read(member))
            common_slide = root.find("p:cSld", NS)
            if common_slide is not None and common_slide.get("name") == layout_name:
                return root
    raise AssertionError(f"layout not found: {layout_name}")


def vertical_boxes(root: ET.Element) -> list[tuple[float, float]]:
    boxes: list[tuple[float, float]] = []
    paths = (
        (".//p:sp", "p:spPr/a:xfrm"),
        (".//p:pic", "p:spPr/a:xfrm"),
        (".//p:grpSp", "p:grpSpPr/a:xfrm"),
    )
    for shape_path, transform_path in paths:
        for shape in root.findall(shape_path, NS):
            transform = shape.find(transform_path, NS)
            if transform is None:
                continue
            offset = transform.find("a:off", NS)
            extent = transform.find("a:ext", NS)
            if offset is None or extent is None:
                continue
            top = int(offset.get("y", "0")) / EMU_PER_INCH
            bottom = top + int(extent.get("cy", "0")) / EMU_PER_INCH
            boxes.append((top, bottom))
    return boxes


class SysuPptTemplateGeometryTests(unittest.TestCase):
    def assert_has_anchor(
        self,
        boxes: list[tuple[float, float]],
        *,
        top: float,
        bottom: float,
    ) -> None:
        self.assertTrue(
            any(
                abs(actual_top - top) <= 0.0001
                and abs(actual_bottom - bottom) <= 0.0001
                for actual_top, actual_bottom in boxes
            ),
            f"missing template anchor top={top}, bottom={bottom}",
        )

    def test_registered_header_anchors_match_template_artwork(self) -> None:
        assets = ROOT / "skills" / "sysu-ppt" / "assets"
        default_layout = layout_root(assets / "template.pptx", "3_空白")
        public_health_layout = layout_root(
            assets / "template-公卫学院.pptx", "Title and Content"
        )

        self.assert_has_anchor(
            vertical_boxes(default_layout), top=0.1392, bottom=0.8101
        )
        self.assert_has_anchor(
            vertical_boxes(public_health_layout), top=0.5000, bottom=1.0749
        )

        toolkit = (
            ROOT / "skills" / "sysu-ppt" / "scripts" / "sysu_toolkit.R"
        ).read_text(encoding="utf-8")
        for fragment in (
            "anchor_bottom = 0.8101",
            "anchor_bottom = 1.0749",
            "top = 1.0349",
            ".validate_header(reg$header)",
            'assign("header",      reg$header,      .ACT)',
        ):
            self.assertIn(fragment, toolkit)
        self.assertNotIn("G$title", toolkit)


if __name__ == "__main__":
    unittest.main()
