---
name: atomic-design
description: Create or update web UI components with a strict reuse-first workflow. Use when building, refactoring, restyling, or extending frontend or template components while minimizing raw DOM or HTML by reusing or generalizing existing components first.
---

# Build Web Components

## Reuse-First Rule

Treat raw DOM or HTML elements, or equivalent low-level primitives, as implementation details of reusable building blocks instead of the default way to assemble feature UI.

Follow this order every time:

1. Reuse an existing generic component.
2. Generalize an existing non-generic component and reuse it.
3. Write new code only after exhausting 1 and 2.
4. Extract smaller reusable pieces from the new code immediately.

Aim for feature components to be composed mostly of project components, design-system primitives, and framework-native composition mechanisms. Keep direct low-level nodes isolated inside reusable primitives whenever practical.

## Workflow

1. Detect the stack and local component model.
   - Identify the framework, styling approach, and design-system packages already in use.
   - Read nearby components before editing.
   - Load [references/reuse-checklist.md](references/reuse-checklist.md) for search heuristics, stack mappings, and extraction signals.

2. Search for reusable generic components first.
   - Search by behavior, structure, and visual role, not only by name.
   - Inspect shared component folders, design-system packages, feature libraries, and existing UI kits.
   - Prefer existing slots, variants, composition props, render props, and style tokens over copy-paste.
   - Avoid adding a new UI library unless the task explicitly requires it.

3. Search for a component that can be generalized if no generic component fits.
   - Look for the same layout skeleton or interaction model with feature-specific copy, icons, data, or styling.
   - Extract hard-coded content into props, slots, children, variants, or configuration.
   - Preserve current behavior for existing callers unless the task explicitly allows a breaking cleanup.
   - Reuse the generalized version instead of duplicating the original markup.

4. Write new code only after exhausting reuse and generalization.
   - Start with the smallest reusable boundary that can solve the task.
   - Introduce new primitives in the design-system or shared layer when the abstraction is broadly useful.
   - Keep raw platform nodes inside those primitives instead of spreading them across higher-level feature components.

5. Extract reusable subcomponents immediately after writing new code.
   - Extract repeated or clearly named markup clusters in the same task.
   - Prefer local feature-shared components first. Promote to global shared components only after the abstraction proves useful beyond one feature area.

6. Keep the final component tree high-level.
   - Make feature components read like product intent, not like DOM assembly.
   - Treat many direct low-level elements in a feature component as a smell and refactor further unless the structure is truly unique or semantically required.

## Generalize Safely

Generalize only when the abstraction has a stable shape.

- Extract variable content, actions, media, adornments, and state into props or slots.
- Rename components to domain-neutral names when they should escape their original feature.
- Prefer backward-compatible migration paths such as wrappers, aliases, or default props.
- Avoid speculative abstractions that do not have a clear second use case.

## Keep Raw Elements Contained

Treat this as the default quality bar instead of a literal hard limit:

- Keep near-zero raw HTML elements or equivalent low-level primitives in feature, page, and section components.
- Allow raw elements inside shared primitives because someone must encapsulate the platform.
- Use raw elements directly only for semantics that must stay explicit, framework constraints, tiny leaf wrappers, or brand-new primitives being extracted in the same task.
- Cluster any unavoidable low-level markup in a small number of reusable files.

## Report the Outcome

When finishing the task:

- State which existing components were reused.
- State which components were generalized and how.
- State which new reusable pieces were extracted if new code was required.
- State which raw low-level elements remain and why they could not be abstracted further.
