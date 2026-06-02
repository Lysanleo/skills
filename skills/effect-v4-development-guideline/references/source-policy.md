# Source Policy

Use this reference whenever current docs, Effect v4 status, or citations matter.

## Current Version Truth

For every v4-specific claim, establish current truth in this order:

```bash
npm view effect version dist-tags --json
```

1. Local repo `package.json` and lockfile.
2. Live npm dist-tags.
3. Official v4 beta docs/API/source matching installed version.

Snapshot observed on 2026-06-02, for orientation only:

```json
{
  "version": "3.21.2",
  "dist-tags": {
    "latest": "3.21.2",
    "beta": "4.0.0-beta.75"
  }
}
```

Interpretation at snapshot time: v4 was beta. Do not cite this snapshot as current. If live npm differs, use live npm. If npm is unavailable, say registry status was not verified and rely only on local package files.

## Preferred Sources

Use sources in this order:

1. Local repo files and lockfiles.
2. npm dist-tags for package status: `npm view effect version dist-tags --json`.
3. Official Effect v4 beta docs for v4-only API and lifecycle behavior: https://effect-ts-effect-smol.mintlify.app/
4. Official API docs generated from source: https://effect-ts.github.io/effect/
5. Effect GitHub releases/source for commit/version-specific questions: https://github.com/Effect-TS/effect
6. Stable Effect docs for concepts or v3/stable APIs only: https://effect.website/docs/
7. Context7 for discovery snippets only; verify API claims against official docs/source:

```bash
curl -sS "https://context7.com/api/v2/libs/search?libraryName=effect&query=Effect+v4+Schema+Layer+ManagedRuntime" | jq '.results[0:5]'
curl -sS "https://context7.com/api/v2/context?libraryId=/websites/effect-ts_github_io_effect&query=ManagedRuntime+Layer+Schema+Effect.gen&type=txt"
```

## Citation Rules

- Cite official docs/API for API names, signatures, and lifecycle behavior.
- Cite npm output or package files for version status.
- For v4 beta APIs, cite v4 beta docs/API/source, not stable docs alone.
- Use third-party articles only for ecosystem context, not as API authority.
- If using beta-only APIs, state exact package tag or local installed version.
- If local package version conflicts with docs, local installed version wins for implementation; docs become evidence to investigate, not authority to force migration.

## Useful URLs

- Effect-v4 Docs: https://effect-ts-effect-smol.mintlify.app/
- API References: https://effect-ts-effect-smol.mintlify.app/reference/api-reference
- Running Effects guide: https://effect-ts-effect-smol.mintlify.app/core-concepts/running-effects
- ManagedRuntime API: https://effect-ts.github.io/effect/effect/ManagedRuntime.ts.html
- Effect API: https://effect-ts.github.io/effect/effect/Effect.ts.html
- Layer API: https://effect-ts.github.io/effect/effect/Layer.ts.html
- Schema docs: https://effect.website/docs/schema/
- Stream docs: https://effect.website/docs/stream/
- Observability: https://effect-ts-effect-smol.mintlify.app/advanced/observability
