#!/usr/bin/env bash
set -euo pipefail

root="${1:-.}"
cd "$root"

echo "== root =="
pwd

echo "== devenv/nix =="
find . -maxdepth 2 \( \
  -name 'devenv.nix' -o \
  -name 'devenv.yaml' -o \
  -name 'devenv.lock' -o \
  -name 'flake.nix' -o \
  -name '.envrc' \
\) -print | sort

echo "== manifests =="
find . -maxdepth 3 \( \
  -name 'package.json' -o \
  -name 'pnpm-lock.yaml' -o \
  -name 'yarn.lock' -o \
  -name 'package-lock.json' -o \
  -name 'bun.lock' -o \
  -name 'Cargo.toml' -o \
  -name 'rust-toolchain.toml' -o \
  -name 'pyproject.toml' -o \
  -name 'uv.lock' -o \
  -name 'poetry.lock' -o \
  -name 'requirements.txt' -o \
  -name 'go.mod' -o \
  -name 'Makefile' -o \
  -name 'CMakeLists.txt' -o \
  -name 'meson.build' -o \
  -name 'pom.xml' -o \
  -name 'build.gradle' -o \
  -name 'build.gradle.kts' \
\) -print | sort

echo "== service hints =="
find . -maxdepth 3 \( \
  -name 'docker-compose.yml' -o \
  -name 'docker-compose.yaml' -o \
  -name 'compose.yml' -o \
  -name 'compose.yaml' -o \
  -name '.env.example' -o \
  -name '.env.sample' \
\) -print | sort

echo "== available commands =="
for cmd in devenv direnv nix git jq; do
  if command -v "$cmd" >/dev/null 2>&1; then
    printf '%s: %s\n' "$cmd" "$(command -v "$cmd")"
  else
    printf '%s: missing\n' "$cmd"
  fi
done
