# Core Reference

Use after repo inspection when choosing universal packages, tasks, and validation shape.

## Defaults

- Include only tools needed by build/test/dev workflow.
- Useful general packages: `git`, `pkg-config`, `gnumake`, `curl`, `jq`, `shellcheck`.
- For native builds, expect extra system libs. Prefer explicit Nix packages over ad hoc host installs.
- Put repeated commands in `tasks`, not long `enterShell` banners.
- Keep `devenv.lock` tracked unless repo policy says otherwise.
- Keep `.devenv/` untracked.

## Validation Shape

- Build shell: `devenv shell true`
- List tasks: `devenv tasks`
- Run env tests: `devenv test`
- Run project test: `devenv shell <repo-test-command>`
- Prefer explicit smoke checks over messages printed by `enterShell`.
