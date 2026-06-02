# Source Policy

Use this reference whenever current docs, Effect v4 status, or citations matter.

## Current Version Check

Run before v4-specific advice:

```bash
npm view effect version dist-tags --json
```

Observed on 2026-06-02:

```json
{
  "version": "3.21.2",
  "dist-tags": {
    "latest": "3.21.2",
    "beta": "4.0.0-beta.75"
  }
}
```

Interpretation: v4 is beta from npm dist-tags on this date. Do not call v4 stable unless a newer check proves it.

## Preferred Sources

Use sources in this order:

1. Local repo files and lockfiles.
2. npm dist-tags for package status: `npm view effect version dist-tags --json`.
3. Official Effect docs: https://effect.website/docs/
4. Official API docs generated from source: https://effect-ts.github.io/effect/
5. Effect GitHub releases/source: https://github.com/Effect-TS/effect
6. Context7 for current snippets:

```bash
curl -sS "https://context7.com/api/v2/libs/search?libraryName=effect&query=Effect+v4+Schema+Layer+ManagedRuntime" | jq '.results[0:5]'
curl -sS "https://context7.com/api/v2/context?libraryId=/websites/effect-ts_github_io_effect&query=ManagedRuntime+Layer+Schema+Effect.gen&type=txt"
```

## Citation Rules

- Cite official docs/API for API names, signatures, and lifecycle behavior.
- Cite npm output or package files for version status.
- Use third-party articles only for ecosystem context, not as API authority.
- If using beta-only APIs, state exact package tag or local installed version.

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
