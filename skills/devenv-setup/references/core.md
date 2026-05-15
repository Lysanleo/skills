# Core Reference

Use after repo inspection when choosing universal packages, tasks, setup defaults, and validation shape.

## Defaults

- Include only tools needed by build/test/dev workflow.
- Useful general packages: `git`, `pkg-config`, `gnumake`, `curl`, `jq`, `shellcheck`.
- For native builds, expect extra system libs. Prefer explicit Nix packages over ad hoc host installs.
- Put repeated commands in `tasks`, not long `enterShell` banners.

## Validation Shape

- Build shell: `devenv shell true`
- List tasks: `devenv tasks list`
- Run configured task: `devenv tasks run <task-name>`
- Run env tests: `devenv test`
- Run project test: `devenv shell <repo-test-command>`
- Prefer explicit smoke checks over messages printed by `enterShell`.
