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
