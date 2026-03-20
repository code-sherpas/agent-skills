# AGENTS.md

## On initiating an agent session

Always ask user if they want to update skills in `skills-lock.json`.

## Agent Skills

Follow the "Agent Skills" format when you are asked to, or need to, create skills that agents can understand.
The official website is [https://agentskills.io/](https://agentskills.io/). Write skills in English unless instructed otherwise.

### Keeping skills up to date

When you are asked, or need, to update the skills in this project (they are located in the `.agents/skills` directory), use the standard update command from [https://agentskills.io/](https://agentskills.io/) (at the time of writing, `npx skills update`).

As of today, if the skills were installed with the project scope rather than globally, the update command does not detect changes.
If that happens, as a fallback, run `npx skills add [repository] --skill [skill]` for each skill listed in `skills-lock.json` and present in the `.agents/skills` directory.

Example: `npx skills add https://github.com/github/awesome-copilot --skill git-commit`.

If you are asked which agents to install the skill for, select the default option.

If you are asked for the skill scope, select `Project`.

If you are asked for the installation method, select `Symlink`.
