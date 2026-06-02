# Migration Checklist

Use this before editing or reviewing Effect v3 -> v4 migration work.

## 1. Establish Truth

- Check local installed versions in `package.json` and lockfile.
- Check npm dist-tags; v4 may be beta.
- Identify all `effect` and `@effect/*` imports.
- Identify whether project already uses older `Context.Tag`, `Effect.Service`, `Schema`, `Layer`, runtime, platform, or test patterns.

Commands:

```bash
rg '"effect"|"@effect/' package.json pnpm-lock.yaml
rg 'Context\.Tag|Effect\.Service|Layer\.|ManagedRuntime|runPromise|runMain|Schema\.' .
```

## 2. Preserve Architecture

- Keep business functions returning `Effect`.
- Keep runtime crossing at app/framework boundary.
- Keep layer graph built once per app/test boundary.
- Preserve existing project naming unless it conflicts with role clarity; do not rename broadly during API migration.
- Do not replace typed errors with exceptions during migration.
- Do not add scattered `Effect.provide` or `Effect.runPromise` to silence type errors.

## 3. Verify API Changes

For each changed API:

1. Find official docs/API snippet.
2. Confirm installed package version supports it.
3. Update imports and call sites together.
4. Add before/after examples in review notes if behavior changed.

Use Context7 query:

```bash
curl -sS "https://context7.com/api/v2/context?libraryId=/websites/effect-ts_github_io_effect&query=Effect+v4+migration+Context+Service+Layer+Schema&type=txt"
```

## 4. Runtime and Lifecycle

Review each run boundary:

- CLI/process: `NodeRuntime.runMain`.
- Long-running layer app: `NodeRuntime.runMain(Layer.launch(AppLive))`.
- Existing web framework: app-level `ManagedRuntime`, disposed on shutdown.
- Tests: test runtime/layer setup, not production singleton unless intentional.

## 5. Review Risks

Flag these:

- v4 beta APIs used while package installs v3 latest.
- Runtime created per request.
- Layer resources never disposed.
- Promise clients wrapped without cancellation support when available.
- Schema decode result ignored or casted.
- `catchAll` swallows typed business errors.
- Retry applied inside core business logic instead of integration boundary.
