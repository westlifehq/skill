---
name: skill-authoring-workflow
description: Turn raw content into a compliant VS Code/Copilot skill. Use when creating, updating, validating, or adapting SKILL.md folders, resources, scripts, and metadata.
argument-hint: "Describe the skill to create, update, validate, or adapt"
---

## Purpose

Create or update skills without chaos. This workflow turns rough notes, workshop content, or half-baked prompt dumps into compliant `SKILL.md` assets that work in VS Code/Copilot.

Use it when you want to ship a new skill without "looks good to me" roulette.

## Key Concepts

### Dogfood First

Use VS Code/Copilot skill standards before inventing a custom process:
- Skill folder: `~/.agents/skills/<skill-name>/` for personal skills, or `.github/skills/<skill-name>/` for project skills.
- Required file: `SKILL.md`.
- Required frontmatter: `name` and `description`.
- Optional frontmatter: `argument-hint`, `user-invocable`, `disable-model-invocation`.

### Pick the Right Creation Path

- **Guided conversation**: Best when the user has an idea but not final prose.
- **Content-first conversion**: Best when the user already has source material, an AntiGravity skill, or a long prompt.
- **Manual edit + validate**: Best for tightening an existing skill.

### Definition of Done (No Exceptions)

A skill is done only when:
1. Frontmatter is valid (`name`, `description`)
2. Section order is compliant
3. Metadata limits are respected (`name` <= 64 chars, `description` <= 1024 chars)
4. Cross-references resolve
5. References point to existing files with relative `./` paths

### Facilitation Protocol

When running this workflow as a guided conversation:

- Ask one question at a time when required information is missing.
- Prefer numbered options for user choices.
- Accept context dumps and convert them directly when enough information is present.
- If the source is an AntiGravity skill, preserve the useful workflow but convert metadata, paths, and tool names to VS Code/Copilot conventions.

## Application

### Phase 1: Preflight (Avoid Duplicate Work)

1. Search for overlapping skills:

Check the target skill directory (`~/.agents/skills`, `~/.copilot/skills`, `.github/skills`, or `.agents/skills`) for an existing folder with the same or overlapping name.

2. Decide type:
- **Component**: one artifact/template
- **Interactive**: 3-5 adaptive questions + numbered options
- **Workflow**: multi-phase orchestration

### Phase 2: Generate Draft

If you have source material, convert it into a skill folder:
- Create `<skill-name>/SKILL.md`.
- Move long details into `./references/`.
- Move reusable templates into `./assets/`.
- Move deterministic automation into `./scripts/`.
- Keep `SKILL.md` focused on trigger conditions, workflow, and resource links.

### Phase 3: Tighten the Skill

Manually review for:
- Clear "when to use" guidance
- One concrete example
- One explicit anti-pattern
- No filler or vague consultant-speak

### Phase 4: Validate Hard

Run strict checks before considering the skill done:
- `SKILL.md` starts and ends frontmatter with `---`.
- `name` matches the folder name exactly.
- `description` is present, keyword-rich, and <= 1024 characters.
- Relative links resolve.
- AntiGravity-only tool names, absolute paths, and unavailable scripts are removed or adapted.

### Phase 5: Integrate with Target Scope

If this is a new skill, place it in the requested scope:
1. Personal VS Code/Copilot skill: `~/.agents/skills/<skill-name>/`
2. Alternative personal location: `~/.copilot/skills/<skill-name>/`
3. Project skill: `.github/skills/<skill-name>/` or `.agents/skills/<skill-name>/`
4. Verify link paths resolve

### Phase 6: Optional Packaging

If the user wants to share the skill, package the folder as a normal directory or zip archive after validation.

## Examples

### Example: Turn Workshop Notes into a Skill

Input: raw notes or a source Markdown file  
Goal: new interactive advisor

Expected result:
- New skill folder exists
- Skill passes structural and metadata checks
- Resource links resolve

### Anti-Pattern Example

"We wrote a cool skill, skipped validation, forgot README counts, and shipped anyway."

Result:
- Broken references
- Inconsistent catalog numbers
- Confusion for contributors and users

## Common Pitfalls

- Shipping vibes, not standards.
- Choosing `workflow` when the task is really a component template.
- Bloated descriptions that exceed upload limits.
- Leaving references to missing repo scripts or unrelated source docs.
- Treating generated output as final without review.

## References

- VS Code/Copilot personal skills: `~/.agents/skills/<skill-name>/SKILL.md` or `~/.copilot/skills/<skill-name>/SKILL.md`
- VS Code/Copilot project skills: `.github/skills/<skill-name>/SKILL.md` or `.agents/skills/<skill-name>/SKILL.md`
