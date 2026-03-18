# Reuse Checklist

## Search Existing Building Blocks

Search by semantic role before searching by exact file name.

- Look for names such as `Card`, `Panel`, `Tile`, `Hero`, `Banner`, `Section`, `Modal`, `Dialog`, `Drawer`, `Tabs`, `Accordion`, `ListItem`, `Row`, `Stack`, `Field`, `FormRow`, `EmptyState`, `CTA`, `Avatar`, `Badge`, `Tag`, `Stat`, `Metric`, `Media`, `Split`, or `Shell`.
- Search for composition APIs such as `children`, `slot`, `slots`, `variant`, `size`, `tone`, `intent`, `as`, `asChild`, `render`, `component`, `className`, or `classes`.
- Search for existing imports from the project's chosen UI system before inventing a new primitive.

Useful commands:

```bash
rg -n "(Card|Panel|Tile|Hero|Banner|Section|Modal|Dialog|Drawer|Tabs|Accordion|ListItem|Field|EmptyState|Badge|Avatar|Stat)" src app components
rg -n "(children|slot|slots|variant|size|tone|intent|as=|asChild|render|component=|className)" src app components
rg -n "<(div|section|article|header|footer|aside|ul|li|p|a|img|button|input|span|svg)\\b" src app components
```

Use the third search to find places that may need extraction, not as the primary way to build new UI.

## Map the Stack to Its Low-Level Primitives

Treat these as the low-level layer that should stay mostly inside reusable primitives:

- React, Preact, Solid, Astro JSX: native DOM tags in JSX
- Vue, Svelte, Angular: native template tags
- Web Components: raw HTML inside custom elements
- Rails, Laravel, Phoenix, Django, Twig, Handlebars, Nunjucks, ERB, Blade, HEEx, Jinja: direct template markup, partial internals, and helper-generated raw structure
- Design-system wrappers such as `Box`, `Flex`, `Stack`, `Text`, `Link`, `Image`, or `Container`: low-level primitives when they are used only as layout glue

Use low-level wrappers to build shared primitives. Prefer higher-level components in feature code.

## Recognize a Good Generalization Candidate

Generalize an existing component when most of the following are true:

- Reuse the same layout skeleton or interaction pattern
- Change mostly text, media, actions, or small styling details
- Already pass some configuration through props, slots, or children
- Duplicate the same raw markup in more than one place if left unchanged
- Can preserve current callers with default props or a thin wrapper

Do not generalize when the overlap is superficial and the underlying semantics are different.

## Extract After Writing New Code

Extract a smaller reusable component when any of the following appears:

- A block has a clear semantic name such as `SectionHeader`, `ActionBar`, `MediaCard`, `InfoRow`, `EmptyState`, or `StatGrid`
- A feature component repeats the same cluster of low-level nodes more than once
- A feature component needs several low-level siblings just to express one visual idea
- A component becomes easier to read if one markup cluster gets a name

Prefer local feature-shared components first. Promote to global shared components only after the abstraction proves useful beyond one feature area.
