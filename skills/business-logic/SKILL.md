---
name: business-logic
description: Identify, interpret, review, or write business logic in code. Use when an agent needs to decide whether code expresses business rules, business algorithms, or business workflows, or when it must implement, preserve, or refactor code that creates, stores, or transforms data according to real business policies.
---

# Business Logic

## Goal

Define business logic as the rules, algorithms, and workflows in software that govern how data is created, stored, and transformed so real business policies become automated actions.

Treat business logic as purpose-driven code. The key question is not where the code lives, but whether the code expresses a business rule, business decision, business constraint, or business workflow.

## What Counts as Business Logic

Classify code as business logic when it does one or more of these things:

- applies a business rule or policy
- makes a business decision from domain data
- calculates a business outcome with domain meaning
- enforces a business constraint or invariant
- changes data according to a business workflow
- controls status or lifecycle transitions with business meaning
- derives values that represent a business concept
- coordinates a sequence of domain actions required by a business process

Business logic often appears in code that answers questions such as:

- whether something is allowed
- how something must be priced, approved, assigned, scheduled, ranked, or settled
- when data can be created, updated, completed, cancelled, renewed, or expired
- which values must be produced from business inputs

## Detection Workflow

1. Read the code for business meaning first.
   - Look for domain terms, business concepts, policy names, state names, and vocabulary used by the product, company, or industry.
   - Pay attention to rules that would matter even if the implementation language or framework changed.

2. Identify the business outcome controlled by the code.
   - Determine what business decision or business state change the code produces.
   - Check whether the code changes how data is created, stored, or transformed in a way that reflects a real policy or workflow.

3. Trace the rule to inputs, decisions, and outputs.
   - Identify the domain inputs the rule depends on.
   - Identify the conditions, thresholds, formulas, transitions, and side effects that carry business meaning.
   - Identify the resulting domain state, persisted data, or downstream action.

4. Prefer semantic classification to file or framework conventions.
   - Do not assume code is or is not business logic only because of its folder, class name, framework role, or transport boundary.
   - Classify by what the code means for the business.

## Writing or Changing Business Logic

1. Preserve the business meaning before refactoring.
   - Restate the rule in plain language before changing the code.
   - Keep domain terms explicit in names, branches, and data structures.

2. Make business decisions legible.
   - Express thresholds, formulas, eligibility checks, lifecycle transitions, and workflow steps clearly.
   - Prefer code shapes that reveal the rule instead of hiding it behind incidental implementation detail.

3. Keep business rules explicit.
   - Avoid scattering one rule across many unrelated edits when a cohesive expression is possible.
   - When multiple steps form one workflow, keep the sequence understandable as a single business process.

4. Protect domain invariants.
   - Verify that edited code still enforces the required business constraints.
   - Verify that transformed or persisted data still matches the intended business outcome.

## Review Questions

When reading or reviewing code, ask:

- What business rule or policy is encoded here?
- What business decision does this branch, formula, or workflow make?
- Which domain inputs drive that decision?
- What business state or business data changes as a result?
- Would a change here alter real business behavior?

If the answer is yes, treat the code as business logic.

## Report the Outcome

When finishing the task:

- state which code was identified or treated as business logic
- state which business rules, algorithms, or workflows were implemented or preserved
- state which business inputs, decisions, and outcomes were affected
