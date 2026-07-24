# HTTP Servers

## When to read this

Read this when defining an incoming HTTP API, HttpApi endpoints, handlers,
middleware, authorization, OpenAPI output, server Layers, serverless web
handlers, or a client derived from the same API.

Also read `SCHEMA.md`, `SERVICES_LAYERS.md`, `ERRORS.md`, and `RESOURCES.md`
when the task crosses those boundaries.

## Version Check

Effect HTTP and HttpApi modules are unstable. Before writing imports or
combinators, inspect the target project's installed `effect`,
`@effect/platform-*`, and related packages. Official `main` may be ahead of
the project.

## Architecture

Separate four responsibilities:

```text
api/       schemas, endpoint groups, middleware contracts, root API
domain/    services, models, and typed failures
server/    handler and middleware implementations
runtime/   route composition, platform server, config, and launch
```

API definitions must not import server implementations. This keeps contracts
shareable with generated clients and prevents server dependencies from leaking
into browser or package consumers.

## Define the API

Define request, response, and documented error contracts with Schema:

```ts
import { Schema } from "effect"
import {
  HttpApi,
  HttpApiEndpoint,
  HttpApiGroup,
} from "effect/unstable/httpapi"

export class UsersApi extends HttpApiGroup.make("users")
  .add(
    HttpApiEndpoint.get("getById", "/:id", {
      params: {
        id: Schema.FiniteFromString.pipe(Schema.decodeTo(UserId)),
      },
      success: User,
      error: UserNotFound,
    }),
  )
  .prefix("/users")
{}

export class Api extends HttpApi.make("app-api").add(UsersApi) {}
```

Use Schema transformations where wire input differs from the domain type.
Annotate status, content type, security, and OpenAPI metadata on the contract
rather than hiding them in handler code.

## Implement Thin Handlers

Handlers translate transport data into service calls and translate service
failures into errors declared by the endpoint:

```ts
import { Effect, Layer } from "effect"
import { HttpApiBuilder } from "effect/unstable/httpapi"

export const UsersHandlers = HttpApiBuilder.group(
  Api,
  "users",
  Effect.fn(function* (handlers) {
    const users = yield* Users

    return handlers.handle("getById", ({ params }) =>
      users.getById(params.id).pipe(
        Effect.catchReason(
          "UsersError",
          "UserNotFound",
          Effect.fail,
          Effect.die,
        ),
      ),
    )
  }),
).pipe(
  Layer.provide(Users.layer),
)
```

Keep validation, repository calls, business decisions, and provider workflows
in domain services. A handler may read request context, call a service, and map
the service's typed failures to the endpoint contract.

## Middleware and Authorization

Define middleware contracts with the shared API and implement them on the
server:

- declare the services middleware provides to downstream handlers;
- declare required upstream services;
- declare authentication schemes and documented failures;
- keep token verification and user lookup in the server implementation; and
- add a separate client middleware implementation when generated clients must
  supply credentials.

Middleware should provide request-scoped context such as `CurrentUser`.
Business services should not parse transport headers directly.

## Compose and Run the Server

Compose handler Layers into the API Layer, then provide the platform server:

```ts
import { NodeHttpServer, NodeRuntime } from "@effect/platform-node"
import { Layer } from "effect"
import { HttpRouter } from "effect/unstable/http"
import { HttpApiBuilder } from "effect/unstable/httpapi"
import { createServer } from "node:http"

const ApiRoutes = HttpApiBuilder.layer(Api, {
  openapiPath: "/openapi.json",
}).pipe(
  Layer.provide(UsersHandlers),
)

export const HttpServerLayer = HttpRouter.serve(ApiRoutes).pipe(
  Layer.provide(NodeHttpServer.layer(createServer, { port: 3000 })),
)

HttpServerLayer.pipe(
  Layer.launch,
  NodeRuntime.runMain,
)
```

For serverless or embedded hosts, use the installed version's web-handler
adapter and preserve its disposer. The host owns calling that disposer when
the application instance ends.

## Typed Clients

`HttpApiClient` can derive a typed client from the same root API. Keep client
middleware implementations, base URL configuration, HttpClient
implementation, and retry policy in the client Layer.

Generated clients preserve endpoint names and Schema contracts at compile
time. They do not remove the need to check retry safety, authentication
storage, or target-version imports.

## Do Nots

- Do not put business rules or database queries in handlers.
- Do not import server implementations from shared API modules.
- Do not throw undocumented failures from an endpoint.
- Do not convert every unexpected service failure into success.
- Do not copy unstable imports from upstream without checking installed
  packages.
- Do not start a server or background worker outside an owned Layer Scope.
- Do not forget to dispose serverless web handlers that expose a disposer.

## Official ai-docs

- `ai-docs/src/51_http-server`

Read `10_basics.ts` together with every file under its `fixtures/` directory;
the API, middleware, domain service, handlers, runtime, and typed client are
split intentionally.
