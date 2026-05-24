---
name: html-to-image-export
description: Convert HTML files or URLs into reliable high-resolution PNG images while preserving screen layout. Use when exporting webpages, local HTML, dashboards, reports, or UI designs to PNG/DPI images.
---

# HTML to Image Export

Use this skill for stable HTML-to-image export in VS Code/Copilot.

Task: Convert HTML into a reliable high-resolution PNG while preserving screen layout and avoiding brittle screenshot behavior.

Operating principles:
- Prefer image output over PDF.
- Prefer stability over aggressive in-browser scaling.
- Prefer a browser-automation workflow over raw browser screenshot flags.
- Prefer capturing the document container directly over capturing the whole viewport.

Execution contract:
1. Launch a local Chrome or Chromium browser through Playwright.
2. Open the source HTML or URL.
3. Wait until layout is stable and network activity is idle.
4. Emulate screen media.
5. Capture the fixed page container element, ideally `.page`.
6. Save a raw PNG.
7. If higher print sharpness is needed, upscale the raw PNG offline with an image library such as Pillow.
8. Save the final PNG with DPI metadata.
9. If a PDF is requested, derive it from the final PNG instead of switching to a print workflow.

Hard constraints:
- Do not use print preview or print-to-PDF as the primary conversion path.
- Do not default to `chrome --headless --screenshot` for local HTML because it can fail with blank white exports.
- Do not use CSS zoom tricks or transform-based scaling before the screenshot step.
- Do not depend on pseudo-element overlays for export-critical background effects.
- Do not use post-hoc edge detection cropping if the page container can be captured directly.

Failure recovery:
1. Blank image: switch to Playwright-driven local Chrome if not already using it.
2. Partial image: reset zoom to 1, remove transforms, and capture the fixed container directly.
3. Low resolution: keep the raw screenshot stable and upscale offline.
4. Responsive collapse: widen viewport slightly.
5. Broken design effects: move them into layered container backgrounds instead of overlay pseudo-elements.

Completion criteria:
- output PNG exists
- output PNG is not blank
- output PNG contains the full intended page content
- target DPI or output dimensions are reported