---
name: devenv-setup
description: >
  Set up or adjust project development environments using devenv, especially on NixOS.
  Use when the user wants to initialize a repo dev environment, create or modify
  devenv.nix/devenv.yaml/.envrc, add packages/languages/services/tasks, wire direnv,
  or make build/test/dev commands reproducible. Prefer devenv CLI commands such as
  devenv init, devenv inputs add, devenv update, devenv shell, devenv tasks, and
  devenv test before hand-writing configuration. Not for NixOS host configuration
  or production deployment.
---

# Devenv Setup

Goal: make repo runnable through `devenv`, with smallest useful config and clear validation.

## Hard Rules

- Start from current repo truth: inspect files before proposing config.
- Prefer CLI-first setup:
  - New repo: run `devenv init . --no-tui` when available.
  - Inputs: use `devenv inputs add <name> <url> --no-tui` when possible.
  - Lock refresh: use `devenv update --no-tui`.
  - Validation: use `devenv shell`, `devenv tasks`, and `devenv test`.
- Edit generated files only after CLI scaffold exists or current files prove manual edit is better.
- Keep phase 1 small: packages, language runtime, package manager, tasks, optional auto activation.
- Do not solve NixOS system config here. If host config is needed, route to NixOS/system skill.
- Do not invent package attr names from memory. For uncertain Nix packages/options, use live Nix docs/tooling.
- When devenv CLI, options, language modules, or service modules are uncertain, check current docs first.
- Keep `devenv.lock` tracked unless repo policy says otherwise. Keep `.devenv/` untracked.

## First Pass

1. Inspect project shape:
   - Run `scripts/probe-project.sh .` if available.
   - Also inspect README, package manifests, test config, editor config, existing Nix files.
2. Identify:
   - language/runtime
   - package manager
   - build/test/dev commands
   - services needed locally
   - editor/LSP needs
3. Choose smallest setup:
   - CLI scaffold if no devenv files exist.
   - Minimal patch if `devenv.nix` or `devenv.yaml` already exists.
4. Validate with the repo's real commands inside devenv.
5. Report exact commands run and any remaining manual step.

## CLI Baseline

For new setup, prefer this shape:

```bash
devenv init . --no-tui
devenv inputs add nixpkgs github:NixOS/nixpkgs/nixos-unstable --no-tui
devenv update --no-tui
devenv shell
devenv tasks
devenv test
```

Adjust when current CLI rejects a flag or repo already pins inputs.

For one command inside environment:

```bash
devenv shell <command>
```

Use explicit smoke checks over weak `enterShell` banners.

## Config Priorities

Prefer this order:

1. `packages` for tools that must exist in shell.
2. `languages.<name>` modules when they fit normal stack behavior.
3. `tasks` for repeatable build/test/dev commands.
4. `services` only when repo truly needs local DB/cache/search/etc.
5. `enterTest` for environment health checks; use tasks when setup grows.
6. Auto activation:
   - Prefer `devenv shell` plus `devenv hook` for devenv 2.x shell auto activation.
   - Use `.envrc` only when the user wants direnv/editor in-place environment loading.
   - For direnv, create `.envrc` manually; `devenv init` does not create it.
   - Put shared defaults in `devenv.nix`. Use `use devenv <flags>` only for local or opt-in overrides.

## Docs Policy

Use current docs when:

- CLI command or flag is uncertain.
- `languages.*`, `services.*`, `tasks`, `processes`, or option names are uncertain.
- A package attr path is unknown or may have moved.
- User asks for a language/tool not covered by local reference.

Doc lookup preference:

1. Context7 `/cachix/devenv` docs for devenv behavior.
2. Official docs at `https://devenv.sh/`.
3. NixOS/nixpkgs live search for package attrs, options, cache status.
4. Tool/language official docs when devenv docs are not enough.

## References

Read only the relevant reference after repo inspection:

- `references/core.md`: universal packages, tasks, and setup defaults.
- `references/node-typescript.md`: Node.js and TypeScript projects.
- `references/rust.md`: Rust projects.
- `references/python.md`: Python projects.
- `references/go.md`: Go projects.
- `references/c-cpp.md`: C and C++ projects.
- `references/jvm.md`: Java/JVM projects.
- `references/services.md`: local databases, caches, search, and processes.
- `references/editors.md`: direnv, editor env, and LSP checks.

## Common Validation

- Build shell: `devenv shell true`
- List tasks: `devenv tasks`
- Run env tests: `devenv test`
- Run project test: `devenv shell <repo-test-command>`
- Editor/LSP smoke: run language server or compiler check from inside `devenv shell`.

## Failure Handling

- If `devenv shell` mutates lockfiles, inspect diff before continuing.
- If network/cache fetch fails, report exact error and whether retry needs network/auth.
- If editor still sees wrong tools, inspect editor process env before changing config again.
- If package cannot be found, use live Nix search and record chosen attr.
