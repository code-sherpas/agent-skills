---
name: diagnose-and-fix-tracked-errors
description: Diagnose a bug surfaced by an error-tracking or observability tool — or a supplied stack trace or log — reach its root cause with evidence, and apply or propose the fix at the design-correct location, which is often not where the error manifests. Use when an agent must triage a tracked error event, reproduce the reported failure deterministically, isolate the origin through falsifiable hypotheses, decide which layer owns the violated invariant or rule, and fix plus regression-test at that layer before closing the loop in the tracking tool. The agent must defer to the project's observability tooling, agent instructions, and design conventions rather than assume any specific tool, error model, or architecture.
effort: max
---

# Diagnose and Fix Tracked Errors

## Goal

Turn an error that surfaced through an error-tracking or observability tool — or a stack trace or log someone pasted — into an evidence-backed root cause, and land the fix at the point the project's design says owns the violated rule, which is frequently not where the error was observed.

This is a method, not a tool. It rests on four commitments:

- **Reproduce before theorizing.** Build a deterministic way to trigger the exact symptom before reading code to form theories.
- **Isolate the origin.** Strip non-load-bearing layers until the origin is separated from the site where the failure became visible.
- **Drive root cause with falsifiable hypotheses.** Enumerate candidate causes, then disprove them one variable at a time.
- **Fix at the design-correct location.** The place that crashes is rarely the place that owns the invariant. Decide the owner by design before writing any fix, and place the fix — and its regression test — there.

The symptom's location and the cause's location are different questions. Answer both, in that order, and never let the first stand in for the second.

## What Counts as In Scope

Apply this skill when the task does one or more of these things:

- reports a bug through an error-tracking, observability, monitoring, or crash-reporting tool
- provides a stack trace, exception, log line, failing request, or crash report to investigate
- asks the agent to find why a failure happens and fix it, not merely to silence a specific error
- describes intermittent, environment-, data-, or timing-dependent failures observed in a running system

Do not apply this skill when:

- the task is to implement new behavior with no reported failure to diagnose
- the failure is a local, already-reproduced test that only needs the obvious edit, with no question about where the fix belongs
- the request is explicitly to suppress or downgrade an alert without addressing its cause — surface that this leaves the cause unaddressed

## Discover and Defer to the Project

This skill hardcodes no tool, error model, architecture, language, framework, or test runner. At runtime, discover the project's own conventions and defer to them. Two distinct discoveries are required.

1. Discover the observability and error-tracking surface, to extract error context.
   - Look for configured tools through config files, environment variables, MCP servers, installed SDKs, dashboards, and project docs.
   - From the tool, extract everything the event offers: error type and message, full stack trace, captured variables and breadcrumbs, session or replay, affected release or version, environment, whether the error was handled or unhandled, whether it originated client-side or server-side, request or job context, frequency and first-seen, and source maps or symbolication if the stack is minified.
   - Treat this context as the starting evidence, not the conclusion. A stack trace names the crash site, not the cause.

2. Discover the design conventions, to decide where the fix belongs.
   - Read the project's agent instructions file — `AGENTS.md`, `CLAUDE.md`, or equivalent — its style guides, its architecture and design docs, and the other design skills present in the repository.
   - Read the code around the fault to learn where invariants are enforced, where validation and authorization live, which layers may hold business logic, and where module or aggregate boundaries fall.
   - These sources supply the criteria for the location gate. Do not import an architecture the project has not chosen.

If a convention needed for a decision does not exist or does not cover the case, make the gap explicit and ask the human. Do not invent an architecture, an error model, or a layer ownership rule on the project's behalf.

## The Method

Work the phases in order. Earlier phases produce the evidence later phases depend on; skipping ahead produces guesses.

1. Triage the tracked event.
   - Pull the full context from the observability tool as described above.
   - Restate the symptom precisely: what failed, where it was observed, under which release and environment, handled or unhandled, how often.
   - Note whether the exception reached the tracker unhandled. An unhandled exception in the tracker usually means the condition escaped the project's error model — a signal to model or handle it upstream, not to catch it at the symptom site.

2. Reproduce deterministically — feedback loop first.
   - Before reading code to build theories, construct a repeatable way to trigger the exact symptom: a failing test, a script, a request replay, a seeded input.
   - If you catch yourself forming theories without a repro, stop and build the repro first.
   - Proportionality: match the repro to the bug. A stack trace with captured variables can be enough to justify a trivial guard; a subtle state- or timing-dependent fault needs a real harness. Regardless of repro effort, a regression test is always required later.
   - If it will not reproduce — environment-, data-, or race-dependent — raise the reproduction rate to something debuggable (tighten inputs, add instrumentation, stress the timing) or explicitly request the missing artifacts (session replay, data dump, heap dump, fuller logs). Do not speculate in place of reproducing.

3. Minimize and isolate the origin.
   - Remove layers that are not load-bearing for the failure — inputs, middleware, callers, data — until the smallest thing that still fails remains.
   - Separate the origin from the manifestation. The line that threw is where a bad state became visible, not necessarily where it was produced. Trace the bad state back to where it entered the system.

4. Form falsifiable hypotheses and test one variable at a time.
   - Before changing anything, write down three to five candidate causes, each stated so it could be proven wrong.
   - Rank them by likelihood and by cost to test.
   - Test each by changing exactly one variable against the repro, so a result cleanly confirms or kills one hypothesis. This is the engine of root cause: keep going until one hypothesis is confirmed by evidence, not by plausibility.

5. Run the location gate — decide the owner before writing the fix.
   - You now know the cause. Do not fix it yet. First decide which layer owns the violated rule, invariant, or decision by design, using the project's conventions. See "Location Gate Criteria" below.
   - Resist the pull toward the fastest green. Patching at the crash site usually turns the test green soonest and is usually the wrong layer.

