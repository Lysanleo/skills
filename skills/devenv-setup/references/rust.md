# Rust Reference

Detect via: `Cargo.toml`, `Cargo.lock`, `rust-toolchain.toml`.

## Common Setup

- Prefer `rust-overlay` for Rust toolchains.
- If repo has `rust-toolchain.toml`, use it as source of truth and wire rust-overlay to that toolchain.
- Before adding or editing rust-overlay config, check current rust-overlay docs and devenv docs.
- Prefer packages/toolchains from rust-overlay over ad hoc `rustc`/`cargo` pairs, but do not write exact attr names from memory. (doc)[https://devenv.sh/languages/rust/#2-rust-overlay-channels]
- Include `rust-analyzer` when editor support matters and not provided elsewhere.
- Add `pkg-config` and system libs when crates need native dependencies.

## Validation

- Prefer `devenv shell cargo test`.
- If full tests are slow, use `devenv shell cargo check`.
- For editor issues, confirm `rust-analyzer` path and editor env.
