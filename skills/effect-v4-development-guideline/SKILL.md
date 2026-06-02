---
name: effect-v4-development-guideline
description: Build, refactor, review, or explain TypeScript code using Effect v4 beta or migration from Effect v3 to v4. Use when working with Effect.gen, Effect.Service/Context services, Layer, Schema, typed errors, ManagedRuntime/runtime boundaries, @effect/platform, @effect/vitest, or when the user asks for Effect guidance with citations from current docs.
---

# Effect V4 Development Guideline

## Core Rule

Treat Effect v4 as moving beta unless the local project proves otherwise. Verify installed versions and current docs before giving API-specific advice.

Use Effect to make dependencies, errors, resources, interruption, config, validation, and observability explicit. Keep business logic as `Effect`; cross to `Promise` only at framework or process entrypoints.

## Workflow

1. Inspect local truth first: `package.json`, lockfile, imports, tsconfig, existing Effect style.
2. Verify version state before v4-specific claims:
   - `npm view effect version dist-tags --json`
   - `rg '"effect"|"@effect/' package.json pnpm-lock.yaml`
   - If registry or docs are unavailable, state that current registry/docs were not verified and base implementation on local package files only.
3. Load `references/source-policy.md` when citations, current docs, or v4/v3 status matter.
4. Load `references/effect-v4-patterns.md` before writing new Effect code, designing services/layers, or explaining concepts.
5. Load `references/effect-naming-conventions.md` before creating or reviewing service, layer, schema, error, workflow, runtime, or trace names.
6. Load `references/migration-checklist.md` before changing v3 code for v4 or reviewing v4 migration diffs.
7. Cite sources in user-facing answers when docs influenced API facts.

## Engineering Defaults

- Model external data with `Schema` before business logic.
- Model expected failures with tagged/domain errors, not broad `throw`.
- Put DB, HTTP, queues, clocks, config, and shared state behind services.
- Implement dependencies with `Layer`; provide layers once at app/test boundary.
- Compose workflows with `Effect.gen(function* () { ... })`.
- Add timeout, retry, logging, spans, metrics, and interruption at call boundaries.
- Use `ManagedRuntime` only as a bridge from non-Effect frameworks.
- Follow Effect role-based naming: services as domain capabilities, layers as implementations, workflows as verb phrases, errors as concrete failures.
- Avoid scattered `Effect.runPromise`, `Effect.provide`, or runtime creation inside business code.
- Test with Effect-aware test tools and layer-based fakes.

## Output Standard

When teaching or reviewing, start from real problems: eager promises, hidden dependencies, ad hoc throw/catch, leaked resources, lost cancellation, framework boundaries. Then map to Effect primitives.

For code output:

- Include imports.
- State boundary choice: `runMain`, `Layer.launch`, `ManagedRuntime`, or no run.
- Show where layers are provided.
- Keep examples version-checked; if v4 API is uncertain, say what must be verified.
