# Universal Effect Skill Design

Date: 2026-07-24

## Objective

Replace `skills/effect-v4-development-guideline/` with one reusable
`skills/effect/` skill for production TypeScript development with Effect v4.

The new skill combines:

- the concise routing, progressive disclosure, practical defaults, and
  production-oriented examples of Kit Langton's Effect skill; and
- the official Effect repository's `ai-docs` as the source used to correct,
  extend, and investigate the guidance.

The result should remain a small working guide rather than a copy of the
official documentation or a framework for synchronizing upstream sources.

## Sources

The initial Kit source is `kitlangton/skills` at commit
`0cace2ae0bd65e0cb03ab12860b62ae5e043f0df`, licensed under MIT.

The official Effect source is the Effect repository's maintained
`ai-docs/src` tree. Its generated `LLMS.md`, package source, and tests may be
consulted when a topic needs more detail.

These sources have different roles:

- Kit supplies the skill's structure, editorial judgment, defaults, and
  production practices.
- Effect `ai-docs` supplies official semantics, examples, and coverage of
  topics absent from Kit's skill.
- The target project's installed packages and TypeScript compiler determine
  whether an API is actually available in that project.

No source lock, automated synchronization system, multi-version documentation
snapshot, or detailed provenance database will be added.

## Directory Structure

```text
skills/effect/
├── SKILL.md
├── LICENSE
├── agents/
│   └── openai.yaml
└── references/
    ├── AI_DOCS.md
    ├── SCHEMA.md
    ├── SERVICES_LAYERS.md
    ├── ERRORS.md
    ├── RESOURCES.md
    ├── CONFIG.md
    ├── SCHEDULING.md
    ├── CACHING.md
    ├── STREAMS.md
    ├── HTTP_CLIENTS.md
    ├── HTTP_SERVERS.md
    └── TESTING.md
```

The skill will not include an `evals/` directory or a formal benchmark
workflow.

## `SKILL.md`

`SKILL.md` remains a concise router. It contains:

- a trigger description for tasks involving the `effect` package or
  `@effect/*` packages;
- a reminder to inspect the nearest project instructions, existing
  conventions, and installed Effect version;
- a branch chooser that tells the agent which local references to read;
- a small set of cross-cutting production defaults and unsafe shortcuts to
  avoid; and
- instructions for using `AI_DOCS.md` when the local references do not cover
  the task or an API is uncertain.

Large tutorials and broad API catalogs do not belong in `SKILL.md`.

The trigger should cover Effect workflows, Schema, services, Layers, errors,
resources, configuration, schedules, caches and batching, Streams, HTTP,
testing, CLI, child processes, observability, AI, and Cluster. It should not
trigger merely because ordinary prose contains the English word "effect."

## Local References

Kit's existing reference split remains the foundation:

- `SCHEMA.md`
- `SERVICES_LAYERS.md`
- `CONFIG.md`
- `SCHEDULING.md`
- `CACHING.md`
- `STREAMS.md`
- `HTTP_CLIENTS.md`
- `TESTING.md`

Official `ai-docs` fills three core gaps with local references:

- `ERRORS.md` covers typed failures, defects, causes, recovery, and error
  handling at boundaries.
- `RESOURCES.md` covers `Scope`, acquire/use/release, scoped services, and
  lifecycle ownership.
- `HTTP_SERVERS.md` covers handlers, routing, middleware, request and response
  schemas, and transport-to-service boundaries.

Each local reference should contain only the material needed to guide work:

1. when to read it;
2. recommended defaults;
3. a selection guide;
4. small, complete examples;
5. common mistakes and practices to avoid; and
6. the corresponding official `ai-docs` topic.

The references are refined guidance, not verbatim mirrors of either upstream
source.

## How `ai-docs` Participates

`ai-docs` participates in two ways.

First, it is used while authoring every local reference. Existing Kit guidance
is checked against the corresponding official topic, missing official
patterns are added when useful, and examples are corrected when the official
API differs.

Second, `references/AI_DOCS.md` acts as a compact routing index for runtime
investigation. It maps topics to paths under `ai-docs/src`, including:

- Effect basics, Schema, services, errors, resources, and running Effects;
- Streams, batching, schedules, observability, and testing;
- HTTP client and server;
- child processes and CLI; and
- AI and Cluster.

Normal tasks use the refined local references and therefore remain useful
offline. The agent follows `AI_DOCS.md` when:

- the local references do not cover a module;
- an API is uncertain or appears to have changed;
- the task involves a specialized module such as CLI, child process, AI, or
  Cluster; or
- the user explicitly asks for official guidance.

The entire `ai-docs` tree and generated `LLMS.md` will not be copied into the
skill.

## Runtime Workflow

When the skill triggers, the agent:

1. reads the nearest project instructions and identifies the installed Effect
   packages and version;
2. selects and reads only the local references relevant to the task;
3. uses their defaults and examples to perform the work;
4. consults the routed official `ai-docs` topic when coverage or API details
   are uncertain; and
5. treats the target project's installed types, source, typecheck, and tests
   as the compatibility constraint.

Conflicts are resolved simply:

- installed types and source decide whether an API is available;
- official `ai-docs` explains Effect semantics and recommended usage; and
- explicit project conventions decide how the project organizes its code.

The skill should not require a network connection for its normal, covered
workflows.

## Cross-Cutting Defaults

The router keeps only a small set of rules that apply across references:

- Keep transport handlers thin: decode input, call services, and map typed
  failures to transport responses.
- Keep business rules in domain functions or services.
- Decode untrusted input with Schema.
- Manage resource lifetimes with `Scope`.
- Model expected failures as typed errors without disguising defects as
  business failures.
- Retry only when the operation has truthful retry semantics and appropriate
  idempotency.
- Test with Effect-aware Layers, test services, and deterministic
  synchronization.
- Do not use unchecked casts, `as any`, non-null assertions, or blind Layer
  merging to hide type and dependency problems.

Domain-specific detail remains in the routed references.

## Replacement and Maintenance

Implementation will:

1. create `skills/effect/` from Kit's current skill structure;
2. revise its existing references using official `ai-docs`;
3. add `AI_DOCS.md`, `ERRORS.md`, `RESOURCES.md`, and `HTTP_SERVERS.md`;
4. update `agents/openai.yaml`;
5. preserve the necessary MIT license and a brief source attribution; and
6. remove `skills/effect-v4-development-guideline/`.

The old skill will not remain as an alias or competing trigger.

Future maintenance is intentionally manual:

- review and selectively absorb useful Kit updates;
- update a local reference when official `ai-docs` materially changes its
  guidance; and
- keep local content concise rather than maintaining line-for-line upstream
  parity.

Formal evals, baseline comparisons, automated upstream synchronization,
source locks, and versioned documentation snapshots are outside this design.
