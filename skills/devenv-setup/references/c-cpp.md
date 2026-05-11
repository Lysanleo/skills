# C / C++ Reference

Detect via: `Makefile`, `CMakeLists.txt`, `compile_commands.json`, `.clangd`, `meson.build`.

## Common Setup

- Packages often include `clang-tools`, `gcc` or `clang`, `gdb`, `lldb`, `bear`, `cmake`, `ninja`, `gnumake`.
- For clangd, ensure compile commands contain Nix-aware compiler paths.
- Prefer repo build system over invented wrapper scripts.

## Validation

- Run actual build command.
- If editor diagnostics matter, also run `clangd --check=<file>`.
- If Bear emits duplicate compile commands, keep the Nix-aware entry.
