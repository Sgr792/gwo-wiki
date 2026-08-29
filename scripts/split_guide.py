from __future__ import annotations

import re
from pathlib import Path


SOURCE = Path(
    r"C:\Users\admin\Documents\Codex\2026-07-10\019ebc67-e700-7df3-b453-7f537abc99af-2"
    r"\1-21-1-neoforege-m4-556\docs\GWO内容包完整制作教程.md"
)
OUTPUT = Path(__file__).resolve().parents[1] / "docs" / "guide"

PAGES = [
    ("getting-started", "快速开始", range(1, 7)),
    ("models", "Blender 模型规范", range(7, 8)),
    ("animation", "动画制作与导出规范", range(8, 9)),
    ("firearms", "枪械、弹药与材质", range(9, 13)),
    ("attachments-optics", "配件、瞄具与挂饰", range(13, 16)),
    ("melee", "独立近战武器", range(16, 17)),
    ("audio-ui", "声音、图标与改装界面", range(17, 20)),
    ("debugging-release", "重载、调试、性能与发布", range(20, 25)),
    ("reference", "权威参考文件", range(25, 26)),
]


def main() -> None:
    text = SOURCE.read_text(encoding="utf-8")
    matches = list(re.finditer(r"(?m)^## (\d+)\. .+$", text))
    sections: dict[int, str] = {}
    for index, match in enumerate(matches):
        number = int(match.group(1))
        end = matches[index + 1].start() if index + 1 < len(matches) else len(text)
        sections[number] = text[match.start() : end].rstrip() + "\n"

    OUTPUT.mkdir(parents=True, exist_ok=True)
    for order, (slug, title, numbers) in enumerate(PAGES, start=1):
        body = "\n\n".join(sections[number].rstrip() for number in numbers) + "\n"
        body = body.replace(
            "- [内容包制作指南（Animation Machine v2）](内容包制作指南.md)\n",
            "- 本页的动画制作与导出规范\n",
        )
        frontmatter = (
            "---\n"
            f"title: {title}\n"
            f"order: {order}\n"
            "category:\n"
            "  - 内容包制作\n"
            "---\n\n"
        )
        (OUTPUT / f"{slug}.md").write_text(frontmatter + body, encoding="utf-8", newline="\n")

    # The guide landing page is curated separately. Regenerating chapter pages
    # must not replace its learning routes and visual chapter cards.


if __name__ == "__main__":
    main()
