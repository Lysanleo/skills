# Effect V4 Patterns

Use this before writing new Effect code or teaching Effect concepts.

## Mental Model

`Effect` is a lazy computation description. It is not a running task. Runtime APIs execute it at the edge.

Problem mapping:

- Eager `Promise` -> lazy `Effect` composition.
- Hidden dependencies -> services + `Layer`.
- `throw` soup -> typed failure channel.
- Leaked resources -> scoped acquisition + layer lifecycle.
- Ad hoc shutdown -> runtime interruption and finalizers.
- Framework-owned handlers -> `ManagedRuntime` bridge.

## Boundary Choices

Use no runtime inside business logic. Return `Effect`.

Use `NodeRuntime.runMain` for process entrypoints:

```ts
NodeRuntime.runMain(program)
```

Use `Layer.launch` when the whole app is a long-running layer graph:

```ts
NodeRuntime.runMain(Layer.launch(AppLive))
```

Use `ManagedRuntime` for NestJS, Express, Hono, SvelteKit, or other frameworks that already own request handling:

```ts
const runtime = ManagedRuntime.make(AppLive)
await runtime.runPromise(workflow)
await runtime.dispose()
```

Official API docs describe `ManagedRuntime.make` as converting a `Layer` into a runtime that can run Effects using provided services. Its methods include `runPromise`, `runSync`, `runFork`, `runCallback`, `runPromiseExit`, and `dispose`.

## Service Pattern

For naming, read `effect-naming-conventions.md` first when introducing new services, layers, errors, schemas, workflows, or trace spans.

Preferred shape:

```ts
import { Effect, Layer } from "effect"

class TrialRepo extends Effect.Service<TrialRepo>()("app/TrialRepo", {
  effect: Effect.gen(function* () {
    return {
      create: (input: CreateTrialInput) =>
        Effect.gen(function* () {
          // DB call wrapped here
          return yield* Effect.succeed({ id: "trial_1", ...input })
        })
    }
  })
}) {}
```

Before using this exact syntax, verify local Effect version and current docs. Some v3 projects still use `Context.Tag` or other service forms.

## Workflow Pattern

Keep workflow dependencies explicit through services:

```ts
const createTrial = (input: CreateTrialInput) =>
  Effect.gen(function* () {
    const repo = yield* TrialRepo
    const publisher = yield* EventPublisher

    const trial = yield* repo.create(input)
    yield* publisher.publish({ type: "TrialCreated", trialId: trial.id }).pipe(
      Effect.retry({ times: 3 }),
      Effect.timeout("2 seconds")
    )

    return trial
  })
```

## Schema Pattern

Use `Schema` for external input/output. Effect docs show schema transformations can require services through Context/Layer, and `Schema.decodeUnknown(...)` returns Effectful parsing when validation is effectful.

```ts
const decodeInput = Schema.decodeUnknown(CreateTrialInputSchema)

const program = Effect.gen(function* () {
  const input = yield* decodeInput(raw)
  return yield* createTrial(input)
})
```

## Error Pattern

Expected domain failures belong in the typed error channel:

```ts
class TrialNotFound extends Schema.TaggedError<TrialNotFound>()("TrialNotFound", {
  id: Schema.String
}) {}
```

Use defects only for impossible states and programmer bugs.

## Testing Pattern

Test workflows by providing fake layers:

```ts
const TestRepo = Layer.succeed(TrialRepo, {
  create: (input) => Effect.succeed({ id: "test", ...input })
})
```

Run the Effect under the test layer. Avoid asserting internal runtime/provide call shape unless the boundary itself is under test.
