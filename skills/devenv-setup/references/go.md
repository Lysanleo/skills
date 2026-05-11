# Go Reference

Detect via: `go.mod`, `go.sum`.

## Common Setup

- Add Go toolchain.
- Add `gopls` when editor support matters and not provided elsewhere.
- Keep module cache behavior default unless repo needs pinned/offline behavior.

## Validation

```bash
devenv shell go test ./...
```
