# Services, Layers, and Modules

Use this when defining service boundaries, public module surfaces, Layer
implementations, dependency wiring, or named Effect operations. Read
`ERRORS.md` for recovery and `RESOURCES.md` for acquired resources or
background work.

## Service Boundary

Prefer a service when behavior needs a replaceable implementation, visible
dependencies, or a test double. Keep pure domain functions outside services.

```ts
import { Context, Effect, Layer } from "effect"

export interface User {
  readonly id: string
  readonly name: string
}

export class UserRepository extends Context.Service<
  UserRepository,
  {
    readonly findById: (
      id: string,
    ) => Effect.Effect<User, UserNotFound | PersistenceError>
  }
>()("app/UserRepository") {}
```

Follow the existing project if it already uses another current service-tag
style. Service identifiers should be stable and globally recognizable.

## Real Implementation

Keep the unprovided Layer visible when its requirements matter to composition.

```ts
export const UserRepositoryLive = Layer.effect(
  UserRepository,
  Effect.gen(function* () {
    const database = yield* Database

    const findById = Effect.fn("UserRepository.findById")(
      function* (id: string) {
        return yield* database.findUser(id)
      },
    )

    return UserRepository.of({ findById })
  }),
)
```

Choose the constructor that matches acquisition:

```ts
Layer.succeed(Service, implementation)
Layer.sync(Service, () => implementation)
Layer.effect(Service, acquisitionEffect)
```

- Use `Layer.succeed` for an already-built value.
- Use `Layer.sync` for lazy synchronous construction.
- Use `Layer.effect` when construction reads services, config, or performs an
  Effect.
- Use `Layer.unwrap` when configuration or discovery selects a Layer.
- Read `RESOURCES.md` when acquisition owns cleanup.

## Composition

Use `Layer.provide` when an implementation dependency should be hidden after
composition:

```ts
export const UserRepositoryLayer = UserRepositoryLive.pipe(
  Layer.provide(DatabaseLive),
)
```

Use `Layer.provideMerge` only when both the produced service and the provided
dependency intentionally remain public. Use `Layer.mergeAll` for independent
services that should all remain exposed.

Prefer named, topologically understandable Layer values. Do not merge or
provide Layers merely to make the type checker stop reporting a missing
requirement.

## Test Services

Provide the same service interface with a focused test Layer:

```ts
export const UserRepositoryTest = Layer.succeed(
  UserRepository,
  UserRepository.of({
    findById: Effect.fn("UserRepository.findById.test")(
      (id: string) =>
        id === "known"
          ? Effect.succeed({ id, name: "Ada" })
          : Effect.fail(new UserNotFound({ id })),
    ),
  }),
)
```

Test implementations should preserve the production service's success and
failure contract. Do not expose mutable test internals unless the test
explicitly needs an observation or control hook.

## `Effect.fn`

Use named `Effect.fn` for public service methods and non-trivial internal
operations. It supports generator syntax and improves stack and span metadata.

```ts
export const loadUser = Effect.fn("Users.loadUser")(
  function* (id: string) {
    const repository = yield* UserRepository
    return yield* repository.findById(id)
  },
  Effect.annotateLogs({ component: "users" }),
)
```

Additional transforms apply to the whole call and receive the original
arguments. Good uses include error translation, spans, logging annotations,
bounded retry, timeout, cleanup, and small local provisioning. Keep local
branch logic in the function body.

## Module Surface

- Export the service tag, the intended Layers, and domain operations consumers
  need.
- Keep row codecs, vendor clients, helper schemas, and implementation details
  private.
- Follow the project's established module and barrel style.
- Avoid TypeScript namespaces or self-export tricks as universal defaults.

## Do Nots

- Do not turn pure functions into services solely for uniformity.
- Do not hide credentials, persistence, transports, or other required
  authority behind `Context.Reference` defaults.
- Do not run forever work inline during Layer acquisition; read
  `RESOURCES.md`.
- Do not collapse production and test construction into one branchy Layer.
- Do not use Layer composition as a blind make-it-compile tool.

## Official ai-docs

- `ai-docs/src/01_effect/01_basics`
- `ai-docs/src/01_effect/03_services`
