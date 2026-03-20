---
name: update-agent-skills
description: Update agent skills installed with the `skills` CLI. Use when asked to refresh installed skills, keep a project's skills current, or troubleshoot cases where `npx skills update` reports that everything is up to date even though a skill changed upstream.
---

# Update Agent Skills

## Goal

Refresh installed agent skills with the standard `skills` CLI workflow.

Use the normal update command first. If the skills were installed with project scope and the CLI does not detect upstream changes, reinstall each tracked project skill explicitly from its recorded source.

## Detect the Installation Scope

1. Check whether the target skills are project-scoped or global.
   - Project-scoped installs usually have a local `skills-lock.json` and one or more agent skill directories such as `.agents/skills/`, `.claude/skills/`, or `.augment/skills/`.
   - Global installs are typically tracked outside the project, for example in `~/.agents/.skill-lock.json` or `$XDG_STATE_HOME/skills/.skill-lock.json`.

2. Check which skills are actually managed by the `skills` CLI.
   - Use `skills-lock.json` or the relevant global lock file as the source of truth.
   - Do not assume custom or manually copied skills are tracked.

## Standard Update Flow

1. Run:

```bash
npx skills update
```

2. If the requested skill is updated, stop there.

3. If the CLI reports that all skills are up to date but the project-scoped skills are still stale, use the fallback flow below.

## Fallback Flow for Project-Scoped Skills

1. Open `skills-lock.json`.
2. Treat `skills-lock.json` as the source of truth for tracked skills.
3. Cross-check it against `.agents/skills/` and only keep skills that are both:
   - listed in `skills-lock.json`
   - present in `.agents/skills/`
4. For each matching skill, read its `source` and reinstall it explicitly:

```bash
npx skills add [repository] --skill [skill]
```

5. Repeat that command for every matching skill. Do not stop after the first one, and do not guess missing repositories manually.

Example loop:

```text
for each skill in skills-lock.json that also exists in .agents/skills:
  npx skills add [repository] --skill [skill]
```

Example:

```bash
npx skills add https://github.com/github/awesome-copilot --skill git-commit
```

6. If the `sourceType` is `github` and the `source` is recorded as `owner/repo` such as `github/awesome-copilot`, convert it to the repository form expected by the CLI, for example `https://github.com/owner/repo`.

## Interactive Choices

If the CLI prompts for installation details:

- Agent selection: choose the default option unless the task says otherwise.
- Scope: choose `Project` for project-scoped updates.
- Installation method: choose `Symlink`.

## Validation

Before finishing:

1. Confirm the target skill directory now contains the updated skill content.
2. Confirm the refreshed skill still matches the source and the expected skill name.
3. Call out if the standard update command did not detect a change and the explicit reinstall loop was required.

## Report the Outcome

When finishing the task:

- State whether `npx skills update` worked or the fallback reinstall flow was needed.
- State which skills were refreshed and from which repository.
- State whether the update was project-scoped or global.
