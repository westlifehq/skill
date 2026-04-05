---
name: memory
description: Triggered when the user asks to summarize the current conversation progress, save context, or update project context files. Evaluates conversation history and generates or updates five Markdown files (PROJECT_CONTEXT.md, CURRENT_STATUS.md, DECISIONS.md, NEXT_STEPS.md, WORKSPACE_RULES.md) to store persistent memory for cross-conversation use, and outputs a brief walkthrough summarizing the current session.
---

# Memory & Context Optimization

This skill is designed to distill the current state of a project and the conversation into reusable, persistent context files across chat sessions.

## Workflow

When triggered, perform the following actions sequentially:

1. **Analyze Conversation & Project State**
   - Review what has been discussed, decided, and accomplished in the current conversation.
   - Review any existing documentation if present.

2. **Generate or Update Context Files**
   Use file system tools (`write_to_file`, `replace_file_content`, etc.) to generate or update the following five files in the root of the user's active project directory. 
   
   **CRITICAL:** If any of these files already exist, use `view_file` to read them first. **Update** their contents (e.g., adding to existing decisions or updating current status) instead of blindly overwriting them, to ensure past valid context is not lost.

   - `PROJECT_CONTEXT.md`: High-level project summary, core features, architecture, and technology stack.
   - `CURRENT_STATUS.md`: What has been completed, what is currently working, and known issues or bugs.
   - `DECISIONS.md`: Important design, architectural, or product decisions made, including the rationale behind them.
   - `NEXT_STEPS.md`: An actionable, prioritized list of upcoming tasks or features based on the latest conversation.
   - `WORKSPACE_RULES.md`: Long-term collaboration rules, specific coding styles, formatting preferences, tools, and workflow conventions the user expects.

3. **Output a Brief Walkthrough**
   - After successfully creating or updating all five files, provide a concise summary (walkthrough) to the user.
   - Briefly explain what was accomplished or discussed in this round of the conversation and confirm that the context files have been updated.

## Guidelines
- **Language**: Always use Simplified Chinese (简体中文) for the generated files and the walkthrough response, unless the user explicitly requests another language.
- **Formatting**: Be concise and structured. Use Markdown lists, bold text, and clear headings. Avoid unnecessary verbosity.
- **Accuracy**: Base the summaries strictly on the actual events and decisions of the current and past conversations.