6. Fix and regression-test at the design-correct layer.
   - Apply the fix where the owner lives, per the gate decision.
   - Put the primary regression test at that same layer — if the fix moved upstream, the test moves upstream with it, asserting the invariant the owner is now responsible for.
   - Optionally also keep a test at the symptom level proving the original event no longer reproduces. This documents the link between cause and symptom.
   - When the correct layer is outside the change you are authorized to make, propose the fix at that layer explicitly rather than silently patching a lower one.

7. Close the loop.
   - Reflect the resolution in the tracking tool the project uses: mark resolved, assign the fixing release, or annotate as its workflow expects.
   - Verify non-recurrence: confirm the repro no longer triggers and, where possible, that the tracked event stops arriving for the fixed release.
   - Write a brief post-mortem: the root cause in one or two sentences, and the one design change that would prevent this class of error from recurring.

## Location Gate Criteria

Root cause is not the same as fix location. After the cause is confirmed and before the fix is written, decide ownership deliberately.

- Name the violated rule, not the failing line. Identify the invariant, constraint, business rule, or decision that was broken — independent of where the break surfaced.
- Find the highest layer that owns that rule by design. Ownership belongs to the layer the project's conventions make responsible for guaranteeing the rule — where the concept's other invariants already live, the module or aggregate boundary the data belongs to, the layer permitted to hold business logic, or the point where validation, authorization, or construction rules already sit.
- Prefer the highest owning layer, not the lowest green-making one. Apply the test: if I fix only here, can the same rule still be violated through another path or caller? If yes, the fix is too low — move it up to where every path must pass.
- Treat an escaped exception as an error-model gap. If the failure reached the tracker unhandled, it likely slipped past the project's error model. Prefer modeling it as an explicit outcome — a domain error, a validated boundary, a guarded constructor — at the layer that owns that outcome, rather than adding a catch at the symptom.
- When ownership is genuinely ambiguous, or no convention covers it, make it explicit and ask. State the invariant, the candidate layers, and the trade-off, and let the human decide. Do not default to the crash site because it is nearest.

## Examples

Keep examples schematic. The pattern matters; the specific stack does not.

- A null dereference surfaces in a view when rendering an entity's optional field. The stack points at the template. But the entity was constructed earlier in a state the domain considers invalid. Owner: the entity's construction invariant. Fix upstream so the entity cannot be built in that state; the view code was only the first reader to trip over it. Regression test at the constructor asserting the invalid state is rejected; optionally a view-level test proving the original render no longer fails.

- A "duplicate key" error is thrown by the persistence layer on insert. The crash site is the database adapter. But the rule "this identifier is unique per tenant" is a business rule. Owner: the layer the project designates for business rules. Fix by enforcing uniqueness where that rule lives, converting the collision into a modeled domain outcome, rather than catching the database exception in the adapter.

- An unhandled exception from parsing an external payload reaches the tracker. The crash site is deep in a mapper. The rule is "external input must be validated at the boundary." Owner: the integration boundary. Fix by validating and translating at the boundary into the project's error model, so malformed input becomes a handled outcome instead of an escaped exception.

Schematic pseudocode — the fix moves from the symptom to the owner:

```ts
// Symptom site — tempting, but wrong layer: patches the reader, not the rule.
function render(entity) {
  const name = entity.owner?.name ?? "" // silences the crash; invariant still violable elsewhere
  return view(name)
}

// Design-correct layer: the entity may not exist without an owner.
class Entity {
  private constructor(readonly owner: Owner) {}
  static create(owner: Owner | null): Result<Entity, MissingOwnerError> {
    if (owner === null) return err(new MissingOwnerError()) // invariant owned here
    return ok(new Entity(owner))
  }
}
// Regression test asserts Entity.create(null) is rejected — every reader is now safe.
```

```py
# Symptom site — wrong layer.
def render(entity):
    name = entity.owner.name if entity.owner else ""  # silences crash; rule still violable
    return view(name)

# Design-correct layer — construction enforces the invariant.
@dataclass(frozen=True)
class Entity:
    owner: Owner

    @staticmethod
    def create(owner: Owner | None) -> "Entity":
        if owner is None:
            raise MissingOwnerError()  # invariant owned here
        return Entity(owner=owner)
# Regression test asserts Entity.create(None) is rejected.
```

## Review Questions

When reviewing whether this method was applied correctly, ask:

- Was the error context pulled from the project's own tracking or observability tool, or was the diagnosis based only on a pasted line?
- Was a deterministic reproduction built before theories were formed — or, if reproduction was impossible, were artifacts requested instead of speculating?
- Were three to five falsifiable hypotheses stated, and was each tested by changing one variable at a time?
- Was the origin distinguished from the manifestation, rather than treating the crash site as the cause?
- Before the fix, was the owning layer decided from the project's conventions, and is the fix at the highest layer that owns the invariant rather than the fastest place to turn the test green?
- If the exception had escaped the error model, was it modeled or handled upstream instead of caught at the symptom?
- Is there a regression test at the design-correct layer, and does the fix's location match the invariant's owner?
- Was the tracking tool updated and non-recurrence verified?
- Where a convention was missing or ambiguous, was the human asked instead of an architecture being invented?

## Report the Outcome

When finishing the task:

- state the symptom as tracked, and which observability tool and context it came from
- state how the failure was reproduced, or why it could not be and what was requested instead
- state the hypotheses considered and the evidence that confirmed the root cause
- state the invariant, rule, or decision that was violated, and which layer owns it by design
- state where the fix and its regression test were placed, and why that layer — not the crash site — is correct
- state how the loop was closed in the tracking tool, how non-recurrence was verified, and the one design change that would prevent recurrence
