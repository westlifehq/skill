---
name: summary-html
description: Generates a highly-polished, aesthetically pleasing HTML file summarizing the conversation or provided context. Use when the user asks to "summarize the conversation as HTML", "generate an HTML summary", or "export our chat to a beautiful HTML file on my desktop".
---

# HTML Conversation Summarizer

This skill takes the current conversation context (or provided text) and formats it into a stunning, production-ready HTML file saved directly to the user's Desktop.

## Usage Guidelines

When triggered, follow these exact steps:

1. **Analyze the Context**: Review the recent conversation history or the specific topic the user wants summarized.
2. **Read the Template**: Read the HTML boilerplate from `assets/template.html`.
3. **Structure the Content**: Write the summary using HTML structure that fits the template's CSS:
   - Use `<div class="section">` for main topics.
   - Use `<h2>` for section titles.
   - Use `<ul>` and `<li>` for bullet points.
   - Use `<div class="code-block"><code>...</code></div>` for any code snippets.
   - Use `<blockquote>` for important quotes or callouts.
4. **Replace Placeholders**: 
   - Replace `{{TITLE}}` with a short, catchy title for the summary.
   - Replace `{{DESCRIPTION}}` with a 1-2 sentence high-level overview.
   - Replace `{{DATE}}` with the current date (e.g., "Oct 24, 2023").
   - Replace `{{CONTENT}}` with your structured HTML summary.
5. **Save to Desktop**: Choose a relevant, web-safe filename (e.g., `react_hooks_summary.html`) and write the final compiled HTML directly to the user's Desktop (`/Users/xi/Desktop/<filename>.html`).

## Design Philosophy

The output should not look like a generic markdown export. It must feel premium, using the dark-mode aesthetic provided in the template:
- Be concise but thorough in the summary.
- Highlight key insights.
- Do NOT output raw markdown formatting (like `**bold**`) inside the HTML; use proper HTML tags (`<strong>bold</strong>`).

## Example Content Structure

```html
<div class="section">
    <h2>Core Concepts Discussed</h2>
    <p>We covered the fundamental differences between the two architectural patterns.</p>
    <ul>
        <li>First point of discussion regarding performance.</li>
        <li>Second point about scalability constraints.</li>
    </ul>
</div>

<div class="section">
    <h2>Action Items</h2>
    <ul>
        <li>Refactor the authentication middleware.</li>
        <li>Update the deployment scripts.</li>
    </ul>
</div>
```

**CRITICAL**: Do not ask the user for permission to write the file, just write it to the Desktop and inform them it is ready to view.
