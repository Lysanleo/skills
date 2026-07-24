# Universal Effect Skill Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the rejected Effect guideline with one concise `effect` skill that preserves Kit Langton's progressive-disclosure design and incorporates official Effect `ai-docs`.

**Architecture:** Import Kit's pinned Effect skill as the working base, keep `SKILL.md` as a small router, and synthesize Kit plus official `ai-docs` into focused local references. Add a compact official-doc routing index for uncovered or uncertain topics, then remove the old competing skill.

**Tech Stack:** Agent Skills Markdown, YAML UI metadata, Effect v4, Kit Langton's Effect skill at `0cace2ae0bd65e0cb03ab12860b62ae5e043f0df`, Effect `ai-docs` reviewed at `b49284193f86737e411dc3dd19cfb1a8b9fa5d95`.

## Global Constraints

- The runtime skill directory is exactly `skills/effect/`; do not retain a second Effect skill or compatibility alias.
- Keep `SKILL.md` concise and route detailed guidance into `references/`.
- Keep each local reference decision-oriented: when to read it, recommended
  defaults, a selection guide, small complete examples, common mistakes, and
  its official `ai-docs` topic or an explicit note that no dedicated topic
  exists.
- Kit supplies the structure, production defaults, and editorial base.
- Official Effect `ai-docs` corrects the base, fills core gaps, and routes specialized topics.
- The target project's installed Effect packages and TypeScript compiler determine whether an API is available.
- Normal covered workflows must remain useful offline.
- Do not copy the full `ai-docs` tree or generated `LLMS.md`.
- Do not add formal evals, baseline comparisons, an `evals/` directory, source locks, automated synchronization, or versioned documentation snapshots.
- Preserve the necessary MIT license and a brief source attribution.
- Do not use `skills/effect-v4-development-guideline/` as a correctness or style source.

---

### Task 1: Import the Kit Base and Add Skill Metadata

**Files:**

- Create: `skills/effect/SKILL.md`
- Create: `skills/effect/LICENSE`
- Create: `skills/effect/agents/openai.yaml`
- Create: `skills/effect/references/CACHING.md`
- Create: `skills/effect/references/CONFIG.md`
- Create: `skills/effect/references/HTTP_CLIENTS.md`
- Create: `skills/effect/references/SCHEDULING.md`
- Create: `skills/effect/references/SCHEMA.md`
- Create: `skills/effect/references/SERVICES_LAYERS.md`
- Create: `skills/effect/references/STREAMS.md`
- Create: `skills/effect/references/TESTING.md`

**Interfaces:**

- Consumes: Kit Langton's repository at commit `0cace2ae0bd65e0cb03ab12860b62ae5e043f0df`.
- Produces: A working `skills/effect/` base whose eight references are available for later synthesis.

- [ ] **Step 1: Confirm the repository starts from the approved design**

Run:

```bash
git status --short
git log -2 --oneline
test -f docs/superpowers/specs/2026-07-24-effect-skill-design.md
```

Expected: the worktree contains no unrelated changes, and the approved design commit `dca716d` is present in history.

- [ ] **Step 2: Obtain and verify the pinned Kit source**

Run:

```bash
test -d /tmp/kitlangton-skills-0cace2a/.git || git clone https://github.com/kitlangton/skills.git /tmp/kitlangton-skills-0cace2a
git -C /tmp/kitlangton-skills-0cace2a checkout 0cace2ae0bd65e0cb03ab12860b62ae5e043f0df
test "$(git -C /tmp/kitlangton-skills-0cace2a rev-parse HEAD)" = "0cace2ae0bd65e0cb03ab12860b62ae5e043f0df"
```

Expected: the final `test` exits successfully.

- [ ] **Step 3: Copy the unchanged base mechanically**

Run:

```bash
mkdir -p skills/effect/agents
cp /tmp/kitlangton-skills-0cace2a/skills/effect/SKILL.md skills/effect/SKILL.md
cp -R /tmp/kitlangton-skills-0cace2a/skills/effect/references skills/effect/references
cp /tmp/kitlangton-skills-0cace2a/LICENSE skills/effect/LICENSE
```

