# agent-skills

Agent skills shared across Code Sherpas repositories, in the [Agent Skills](https://agentskills.io/) format and installed with `npx skills`.

**In Claude Code they also ship inside the `base` plugin** of [code-sherpas/claude-code-plugins](https://github.com/code-sherpas/claude-code-plugins), as `/base:<skill>`. The plugin takes them from this repository through a git submodule, never a copy: a commit here reaches it on its own — Dependabot opens the pull request, it merges once the plugin's checks pass — so **this repository stays their single source of truth. Change a skill here.** Every skill must keep to the [specification](https://agentskills.io/specification), with only the six fields it defines: the plugin's checks refuse anything else.

A skill here is a **procedure**: a sequence of steps an agent executes inside a concrete task, relevant only while that task is running.

Principles, patterns and conventions are **not** skills. They state what code must look like regardless of the task at hand, so they live in [code-sherpas/software-development-standards](https://github.com/code-sherpas/software-development-standards) and are read by URL instead of being installed.

## Skills

- [`fix-error`](skills/fix-error/SKILL.md) — fix a reported error following the project's standards for resolving errors.
- [`refine`](skills/refine/SKILL.md) — refine a request into one task in the project's task tracker, following the project's standards for refining work.
- [`to-increments`](skills/to-increments/SKILL.md) — split a refined task into increments of functionality usable in production, following the project's standards for splitting work into increments.
- [`build-prototype`](skills/build-prototype/SKILL.md) — build, extend or review an interactive prototype following the project's standards for state-coherent prototypes.

## Contributing

`main` changes only through the merge queue, as in alexandria-web-application: `gh pr merge <n>` puts a pull request in it, and the queue's build of the tree that will land must pass `quality_checks`. A push to a pull request runs nothing, so a green pull request means nothing has been checked yet. The build runs the Agent Skills specification check of [claude-code-plugins](https://github.com/code-sherpas/claude-code-plugins) (`plugins/base/skills.test.ts`) against this repository, the same check that gates bringing these skills into the `base` plugin.
