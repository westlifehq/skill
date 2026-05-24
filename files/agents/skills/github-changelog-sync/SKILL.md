---
name: github-changelog-sync
description: Before syncing code to GitHub, scan the repo for existing changelog-like files, update the canonical changelog in place when one exists, and create a new CHANGELOG.md only when none can be found.
argument-hint: "Sync code and update changelog"
---

# GitHub Changelog Sync

This skill standardizes how changelog updates are handled before code is synced to GitHub.

Use it when the user asks to push code, sync to GitHub, merge to `main`, update release notes, or record the current round of changes.

## When to use

Trigger this skill when the user's intent includes any of the following:

- "同步到 GitHub"
- "推到仓库"
- "提交代码"
- "更新 changelog"
- "把这次改动记录下来"
- "发版前补一下变更说明"

## Core rule

**Never create a new `CHANGELOG.md` until you have searched the whole repository and confirmed there is no existing changelog-like file already in use.**

Repositories may be maintained by multiple AI tools or humans, so changelog conventions may differ. The skill must detect and reuse the existing source of truth whenever possible.

## Trigger semantics

This skill should trigger on requests such as:

- "同步到 GitHub"
- "推到仓库"
- "提交代码"
- "更新 changelog"
- "把这次改动记录下来"
- "发版前补一下变更说明"
- "merge 到 main 前把记录补齐"
- "发版前更新 release notes"

## Workflow

1. **Preflight: gather change context first**
   - Read current git context:
     - branch name
     - latest commit hash (if exists)
     - changed files (`staged`, `unstaged`, and recent commit scope when relevant)
   - Derive release/version style from existing tags, changelog headers, or README version patterns.

2. **Scan repository before any write**
   - Search the full repo for changelog-like candidates, including but not limited to:
     - `CHANGELOG.md`
     - `Changelog.md`
     - `changelog.md`
     - `HISTORY.md`
     - `history.md`
     - `RELEASE_NOTES.md`
     - `release-notes.md`
     - `docs/CHANGELOG.md`
     - `docs/changelog.md`
     - `docs/HISTORY.md`
   - Search `README*`, `docs/**`, release docs, and contribution guides for links or mentions of:
     - `changelog`
     - `history`
     - `release notes`
     - `what's new`

3. **Resolve the canonical changelog (single source of truth)**
   - If exactly one obvious file exists, use it.
   - If multiple candidates exist, rank with this precedence:
     1. Explicitly linked from `README` or docs as the updates source.
     2. File with active, continuous history and newest entries.
     3. File whose version/date heading style matches recent releases.
     4. Root-level canonical name over archived/legacy files.
   - Update only one canonical file.
   - Do not create a second active changelog.

4. **Create `CHANGELOG.md` only if no candidate exists**
   - Only after full scan returns no usable changelog-like file.
   - Create `CHANGELOG.md` at repository root.
   - Initialize with newest-first (reverse chronological) structure.

5. **Read existing content before editing**
   - Always read the canonical changelog first.
   - Preserve all historical entries.
   - Insert new entry at top (newest first), following existing heading style.

6. **Write detailed, auditable entries**
   - Each new entry must include:
     - timestamp (local time and/or UTC)
     - version number (follow existing style such as `v1.2.3`, `1.2.3`, date-version)
     - branch and/or commit reference if available
     - changed file scope (key directories/files)
     - major additions
     - major fixes
     - behavior changes / compatibility impact
     - risks, caveats, migration or rollout notes
   - Use concrete statements tied to actual diffs.
   - Never use vague phrases such as "fix some issues" or "misc updates".

7. **Synchronize docs only when directly related**
   - If `README` or docs include release/changelog pointers or version badges that should move with this update, update those references.
   - Keep documentation edits minimal and relevant to the same release/change set.
   - Do not introduce unrelated edits.

## Canonical detection checklist

When multiple files exist, confirm all items before writing:

- Is this file referenced as the official history in `README`/docs?
- Does it contain the latest release entry?
- Is its format consistent with current repo versioning style?
- Is another file clearly marked `archive`, `legacy`, or historical-only?
- Will editing this file avoid duplicate changelog streams?

If the answer is ambiguous, prefer the file explicitly linked by `README` or release docs.

## Entry template (newest on top)

```markdown
## [<version-or-unreleased>] - <YYYY-MM-DD HH:mm TZ>

### Metadata
- Branch: <branch-name>
- Commit: <short-sha or N/A>
- Scope: <files/directories changed>

### Added
- <specific feature or capability>

### Fixed
- <specific bug and affected behavior>

### Behavior Changes / Compatibility
- <what changed for users/integrators>

### Risks / Notes
- <migration note, rollout caution, known limitation>
```

If the repository already uses another section style (for example `Changed`, `Removed`, `Security`), follow that style instead of forcing this template.

## Output expectations

The changelog entry should be specific enough that someone can later answer:

- What changed?
- When did it change?
- Which files or areas were affected?
- Was this a fix, a feature, or a breaking/behavioral change?

## Example

If the user says:

> "把这次改动同步到 GitHub，并把变更写进 changelog"

Then the skill should:

1. Search the repository for existing changelog-like files.
2. Read the likely canonical changelog file, if present.
3. Update that file with a new top entry describing the current changes.
4. Only create `CHANGELOG.md` if no existing changelog convention can be found anywhere in the repo.
5. Optionally update `README.md` if it carries version or release-summary metadata tied to the same change set.

## Anti-patterns

Avoid these mistakes:

- Creating a new `CHANGELOG.md` when the repo already uses `HISTORY.md` or another changelog file.
- Maintaining multiple changelog files for the same repository without need.
- Writing vague entries like "misc fixes" or "update code."
- Replacing old history instead of appending a new top entry.
- Updating changelog content without checking the actual code diff or changed files.
- Appending new entries to the bottom (must be newest first at top).
- Overwriting prior changelog content while "refreshing format."
- Updating README/version links when they are unrelated to this specific release.

## Operational constraints

- Scan first, write second. Never skip scan.
- Read before edit. Never blind-write changelog files.
- Update exactly one canonical changelog target.
- Create root `CHANGELOG.md` only when no changelog-like file exists anywhere in repo.
- Keep changelog language concrete, auditable, and traceable to real diffs.