Expected: `skills/effect/SKILL.md`, `skills/effect/LICENSE`, and all eight Kit reference files exist.

- [ ] **Step 4: Add the UI metadata**

Create `skills/effect/agents/openai.yaml` with:

```yaml
interface:
  display_name: "Effect"
  short_description: "Build production Effect v4 TypeScript applications."
  default_prompt: "Use $effect to build or review this Effect v4 TypeScript task."
```

- [ ] **Step 5: Run the base integrity check**

Run:

```bash
test "$(find skills/effect/references -maxdepth 1 -type f -name '*.md' | wc -l)" -eq 8
rg -n '^name: effect$|^license: MIT$' skills/effect/SKILL.md
rg -n 'display_name: "Effect"|Use \$effect' skills/effect/agents/openai.yaml
git diff --check
```

Expected: eight references are present, all four searches print matching lines, and `git diff --check` prints nothing.

- [ ] **Step 6: Commit the imported base**

```bash
git add skills/effect
git commit -m "feat: add Kit-based Effect skill"
```

---

### Task 2: Add Official `ai-docs` Routing and Finalize the Router

**Files:**

- Create: `skills/effect/references/AI_DOCS.md`
- Modify: `skills/effect/SKILL.md`

**Interfaces:**

- Consumes: The imported Kit router and the official `ai-docs/src` topic tree.
- Produces: The final branch chooser used by every later reference and a compact escape hatch for specialized or uncertain APIs.

- [ ] **Step 1: Add the official-doc routing index**

Create `skills/effect/references/AI_DOCS.md` with:

