# Python Reference

Detect via: `pyproject.toml`, `uv.lock`, `poetry.lock`, `requirements.txt`.

## Common Setup

- Prefer existing manager: `uv`, Poetry, pip-tools, or plain venv.
- For ML/doc tooling, expect runtime shared libs and cache dirs.
- Keep package-manager caches local only when repo already wants reproducible/offline-ish workflow.

## Validation

- Use repo command first.
- Examples: `devenv shell uv run pytest`, `devenv shell poetry run pytest`, `devenv shell pytest`.
