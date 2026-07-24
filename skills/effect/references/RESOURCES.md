# Resources and Scope

## When to read this

Read this when code opens a connection or client, registers a listener,
starts background work, owns a long-lived Stream, needs a finalizer, or
returns a Layer whose lifetime matters.

## Ownership Rule

The boundary that acquires a resource must make its lifetime explicit.
`Scope` ties finalizers and child fibers to that lifetime so success, failure,
and interruption all trigger cleanup.

Do not return a scoped resource beyond the boundary that owns its Scope.

## Acquire and Release

Use `Effect.acquireRelease` when acquisition and cleanup form one lifecycle:

```ts
import { Context, Effect, Layer, Schema } from "effect"

export class DatabaseError extends Schema.TaggedErrorClass<DatabaseError>()(
  "DatabaseError",
  { operation: Schema.String, cause: Schema.Defect() },
) {}

type Connection = {
  readonly query: (sql: string) => Promise<ReadonlyArray<unknown>>
  readonly close: () => void
}

declare const openConnection: () => Connection

export class Database extends Context.Service<
  Database,
  {
    readonly query: (
      sql: string,
    ) => Effect.Effect<ReadonlyArray<unknown>, DatabaseError>
  }
>()("app/Database") {
  static readonly layer = Layer.effect(
    Database,
    Effect.gen(function* () {
      const connection = yield* Effect.acquireRelease(
        Effect.try({
          try: openConnection,
          catch: (cause) =>
            new DatabaseError({ operation: "Database.open", cause }),
        }),
        (connection) => Effect.sync(() => connection.close()),
      )

      const query = Effect.fn("Database.query")(
        (sql: string) =>
          Effect.tryPromise({
            try: () => connection.query(sql),
            catch: (cause) =>
              new DatabaseError({ operation: "Database.query", cause }),
          }),
      )

      return Database.of({ query })
    }),
  )
}
```

Finalizers should be infallible or deliberately handle and report release
failures. If cleanup may throw or reject, wrap it and choose an explicit
finalizer policy rather than letting an accidental exception define it.

## Scoped Services and Layers

Acquiring inside `Layer.effect` lets the Layer's Scope own cleanup. Consumers
receive the service, not the raw connection or Scope.

Use `Effect.scoped` when a standalone workflow should create and close its own
Scope. Use `Effect.provide` with a Layer when the provided Layer should live
for that workflow.

## Background Work

Use `Layer.effectDiscard` for a Layer that exists only to run scoped work, and
fork long-lived work with `Effect.forkScoped` so Layer teardown interrupts it:

```ts
import { Effect, Layer, Stream } from "effect"

export const ProjectionWorker = Layer.effectDiscard(
  Effect.gen(function* () {
    const projections = yield* Projections

    yield* projections.events.pipe(
      Stream.runForEach(projections.handle),
      Effect.forkScoped,
    )
  }),
)
```

Layer acquisition must finish. Do not run a forever loop or unbounded Stream
inline while constructing the Layer.

## Dynamic Keyed Resources

Use `LayerMap.Service` when the application genuinely needs one scoped
resource per dynamic key, such as a tenant pool. Its lookup builds a Layer per
key and its idle policy releases unused entries.

Do not use LayerMap for a fixed dependency graph or as a general cache. Use
ordinary Layers for static resources and `Cache` for cached values.

## Running Scoped Applications

At the application boundary, compose the complete Layer and hand its lifetime
to the platform runtime:

```ts
import { NodeRuntime } from "@effect/platform-node"

AppLive.pipe(
  Layer.launch,
  NodeRuntime.runMain,
)
```

Server adapters may instead expose a handler plus an explicit dispose
operation. The host must call that disposer when the application instance
ends.

## Do Nots

- Do not create module-global clients or connections with implicit lifetime.
- Do not start detached background fibers owned by nobody.
- Do not expose public `start` methods unless manual lifecycle control is a
  real domain requirement.
- Do not return scoped resources outside their owning Scope.
- Do not add manual cleanup flags when `acquireRelease` or Layer scope already
  models the lifetime.
- Do not put provider calls inside authoritative database transactions merely
  because both use resources.

## Official ai-docs

- `ai-docs/src/01_effect/05_resources`
- `ai-docs/src/01_effect/06_running`