```markdown
# Official Effect AI Docs

Use this index when the local references do not cover a topic, an API is
uncertain or version-sensitive, or the user asks for official guidance.

The paths below are relative to the official Effect repository. In a
downstream project, first inspect the installed `effect` and `@effect/*`
packages. Upstream `main` may be newer than the project.

## Core Effect

- Basics and `Effect.gen` / `Effect.fn`: `ai-docs/src/01_effect/01_basics`
- Schema: `ai-docs/src/01_effect/02_schema`
- Services and Layers: `ai-docs/src/01_effect/03_services`
- Errors: `ai-docs/src/01_effect/04_errors`
- Resources and Scope: `ai-docs/src/01_effect/05_resources`
- Running Effects and Layers: `ai-docs/src/01_effect/06_running`
- PubSub: `ai-docs/src/01_effect/07_pubsub`

## Workflows and Integration

- Streams: `ai-docs/src/03_stream`
- ManagedRuntime integration: `ai-docs/src/04_integration`
- Request batching: `ai-docs/src/05_batching`
- Schedules: `ai-docs/src/06_schedule`
- DateTime and time zones: `ai-docs/src/07_datetime`
- Logging and tracing: `ai-docs/src/08_observability`
- Testing: `ai-docs/src/09_testing`
- Predicates: `ai-docs/src/10_predicate`

## Platform and Specialized Modules

- HTTP client: `ai-docs/src/50_http-client`
- HTTP server and HttpApi: `ai-docs/src/51_http-server`
- Child processes: `ai-docs/src/60_child-process`
- CLI: `ai-docs/src/70_cli`
- AI: `ai-docs/src/71_ai`
- Cluster: `ai-docs/src/80_cluster`

Read the topic's `index.md`, examples, and fixtures together. If an example
does not typecheck against the target project, use the installed package
source and types rather than silently switching the project to upstream
`main`.

## Sources

- Skill structure and initial references: Kit Langton,
  `kitlangton/skills@0cace2ae0bd65e0cb03ab12860b62ae5e043f0df`
  (MIT).
- Official guidance: `Effect-TS/effect/ai-docs`, reviewed at
  `b49284193f86737e411dc3dd19cfb1a8b9fa5d95` (MIT).
```

- [ ] **Step 2: Replace `SKILL.md` with the final concise router**

Replace `skills/effect/SKILL.md` with:

```markdown
---
name: effect
description: |
  Opinionated guide for building and reviewing production TypeScript applications with Effect v4. Use whenever a task imports or changes `effect` or `@effect/*`, including workflows, schemas, services, layers, typed errors, resources, configuration, schedules, caches, batching, streams, HTTP, testing, CLI, child processes, observability, AI, or Cluster.
license: MIT
compatibility: Requires Effect v4. Project conventions and installed package APIs take precedence.
---

# Effect

Use current Effect v4 APIs and the production defaults in this skill.
Established project conventions still take precedence unless the task is
explicitly changing them.

## Source Rule

Check these before guessing:

- the nearest `AGENTS.md` and any project-local Effect practices document;
- the target workspace's installed `effect` and `@effect/*` packages;
- the relevant local reference in this skill; and
- the official topic routed by `references/AI_DOCS.md` when local coverage is
  missing or the API is uncertain.

Upstream `main` may be newer than the target project. Installed types, source,
typecheck, and tests determine compatibility.

## Branch Chooser

Read only the references that match the task:

- Data models, schemas, brands, variants, optional keys, or decoders:
  `references/SCHEMA.md`
- Services, module surfaces, layers, dependency wiring, `Effect.fn`, or test
  services: `references/SERVICES_LAYERS.md`
- Typed failures, defects, causes, error translation, or recovery:
  `references/ERRORS.md`
- `Scope`, acquire/release, finalizers, scoped services, background fibers, or
  lifecycle ownership: `references/RESOURCES.md`
- Runtime configuration, environment variables, `ConfigProvider`, or
  `layerConfig`: `references/CONFIG.md`
- Retry, repeat, polling, backoff, jitter, pacing, or pass loops:
  `references/SCHEDULING.md`
- Memoization, TTL caches, concurrent lookup deduplication, request batching,
  or resolvers: `references/CACHING.md`
- Streams, event sources, async iterables, Queue/PubSub, pagination,
  backpressure, or stream consumers: `references/STREAMS.md`
- Outgoing HTTP, Effect HttpClient, response decoding, status handling, or
  transient retry: `references/HTTP_CLIENTS.md`
- Incoming HTTP, HttpApi, handlers, middleware, routing, OpenAPI, or server
  runtime wiring: `references/HTTP_SERVERS.md`
- Effect tests, test Layers, virtual time, sleeps, concurrency
  synchronization, or fakes: `references/TESTING.md`
- Basics, running Effects, ManagedRuntime, DateTime, observability, Predicate,
  CLI, child process, AI, Cluster, or any uncovered topic:
  `references/AI_DOCS.md`

If a task spans several branches, read every matching file before editing.

## Core Defaults

- Compose workflows with `Effect.gen(function* () { ... })`.
- Define public and non-trivial internal operations with named `Effect.fn`.
- Prefer `Context.Service` for application services when the project has not
  standardized on another current service-tag style.
- Build real implementations with Layers and keep dependencies visible.
- Model records and untrusted boundaries with Schema.
- Model expected failures as typed errors; do not disguise defects as
  business failures.
- Read runtime configuration through `Config`.
- Manage acquired resources and background work with `Scope`.
- Use `Schedule` for retry, repeat, polling, pacing, and backoff.
- Use `Stream` for effectful multi-value sources that need pull,
  backpressure, interruption, or transformation.
- Keep HTTP handlers thin: decode, call services, and map typed failures.
- Prefer Effect-aware tests, explicit Layers, and deterministic
  synchronization over real sleeps.

## Do Nots

- Do not use `as any`, non-null assertions, or unchecked casts to silence
  Effect typing problems.
- Do not invent APIs from memory when installed types or official examples
  can answer the question.
- Do not use cause-level recovery when typed-error recovery is sufficient.
- Do not merge or provide Layers blindly to make requirements disappear.
- Do not hide required authority, credentials, persistence, transports, or
  external services behind default Context values.
- Do not retry operations without truthful retry semantics and appropriate
  idempotency.
- Do not hand-roll resource, cache, batching, or synchronization machinery
  when Effect already provides the required abstraction.
```

- [ ] **Step 3: Check every routed local reference is either present or intentionally scheduled**

Run:

```bash
rg -o 'references/[A-Z_]+\.md' skills/effect/SKILL.md | sort -u
test -f skills/effect/references/AI_DOCS.md
git diff --check
```

Expected: the output lists twelve unique references. `ERRORS.md`, `RESOURCES.md`, and `HTTP_SERVERS.md` are the only routed files not yet created; `git diff --check` prints nothing.

- [ ] **Step 4: Commit the router and official index**

```bash
git add skills/effect/SKILL.md skills/effect/references/AI_DOCS.md
git commit -m "docs: route Effect work through official ai-docs"
```

---

### Task 3: Synthesize the Core Modeling References

**Files:**

- Modify: `skills/effect/references/SCHEMA.md`
- Modify: `skills/effect/references/SERVICES_LAYERS.md`
- Modify: `skills/effect/references/CONFIG.md`

**Interfaces:**

- Consumes: Kit's three references, `AI_DOCS.md`, and the official basics, Schema, and services topics.
- Produces: Stable local guidance for data boundaries, services, dependency wiring, and runtime configuration.

- [ ] **Step 1: Read the complete official source material for these branches**

Read:

```text
ai-docs/src/01_effect/01_basics/
ai-docs/src/01_effect/02_schema/
ai-docs/src/01_effect/03_services/
```

Also inspect the installed or official Effect source for `Config` and
`ConfigProvider`, because the reviewed `ai-docs` tree has no dedicated Config
topic.

- [ ] **Step 2: Revise `SCHEMA.md` without expanding it into a Schema tutorial**

Keep Kit's decision-oriented structure and ensure it contains:

- `Schema.Struct` plus a same-name `interface` for ordinary records;
- constrained branded schemas for scalar IDs and value objects;
- an explicit distinction between internal `Data.TaggedEnum` state and
  boundary-crossing Schema variants;
- `Schema.decodeUnknownEffect` or schema `makeEffect` at untrusted boundaries;
- throwing construction only for trusted values;
- optional-key semantics that distinguish absence from `undefined`;
- a small complete example for a record, a tagged error or tagged union, and
  a boundary decode; and
- an `## Official ai-docs` section linking
  `ai-docs/src/01_effect/02_schema`.

Remove claims that are only naming preference, duplicate the router, or are
not supported by the current official source.

- [ ] **Step 3: Revise `SERVICES_LAYERS.md` around service boundaries**

Ensure it contains:

- `Context.Service` as the default only when the target project has not
  standardized on another current style;
- public service interfaces, `Service.of`, and `Layer.effect`;
- named `Effect.fn` operations;
- visible Layer requirements and deliberate `Layer.provide` composition;
- production and test Layer examples;
- a clear separation from error recovery (`ERRORS.md`) and resource ownership
  (`RESOURCES.md`); and
- an `## Official ai-docs` section linking
  `ai-docs/src/01_effect/01_basics` and
  `ai-docs/src/01_effect/03_services`.

Do not use blind `Layer.mergeAll`, `provideMerge`, or default Context values
to hide required dependencies.

- [ ] **Step 4: Revise `CONFIG.md` while acknowledging the official-doc gap**

Ensure it contains:

- `Config` recipes read inside Layers;
- secret handling with `Redacted` where applicable;
- nested and fallback configuration without direct `process.env` reads in
  application logic;
- `ConfigProvider` overrides in tests;
- configuration errors remaining visible unless a real default exists; and
- an `## Official ai-docs` section stating that the reviewed tree has no
  dedicated Config topic and that uncertain APIs must be checked against the
  installed `effect` package source.

- [ ] **Step 5: Run the core-reference integrity check**

Run:

```bash
rg -n '^## Official ai-docs$' \
  skills/effect/references/SCHEMA.md \
  skills/effect/references/SERVICES_LAYERS.md \
  skills/effect/references/CONFIG.md
rg -n 'as any|process\.env|provideMerge' \
  skills/effect/references/SCHEMA.md \
  skills/effect/references/SERVICES_LAYERS.md \
  skills/effect/references/CONFIG.md
git diff --check
```

Expected: each file has one official-source section. Any matches from the
second search appear only inside explicit "do not" guidance; `git diff
--check` prints nothing.

- [ ] **Step 6: Commit the core references**

```bash
git add \
  skills/effect/references/SCHEMA.md \
  skills/effect/references/SERVICES_LAYERS.md \
  skills/effect/references/CONFIG.md
git commit -m "docs: synthesize Effect core references"
```

---

### Task 4: Synthesize Scheduling, Caching, and Stream References

**Files:**

- Modify: `skills/effect/references/SCHEDULING.md`
- Modify: `skills/effect/references/CACHING.md`
- Modify: `skills/effect/references/STREAMS.md`

**Interfaces:**

- Consumes: Kit's operational references and the official PubSub, Stream, batching, and Schedule topics.
- Produces: Focused guidance for repeated work, shared lookups, batching, and multi-value sources.

- [ ] **Step 1: Read the complete official source material**

Read:

```text
ai-docs/src/01_effect/07_pubsub/
ai-docs/src/03_stream/
ai-docs/src/05_batching/
ai-docs/src/06_schedule/
```

Inspect installed package source for `Cache`, `Effect.cached`, and
`Effect.cachedWithTTL`, because `ai-docs` documents batching but does not
currently provide a complete cache topic.

- [ ] **Step 2: Revise `SCHEDULING.md`**

Keep separate recipes for:

- bounded retry of transient, idempotent operations;
- `retryOrElse` when the boundary has a truthful fallback;
- `repeat` for successful recurring work;
- polling loops whose per-pass failures are handled before repetition;
- spacing, exponential backoff, jitter, and bounded recurrences; and
- retry decisions based on typed failures rather than broad catch-all logic.

End with `## Official ai-docs` pointing to `ai-docs/src/06_schedule`.

- [ ] **Step 3: Revise `CACHING.md`**

Keep an explicit chooser among:

- `Effect.cached` / `cachedWithTTL` for one effect result;
- `Cache.make` / `Cache.makeWith` for keyed TTL lookup and concurrent lookup
  deduplication; and
- `Effect.request` plus `RequestResolver` only when a real batch endpoint
  exists.

Remove hand-rolled Map/TTL/in-flight deduplication guidance. End with an
`## Official ai-docs` section that links `ai-docs/src/05_batching` and states
that Cache APIs must be confirmed in the installed package source.

- [ ] **Step 4: Revise `STREAMS.md`**

Keep focused recipes for:

- creating and consuming Streams;
- `Stream.runForEach` and collection only when bounded;
- Queue-backed sources;
- PubSub broadcasts;
- scoped background consumers with `Effect.forkScoped`;
- async iterables and pagination; and
- backpressure, interruption, and lifecycle ownership.

End with `## Official ai-docs` pointing to
`ai-docs/src/01_effect/07_pubsub` and `ai-docs/src/03_stream`.

- [ ] **Step 5: Run the operational-reference integrity check**

Run:

```bash
rg -n '^## Official ai-docs$' \
  skills/effect/references/SCHEDULING.md \
  skills/effect/references/CACHING.md \
  skills/effect/references/STREAMS.md
rg -n 'Schedule|RequestResolver|forkScoped' \
  skills/effect/references/SCHEDULING.md \
  skills/effect/references/CACHING.md \
  skills/effect/references/STREAMS.md
git diff --check
```

Expected: every file has an official-source section, the key abstractions are
present, and `git diff --check` prints nothing.

- [ ] **Step 6: Commit the operational references**

```bash
git add \
  skills/effect/references/SCHEDULING.md \
  skills/effect/references/CACHING.md \
  skills/effect/references/STREAMS.md
git commit -m "docs: synthesize Effect workflow references"
```

---

### Task 5: Synthesize HTTP Client and Testing References

**Files:**

- Modify: `skills/effect/references/HTTP_CLIENTS.md`
- Modify: `skills/effect/references/TESTING.md`

**Interfaces:**

- Consumes: Kit's HTTP client and test guidance plus the corresponding official topics.
- Produces: Version-conscious outgoing HTTP guidance and deterministic Effect testing practices.

- [ ] **Step 1: Read the complete official source material**

Read:

```text
ai-docs/src/50_http-client/
ai-docs/src/09_testing/
```

Inspect all examples and fixtures, not only each topic's `index.md`.

- [ ] **Step 2: Revise `HTTP_CLIENTS.md`**

Ensure it covers:

- checking installed exports before using unstable HTTP modules;
- wrapping the client behind an application service or named adapter effect;
- building and transforming requests with Effect HTTP client APIs;
- checking status before decoding success payloads;
- Schema decoding at the response boundary;
- mapping transport, status, and decode failures into truthful typed errors;
- `HttpClient.retryTransient` with a bounded Schedule when the operation is
  safe to retry; and
- keeping provider calls outside authoritative database transactions.

End with `## Official ai-docs` pointing to `ai-docs/src/50_http-client`.

- [ ] **Step 3: Revise `TESTING.md`**

Ensure it covers:

- Effect-aware test runners where the project uses them;
- explicit production and test Layers;
- `TestClock` for time-sensitive code;
- `Deferred`, Queue, Latch, Ref, or explicit test hooks for concurrency
  synchronization;
- deterministic testing of retries, background fibers, and interruption;
- fakes that preserve the same service interface and typed failures; and
- avoiding arbitrary real sleeps.

End with `## Official ai-docs` pointing to `ai-docs/src/09_testing`.

- [ ] **Step 4: Run the client-and-test integrity check**

Run:

```bash
rg -n '^## Official ai-docs$' \
  skills/effect/references/HTTP_CLIENTS.md \
  skills/effect/references/TESTING.md
rg -n 'retryTransient|TestClock|Deferred' \
  skills/effect/references/HTTP_CLIENTS.md \
  skills/effect/references/TESTING.md
git diff --check
```

Expected: both files have an official-source section, the selected APIs are
present in their relevant files, and `git diff --check` prints nothing.

- [ ] **Step 5: Commit the HTTP client and testing references**

```bash
git add \
  skills/effect/references/HTTP_CLIENTS.md \
  skills/effect/references/TESTING.md
git commit -m "docs: align Effect HTTP client and testing guidance"
```

---

### Task 6: Add Error and Resource References

**Files:**

- Create: `skills/effect/references/ERRORS.md`
- Create: `skills/effect/references/RESOURCES.md`

**Interfaces:**

- Consumes: `SKILL.md`, `SERVICES_LAYERS.md`, and official error and resource examples.
- Produces: The two core `ai-docs` additions needed by the router.

- [ ] **Step 1: Read the complete official source material**

Read every file under:

```text
ai-docs/src/01_effect/04_errors/
ai-docs/src/01_effect/05_resources/
ai-docs/src/01_effect/06_running/
```

- [ ] **Step 2: Create `ERRORS.md`**

Use this exact section structure:

```markdown
# Errors

## When to read this
## Selection guide
## Define expected failures
## Translate failures at boundaries
## Recover by tag
## Errors with reasons
## Defects and Cause
## Do nots
## Official ai-docs
```

Populate it with:

- `Schema.TaggedErrorClass` for reusable expected failures;
- `Schema.ErrorClass` only where an untagged wrapper is intentional;
- `Effect.try`, `Effect.tryPromise`, or adapter-specific constructors at
  throwing/rejecting boundaries;
- `Effect.mapError` when changing abstraction boundaries;
- `Effect.catchTag`, `catchTags`, and `catch` chosen by the remaining error
  channel;
- `catchReason`, `catchReasons`, and `unwrapReason` only for the official
  reason-error model;
- a short distinction among expected failures, defects, interruption, and
  full Cause inspection;
- one complete tagged-error recovery example;
- explicit warnings against catch-all recovery, cause-level handling when
  typed handling is enough, and leaking vendor errors through domain
  services; and
- official paths `ai-docs/src/01_effect/04_errors` and the relevant examples
  within that directory.

- [ ] **Step 3: Create `RESOURCES.md`**

Use this exact section structure:

```markdown
# Resources and Scope

## When to read this
## Ownership rule
## Acquire and release
## Scoped services and Layers
## Background work
## Dynamic keyed resources
## Running scoped applications
## Do nots
## Official ai-docs
```

Populate it with:

- the rule that the boundary which acquires a resource must make its lifetime
  explicit;
- `Effect.acquireRelease` with an infallible or deliberately handled
  finalizer;
- acquiring resources inside `Layer.effect` so Layer scope owns cleanup;
- `Layer.effectDiscard` and `Effect.forkScoped` for background work;
- `LayerMap.Service` only for genuinely dynamic keyed resources;
- `Layer.launch` / platform runtime ownership at application boundaries;
- one complete acquire/release service example and one concise background
  task example;
- warnings against module-global clients, detached fibers, manual cleanup
  flags, and returning scoped resources beyond their owner; and
- official paths `ai-docs/src/01_effect/05_resources` and
  `ai-docs/src/01_effect/06_running`.

- [ ] **Step 4: Run the new-reference integrity check**

Run:

```bash
rg -n '^## (When to read this|Official ai-docs)$' \
  skills/effect/references/ERRORS.md \
  skills/effect/references/RESOURCES.md
rg -n 'TaggedErrorClass|catchTags|acquireRelease|forkScoped' \
  skills/effect/references/ERRORS.md \
  skills/effect/references/RESOURCES.md
git diff --check
```

Expected: both files contain their required headings and APIs, and `git diff
--check` prints nothing.

- [ ] **Step 5: Commit errors and resources**

```bash
git add \
  skills/effect/references/ERRORS.md \
  skills/effect/references/RESOURCES.md
git commit -m "docs: add Effect errors and resources guidance"
```

---

### Task 7: Add the HTTP Server Reference

**Files:**

- Create: `skills/effect/references/HTTP_SERVERS.md`

**Interfaces:**

- Consumes: `SCHEMA.md`, `SERVICES_LAYERS.md`, `ERRORS.md`, `RESOURCES.md`, and the complete official HttpApi example with fixtures.
- Produces: Version-conscious guidance for schema-first incoming HTTP APIs and thin transport handlers.

- [ ] **Step 1: Read the complete official HTTP server topic**

Read every file under:

```text
ai-docs/src/51_http-server/
```

This includes the API, domain, server, authorization, and handler fixtures
referenced by `10_basics.ts`.

- [ ] **Step 2: Create `HTTP_SERVERS.md`**

Use this exact section structure:

```markdown
# HTTP Servers

## When to read this
## Version check
## Architecture
## Define the API
## Implement thin handlers
## Middleware and authorization
## Compose and run the server
## Typed clients
## Do nots
## Official ai-docs
```

Populate it with:

- a first-step warning that HTTP and HttpApi modules are unstable and their
  imports must be confirmed against installed packages;
- API definitions separated from server implementation so definitions can be
  shared safely with clients;
- Schema-defined request, response, and documented error contracts;
- `HttpApiBuilder.group` for handler groups and `HttpApiBuilder.layer` for the
  API Layer;
- thin handlers that decode transport input, read request context, call
  services, and map typed failures;
- middleware contracts separated from server-side and client-side
  implementations;
- route composition, the platform server Layer, and `Layer.launch` /
  platform runtime ownership;
- `HttpApiClient` as an optional typed client derived from the same API;
- a small architecture example split into API, domain service, handler, and
  runtime snippets rather than one monolithic server file;
- warnings against business rules in handlers, server imports in shared API
  packages, undocumented thrown errors, and copying imports from upstream
  without checking the installed version; and
- `ai-docs/src/51_http-server` as the official topic.

- [ ] **Step 3: Run the HTTP server integrity check**

Run:

```bash
rg -n '^## (Version check|Architecture|Official ai-docs)$' \
  skills/effect/references/HTTP_SERVERS.md
rg -n 'HttpApiBuilder\.(group|layer)|Layer\.launch|HttpApiClient' \
  skills/effect/references/HTTP_SERVERS.md
git diff --check
```

Expected: all required headings and main composition APIs are present, and
`git diff --check` prints nothing.

- [ ] **Step 4: Commit the HTTP server reference**

```bash
git add skills/effect/references/HTTP_SERVERS.md
git commit -m "docs: add Effect HTTP server guidance"
```

---

### Task 8: Remove the Legacy Skill and Check the Final Package

**Files:**

- Delete: `skills/effect-v4-development-guideline/SKILL.md`
- Delete: `skills/effect-v4-development-guideline/agents/openai.yaml`
- Delete: `skills/effect-v4-development-guideline/references/effect-naming-conventions.md`
- Delete: `skills/effect-v4-development-guideline/references/effect-v4-patterns.md`
- Delete: `skills/effect-v4-development-guideline/references/migration-checklist.md`
- Delete: `skills/effect-v4-development-guideline/references/source-policy.md`

**Interfaces:**

- Consumes: The complete new `skills/effect/` directory from Tasks 1–7.
- Produces: One non-competing Effect skill with exactly the approved runtime files.

- [ ] **Step 1: Confirm all new routed references exist before deleting the old skill**

Run:

```bash
for ref in $(rg -o 'references/[A-Z_]+\.md' skills/effect/SKILL.md | sort -u); do test -f "skills/effect/$ref" || exit 1; done
test "$(find skills/effect/references -maxdepth 1 -type f -name '*.md' | wc -l)" -eq 12
```

Expected: both commands exit successfully.

- [ ] **Step 2: Delete the rejected skill**

Delete `skills/effect-v4-development-guideline/` and every file below it. Do
not copy any of its content into `skills/effect/`.

- [ ] **Step 3: Check the final directory and trigger metadata**

Run:

```bash
test ! -e skills/effect-v4-development-guideline
test ! -e skills/effect/evals
test ! -e skills/effect/sources.lock.json
rg -n '^name: effect$' skills/effect/SKILL.md
rg -n 'Use \$effect' skills/effect/agents/openai.yaml
find skills/effect -maxdepth 3 -type f | sort
git diff --check
```

Expected:

- the old skill, `evals/`, and source lock do not exist;
- the skill name and default prompt both use `effect`;
- the listing contains `SKILL.md`, `LICENSE`, `agents/openai.yaml`,
  `AI_DOCS.md`, the eight revised Kit references, and the three new core
  references;
- `git diff --check` prints nothing.

- [ ] **Step 4: Review the final diff only for approved scope**

Run:

```bash
git status --short
git diff --stat dca716d
git diff dca716d -- skills/effect-v4-development-guideline skills/effect
```

Expected: the diff contains only removal of the rejected skill and the
completed `skills/effect/` package. It contains no eval framework, automated
sync tooling, source lock, or copied `ai-docs` tree.

- [ ] **Step 5: Commit the replacement**

```bash
git add skills/effect skills/effect-v4-development-guideline
git commit -m "refactor: replace legacy Effect skill"
```

- [ ] **Step 6: Confirm the implementation branch is clean**

Run:

```bash
git status --short --branch
git log --oneline --decorate -10
```

Expected: the worktree is clean and history contains the task commits from
this plan.
