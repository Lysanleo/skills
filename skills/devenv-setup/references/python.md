# Python Reference

Detect via: `pyproject.toml`, `uv.lock`, `poetry.lock`, `requirements.txt`.

## Common Setup

- Prefer the devenv Python module over ad hoc Python packages.
- Prefer existing manager: `uv`, Poetry, requirements, or plain venv.
- Do not add `python`, `uv`, `poetry`, or Python LSP tools to `packages` unless there is a specific override need. Use `languages.python.*`.
- Start simple:

```nix
languages.python.enable = true;
```

- For a specific Python from nixpkgs, still use the module:

```nix
languages.python = {
  enable = true;
  package = pkgs.python313;
};
```

- For version-managed Python, use `languages.python.version` and make sure `devenv.yaml` has the required `nixpkgs-python` input from current devenv docs.
- For `uv` projects:

```nix
languages.python = {
  enable = true;
  venv.enable = true;
  uv = {
    enable = true;
    sync.enable = true;
  };
};
```

- Use `uv.sync.enable = true` when dependencies should sync on shell entry. If the repo wants manual control, keep `uv.enable = true`, set no auto-sync, and add a task such as `"python:sync".exec = "uv sync";`.
- Use `venv.enable = true` when devenv should manage the virtualenv for `uv`/plain venv workflows.
- For Poetry projects:

```nix
languages.python = {
  enable = true;
  poetry = {
    enable = true;
    activate.enable = true;
    install.enable = true;
  };
};
```

- Use `poetry.activate.enable = true` when shell commands should see the Poetry environment directly. If the repo expects explicit `poetry run`, install-only is enough.
- For `requirements.txt` or plain virtualenv projects:

```nix
languages.python = {
  enable = true;
  venv = {
    enable = true;
    requirements = ./requirements.txt;
  };
};
```

- Do not enable multiple dependency managers for the same project unless the repo already uses them intentionally.
- Only set custom env such as `UV_PROJECT_ENVIRONMENT = ".venv"` when the repo specifically wants project-local venvs; otherwise let the module manage venv state.
- For ML/doc tooling, expect runtime shared libs, manylinux/wheel issues, and cache dirs.
- If binary wheels fail to load shared libraries, first consider `languages.python.manylinux.enable` and needed system libraries before ad hoc `LD_LIBRARY_PATH`.
- Keep package-manager caches local only when repo already wants reproducible/offline-ish workflow.

## Validation

- Use repo command first.
- Examples: `devenv shell uv run pytest`, `devenv shell poetry run pytest`, `devenv shell pytest`.
- For module wiring, include `devenv shell python --version`, `devenv shell uv --version` or `devenv shell poetry --version` when relevant.
