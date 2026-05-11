# Editors Reference

Use when editor or LSP behavior matters.

## Direnv

`.envrc`:

```bash
use devenv
```

Then run:

```bash
direnv allow
```

## LSP Checks

- Do not assume terminal env equals editor env.
- If diagnostics fail, inspect editor process env and actual language server binary.
- For Zed/clangd, verify whether bundled clangd or devenv clangd is running.
- For Rust, confirm `rust-analyzer` path and toolchain visible inside editor env.
