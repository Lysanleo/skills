# Editors Reference

Use when editor or LSP behavior matters.

## Direnv

Use direnv when the user explicitly wants in-place environment loading or an editor/LSP needs direnv.
For devenv 2.x, prefer `devenv shell` plus `devenv hook <shell>` unless direnv is explicitly useful.
`.envrc` is not created by `devenv init`; create it manually only when direnv is needed.
Never write a bare `.envrc` containing only `use devenv`; it fails when `use_devenv` has not been loaded.
`devenv direnvrc` uses a Bash `.envrc`; do not assume fish, zsh, nushell, aliases, functions, or shell-specific hooks are preserved.

`.envrc`:

```bash
#!/usr/bin/env bash
eval "$(devenv direnvrc)"
use devenv
```

Pass devenv flags after `use devenv` only for local or opt-in overrides:

```bash
#!/usr/bin/env bash
eval "$(devenv direnvrc)"
use devenv --option services.postgres.enable:bool true
```

Do not hide team-default behavior in `.envrc` flags. Put shared defaults in `devenv.nix`.
If using `--impure`, explain why impurity is needed before adding it.

Then run:

```bash
direnv allow
```

After changing `.envrc`, run `direnv allow` again.
If an existing `.envrc` has only `use devenv`, replace it with the template above before debugging editor/LSP behavior.

## LSP Checks

- Do not assume terminal env equals editor env.
- If diagnostics fail, inspect editor process env and actual language server binary.
- For Zed/clangd, verify whether bundled clangd or devenv clangd is running.
- For Rust, confirm `rust-analyzer` path and toolchain visible inside editor env.
