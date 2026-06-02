# Effect Naming Conventions

Use this before creating or reviewing names for services, layers, schemas, errors, workflows, runtime boundaries, and trace spans.

## Principle

Name by Effect role. A reader should know whether a symbol is a service dependency, implementation layer, schema, domain failure, business workflow, or runtime boundary from the name and position.

Prefer local project conventions when already consistent. Use these rules for new code, inconsistent areas, or review comments.

## Quick Table

| Role | Convention | Example |
|---|---|---|
| Service | Domain capability, PascalCase | `Users`, `Trials`, `EligibilityEngine` |
| Service tag | Namespaced stable string | `"@app/Users"`, `"trialfit/Trials"` |
| Method | Verb lowerCamel | `findById`, `create`, `evaluate` |
| Layer | Implementation variant | `Users.Live`, `Users.Test`, `Users.InMemory` |
| Schema entity | Singular domain noun | `User`, `Trial`, `PatientProfile` |
| Input/Payload | Action + `Input`/`Payload` | `CreateTrialInput`, `EvaluateEligibilityPayload` |
| Brand ID | Entity + `Id` | `TrialId`, `PatientId` |
| Error | Concrete failure | `TrialNotFound`, `CriteriaParseFailed` |
| Error union | Domain + `Error` | `TrialMatchingError`, `UsersError` |
| Workflow | Verb phrase, no `run` prefix | `createTrial`, `evaluateEligibility` |
| Runtime | Boundary name | `appRuntime`, `effectRuntime` |
| Trace span | `Service.method` | `Trials.create`, `Users.findById` |

## Service Names

Prefer domain capability names over `SomethingService`.

Good:

```ts
class Users extends Context.Service<Users, {
  readonly findById: (id: UserId) => Effect.Effect<User, UserNotFound>
}>()("@app/Users") {}
```

Avoid:

```ts
class UserService {}
class TrialServiceImpl {}
```

Reason: Effect already has service as a concept. The symbol should name the capability, not repeat the pattern.

## Layer Names

Use layer names that reveal implementation, environment, or lifecycle.

Preferred:

```ts
Users.Live
Users.Test
Users.InMemory
Users.Postgres
```

Small modules may use:

```ts
static readonly layer = Layer.effect(...)
```

Avoid mixing `UsersLayer`, `LiveUsersLayer`, and `Users.Live` in the same module family.

## Schema and ID Names

Use singular nouns for entity schemas and `EntityId` for branded IDs.

```ts
const TrialId = Schema.String.pipe(Schema.brand("TrialId"))
type TrialId = typeof TrialId.Type

class Trial extends Schema.Class<Trial>("Trial")({
  id: TrialId,
  title: Schema.String
}) {}
```

For request-like data, include the action:

```ts
class CreateTrialInput extends Schema.Class<CreateTrialInput>("CreateTrialInput")({
  title: Schema.String
}) {}
```

## Error Names

Name expected failures by concrete business cause.

Good:

```ts
class TrialNotFound extends Schema.TaggedError<TrialNotFound>()("TrialNotFound", {
  id: TrialId
}) {}

const TrialMatchingError = Schema.Union(TrialNotFound, CriteriaParseFailed)
```

Avoid broad buckets unless fields add real context:

```ts
class UnknownError {}
class ServiceError {}
class FailedError {}
```

Choose either `UserNotFound` or `UserNotFoundError` per project. Do not mix both styles without reason.

## Workflow Names

Business workflows return `Effect`. Do not use `run*` unless the function crosses the runtime boundary.

Good:

```ts
const createTrial = (input: CreateTrialInput) =>
  Effect.gen(function* () {
    const trials = yield* Trials
    return yield* trials.create(input)
  })
```

Avoid:

```ts
const runCreateTrial = ...
const executeCreateTrial = ...
```

Use `run*` for boundary helpers only:

```ts
const runCreateTrial = (input: CreateTrialInput) =>
  appRuntime.runPromise(createTrial(input))
```

## Runtime Names

Name runtime by boundary, not business domain, unless multiple runtimes exist.

```ts
const appRuntime = ManagedRuntime.make(AppLive)
const testRuntime = ManagedRuntime.make(TestLive)
```

Avoid creating runtimes inside service methods or workflows. Runtime names should appear near framework/process edges.

## Trace Names

Use `Service.method` for `Effect.fn` names and spans.

```ts
const findById = Effect.fn("Users.findById")(function* (id: UserId) {
  // ...
})
```

Keep trace names stable and searchable. Update trace names when method names change.
