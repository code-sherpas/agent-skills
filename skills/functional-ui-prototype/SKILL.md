---
name: functional-ui-prototype
description: Build functional UI/UX prototypes that run entirely in the browser. Use when creating, extending, or refactoring a prototype that must look and behave like a complete feature without touching backend code. All data persistence is simulated through localStorage with realistic latency so the prototype can be used under the same conditions as a full implementation. Backend modification is strictly prohibited.
---

# Functional UI Prototype

## Goal

Produce a browser-based, fully interactive prototype that is indistinguishable in behavior from a feature backed by a real server. The prototype must use localStorage as its persistence layer, simulate realistic network latency on every data operation, and meet the same quality bar as production code in both visual fidelity and code standards.

## Constraints

### No Backend Changes

Do not create, modify, or extend any backend code, API route, server endpoint, serverless function, database migration, or server-side configuration. The prototype must be entirely self-contained in the frontend.

### Production-Grade Quality

A prototype is not an excuse for lower quality. Apply the same standards the project enforces for production code:

- Visual quality must match the project's existing UI.
- Code quality must pass the project's linting, formatting, and type-checking rules.
- Component structure, naming, file organization, and styling must follow the project's established conventions.

### Responsive to All Supported Display Modes

The prototype must support every screen size, viewport, orientation, and display mode that the project's application already supports. If the application is responsive, the prototype is responsive. If the application supports specific breakpoints, the prototype honors those breakpoints. Do not build for a single viewport and leave other supported sizes broken or degraded.

## Workflow

### 1. Detect the Project Stack and Conventions

Before writing any code:

- Identify the framework, component model, styling approach, design-system packages, state management, and data-fetching patterns already in use.
- Read existing components, pages, and data-access layers to understand how the project structures frontend code.
- Identify how the project handles loading states, error states, empty states, and optimistic updates, because the prototype must behave the same way.
- Identify the project's existing conventions for abstracting data access so the localStorage layer follows the same patterns.

### 2. Design the Local Data Layer

Build a data layer that mirrors how the project would interact with a real backend:

- Store all prototype data in localStorage using structured keys that avoid collisions with other application data. Use a consistent key prefix or namespace for all prototype entries.
- Model the data shapes as the project would model them. Use the same types, interfaces, or schemas the feature would use with a real API.
- Expose the data layer through the same abstraction the project uses for data access. If the project uses repositories, build a repository. If it uses hooks, build hooks. If it uses services, build services. Match the pattern.
- Every read and write operation must go through a simulated latency delay before resolving. This includes creates, reads, updates, deletes, listings, and any filtered or paginated queries.

### 3. Simulate Realistic Latency

Wrap every data operation in an asynchronous delay that mimics real-world network conditions:

- Use reasonable latency ranges that reflect typical web application behavior. Reads are generally faster than writes. Bulk operations take longer than single-item operations.
- Add slight random variation to each delay so the UI does not feel artificially uniform.
- The delay must happen before the operation resolves, not after. The caller must await the result as it would with a real network call.
- Never skip the delay, even during development. The purpose is to validate that the UI handles asynchronous flows correctly under realistic timing.

### 4. Handle Async UI States

Because every operation is asynchronous, the UI must present appropriate feedback at every stage:

- Follow the project's existing patterns for loading indicators, skeleton screens, spinners, progress bars, or any other feedback mechanism already in use.
- Show loading feedback during the simulated delay. Do not let the UI appear frozen or unresponsive.
- Handle and display error states if the prototype simulates failure scenarios.
- Handle empty states when no data exists in localStorage yet.
- If the project uses optimistic updates, apply the same technique in the prototype.

### 5. Build the UI

Construct the interface following every convention the project already enforces:

- Use the project's existing components, design-system primitives, and styling tokens before creating new ones.
- Follow the project's component composition patterns, naming conventions, and file structure.
- Build the prototype so it integrates naturally into the existing application. Navigation, routing, layout, and shared state must work as they do for any other feature.
- Make the prototype fully interactive. Every button, form, list, detail view, modal, and transition must work. Do not leave placeholder interactions or non-functional elements.

### 6. Ensure Data Survives Across Sessions

Verify that the localStorage layer behaves like durable storage:

- Data written during one session must be available when the user reloads the page or reopens the browser.
- The prototype must initialize correctly whether localStorage is empty or already contains data from a previous session.
- Provide a way to reset the prototype data without clearing unrelated localStorage entries. This can be a developer-facing utility or a visible control in the prototype UI, depending on the project's preference.

## Review Questions

When reading or reviewing prototype code, ask:

- Does any code touch backend files, API routes, or server-side logic?
- Does the data layer follow the same abstraction the project uses for real data access?
- Does every data operation go through a simulated asynchronous delay?
- Does the UI show appropriate loading feedback during delays?
- Does the visual quality and code structure match the rest of the project?
- Does the prototype work correctly at every screen size and display mode the project supports?
- Does data persist across page reloads?
- Are localStorage keys namespaced to avoid collisions?

If any answer is no, fix it before considering the work complete.

## Report the Outcome

When finishing the task:

- State which features the prototype covers and confirm that all interactions are functional.
- State which data-access abstraction was used and confirm it matches the project's patterns.
- State the simulated latency ranges applied to read and write operations.
- State how loading, error, and empty states are handled and confirm they follow project conventions.
- State the localStorage key namespace used.
- State how to reset the prototype data.
- State which screen sizes or display modes were verified and confirm they match the project's supported targets.
- Confirm that no backend code was created or modified.
