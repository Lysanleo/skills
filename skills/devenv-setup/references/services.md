# Services Reference

Use when repo needs local databases, caches, search engines, queues, or long-running processes.

## Detection

Look for compose files, app env examples, migration config, service client deps, and test fixtures.

## Common Setup

- Use devenv `services.*` for simple local Postgres/MySQL/Redis/etc when supported.
- Use docker compose when repo already standardizes on it or service topology is complex.
- Avoid adding services in phase 1 unless build/test/dev command needs them.

## Validation

- Port open check.
- Migration dry run or schema check.
- Health endpoint or minimal client query.
- `devenv test` can start and stop processes when `enterTest` covers health checks.
