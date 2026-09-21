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
