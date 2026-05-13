# Rust Reference

Detect via: `Cargo.toml`, `Cargo.lock`, `rust-toolchain.toml`.

## Common Setup

- Prefer the devenv Rust module over ad hoc Rust packages.
- Prefer `rust-toolchain.toml` as the Rust toolchain source of truth when creating or standardizing a Rust project; devenv should read it via `toolchainFile`.
- If a repo already has `rust-toolchain.toml`, use it as source of truth:

```nix
languages.rust = {
  enable = true;
  toolchainFile = ./rust-toolchain.toml;
};
```

- Minimal `rust-toolchain.toml`:

```toml
[toolchain]
channel = "stable"
components = ["rustfmt", "clippy", "rust-analyzer"]
profile = "minimal"
```

- Start simple with nixpkgs Rust only when no toolchain file is wanted:

```nix
languages.rust.enable = true;
```

- This provides `rustc`, `cargo`, `clippy`, `rustfmt`, and `rust-analyzer`.
- Do not add `rustc`, `cargo`, `clippy`, `rustfmt`, or `rust-analyzer` to `packages` unless there is a specific override need.
- If no `rust-toolchain.toml` is wanted but rust-overlay behavior is needed, use module channels:

```nix
languages.rust = {
  enable = true;
  channel = "stable";
  version = "latest";
};
```

- For nightly toolchains without `rust-toolchain.toml`:

```nix
languages.rust = {
  enable = true;
  channel = "nightly";
  components = [ "rustc" "cargo" "clippy" "rustfmt" "rust-analyzer" "miri" ];
};
```

- `channel = "stable"`, `"beta"`, or `"nightly"` uses rust-overlay semantics. Do not manually add rust-overlay inputs/overlays unless the devenv module cannot express the needed toolchain.
- If a project needs a pinned/latest rustup-like toolchain without a toolchain file, use module options such as `channel`, `version`, `components`, and `targets`; check current devenv docs before writing exact values.
- For cross compilation, use `languages.rust.targets`, not extra manual target packages.
- `languages.rust.lsp.enable` defaults to true. Override `languages.rust.lsp.package` only when editor/runtime evidence requires it.
- Add `pkg-config` and system libs when crates need native dependencies.

## Validation

- Prefer `devenv shell cargo test`.
- If full tests are slow, use `devenv shell cargo check`.
- For formatter/lint wiring, use `devenv shell cargo fmt --check` and `devenv shell cargo clippy --all-targets --all-features -- -D warnings` when appropriate.
- For editor issues, confirm `rust-analyzer` path and editor env.
