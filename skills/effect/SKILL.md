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
