# Errors

## When to read this

Read this when defining typed failures, translating errors between
abstractions, choosing recovery combinators, distinguishing defects from
expected failures, or inspecting `Cause`.

## Selection Guide

- Reusable expected failure: `Schema.TaggedErrorClass`.
- Intentional untagged wrapper: `Schema.ErrorClass`.
- Throwing synchronous boundary: `Effect.try`.
- Rejecting Promise boundary: `Effect.tryPromise`.
- Translate one abstraction's failure into another: `Effect.mapError`.
- Recover one or several tagged failures: `Effect.catchTag` /
  `Effect.catchTags`.
- Recover every remaining expected failure: `Effect.catch`.
- Inspect defects, interruption, or combined failures: Cause-level operators,
  only at a boundary that owns that policy.

## Define Expected Failures

Expected failures belong in the Effect error channel and carry the evidence a
caller can act on.

```ts
import { Effect, Schema } from "effect"

export class UserNotFound extends Schema.TaggedErrorClass<UserNotFound>()(
  "UserNotFound",
  { userId: Schema.String },
) {}

export class PersistenceError
  extends Schema.TaggedErrorClass<PersistenceError>()(
    "PersistenceError",
    {
      operation: Schema.String,
      cause: Schema.Defect(),
    },
  ) {}

declare const findUser: (
  userId: string,
) => Effect.Effect<string, UserNotFound | PersistenceError>

export const displayName = findUser("u-1").pipe(
  Effect.catchTag(
    "UserNotFound",
    ({ userId }) => Effect.succeed(`unknown:${userId}`),
  ),
)
```

Use stable, domain-meaningful tags. Include vendor causes for diagnosis when
they are safe to retain, but do not expose vendor error types as the public
domain contract.

## Translate Failures at Boundaries

Wrap throwing or rejecting APIs at the adapter boundary:

```ts
export const readJson = Effect.fn("Files.readJson")(
  (path: string) =>
    Effect.tryPromise({
      try: () => fileSystem.readFile(path, "utf8"),
      catch: (cause) =>
        new PersistenceError({ operation: "Files.readJson", cause }),
    }),
)
```

Use `Effect.mapError` when a lower-level Effect already has a typed error but
the current service must expose its own contract. Translate once at the
abstraction boundary, not repeatedly throughout the workflow.

## Recover by Tag

Use `Effect.catchTag` for one tagged error and `Effect.catchTags` for several:

```ts
const recovered = findUser("u-1").pipe(
  Effect.catchTags({
    UserNotFound: ({ userId }) => Effect.succeed(`unknown:${userId}`),
    PersistenceError: (error) =>
      Effect.logError("user lookup failed", error).pipe(
        Effect.as("temporarily unavailable"),
      ),
  }),
)
```

Use `Effect.catch` only when the boundary truthfully handles every remaining
expected failure. Let unhandled failures remain visible.

## Errors with Reasons

Use the official reason-error model when one public error deliberately groups
a closed union of reasons. Then use `Effect.catchReason`,
`Effect.catchReasons`, or `Effect.unwrapReason` rather than manually
inspecting nested `_tag` fields.

This pattern is useful when callers should handle one stable parent error but
some boundaries need reason-specific behavior. Do not introduce it merely to
reduce the number of error types in a signature.

## Defects and Cause

Defects represent bugs or violated invariants, not ordinary business outcomes.
Interruption represents cancellation and must not be silently converted into
success.

Use Cause-level recovery only when the boundary owns a policy for defects,
interruption, parallel failures, or finalizer failures—for example a runtime
supervisor that reports a non-interrupt Cause before stopping. Prefer typed
error operators everywhere else.

## Do Nots

- Do not catch every error simply to keep a worker or request alive.
- Do not turn authentication, validation, not-found, or provider rejection
  into defects.
- Do not turn programmer bugs into expected domain failures.
- Do not use Cause-level recovery when `catchTag`, `catchTags`, or `catch`
  expresses the policy.
- Do not lose interruption while handling a broad Cause.
- Do not leak raw SDK, SQL, filesystem, or HTTP errors through a domain
  service.

## Official ai-docs

- `ai-docs/src/01_effect/04_errors`
