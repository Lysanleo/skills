# Node / TypeScript Reference

Detect via: `package.json`, lockfiles, `tsconfig.json`, `vite.config.*`, `next.config.*`.

## Common Setup

- Enable Node language support when appropriate.
- Match package manager from lockfile: `pnpm-lock.yaml`, `yarn.lock`, `package-lock.json`, `bun.lock`.
- Add task examples: install/check/test/dev/build according to existing scripts.
- Runtime env vars belong in shell/process config, not build-time package install.
- Private registries need auth outside committed config unless repo already has a safe pattern.

## Validation

- Prefer existing scripts: `test`, `check`, `typecheck`, `lint`, `build`.
- Example: `devenv shell pnpm test`.
