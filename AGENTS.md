# AGENTS.md

## On initiating an agent session

Always ask user if they want to update skills in `skills-lock.json`.

## What belongs in this repository

This repository holds **skills**: procedures an agent executes inside a concrete task, relevant only while that task is running.

Principles, patterns, conventions, style rules and architecture rules do **not** belong here. They are normative statements about how code must look, independent of any task, and they live in [code-sherpas/software-development-standards](https://github.com/code-sherpas/software-development-standards), where consuming repositories read them by URL.

Before adding anything to `skills/`, decide which of the two it is. If it describes what the code must look like rather than a procedure to follow, it belongs in the standards repository.

## Agent Skills

Follow the "Agent Skills" format when you are asked to, or need to, create skills that agents can understand.
The official website is [https://agentskills.io/](https://agentskills.io/). Write skills in English unless instructed otherwise.

## The `base@code-sherpas` plugin

`.claude/settings.json` enables the `base` plugin of the [Code Sherpas Claude Code marketplace](https://github.com/code-sherpas/claude-code-plugins), which no repository copies. It brings the automated checks backing the [software development standards](https://github.com/code-sherpas/software-development-standards) and the Code Sherpas agent skills (`/base:fix-error`, `/base:build-prototype`, …) from [code-sherpas/agent-skills](https://github.com/code-sherpas/agent-skills), their single source of truth: change a skill there, never here.

⚠️ **The repository's settings switch it on, but do not install it.** In an interactive session where it is not installed, `base` does not load, and there are no checks and no skills. Install it **once per machine**, switched off, so that only Code Sherpas repositories switch it on:

```bash
claude plugin marketplace add code-sherpas/claude-code-plugins
claude plugin install base@code-sherpas --scope user
claude plugin disable base@code-sherpas --scope user   # without this, it also runs outside Code Sherpas
```

If a session does not offer `/base:fix-error`, this step is missing.
