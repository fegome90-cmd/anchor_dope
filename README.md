# Sprint Pack Kit

> Infraestructura mínima para materializar sprint packs de forma determinista y fail-closed.

[![Python 3.12+](https://img.shields.io/badge/python-3.12+-blue.svg)](https://www.python.org/downloads/)
[![License: MIT](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Ruff](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/astral-sh/ruff/main/assets/badge/v2.json)](https://github.com/astral-sh/ruff)
[![Checked with mypy](https://www.mypy-lang.org/static/mypy_badge.svg)](https://mypy-lang.org/)

Genera planes con documentos soberanos (`ANCHOR.md`, `SKILL.md`, `AGENTS.md`, `PRIME.md`) en `_ctx/plans/<plan-id>/`, garantizando que cada sprint tenga un contrato de contexto claro antes de la ejecución.

## Quick Start

```bash
./scripts/new_sprint_pack.sh "auth-refactor"
./scripts/doctor.sh --active
./scripts/doctor.sh "auth-refactor"
make all
```

## What It Generates

```
_ctx/plans/
├── active_plan.json              # Puntero mecánico (NO autoridad)
│
└── auth-refactor/
    ├── SKILL.md                  # Puente operativo
    └── _ctx/
        ├── ANCHOR.md             # SSOT de este plan
        ├── AGENTS.md             # Roles de este plan
        └── PRIME.md              # Gates de este plan
```

## Commands

| Command | Description |
|---------|-------------|
| `./scripts/new_sprint_pack.sh <slug>` | Crear plan en `_ctx/plans/<slug>/` |
| `./scripts/doctor.sh --active` | Auditar plan activo |
| `./scripts/doctor.sh <plan-id>` | Auditar plan específico |
| `./scripts/doctor.sh <path>` | Auditar directorio directo |
| `make test` | Tests (Bash + Python) |
| `make lint` | ShellCheck + Mypy + Ruff |
| `make format` | Auto-format Python |

## Slug Rules

- Solo minúsculas, números y guiones medios (`a-z`, `0-9`, `-`)
- No puede iniciar ni terminar con `-`
- No puede tener guiones consecutivos (`--`)
- Regex: `^[a-z0-9]+(-[a-z0-9]+)*$`

**Válidos**: `sprint-01`, `auth-refactor`, `v2`
**Inválidos**: `Sprint_01`, `-sprint`, `a--b`, `sprint-`

## Project Structure

```
├── _ctx/                         # Contexto del proyecto
│   ├── ANCHOR.md                 # SSOT del proyecto
│   ├── AGENTS.md, PRIME.md, SUMMARY.md, rules.json
│   └── plans/                    # Namespace de planes
│       ├── active_plan.json      # Puntero al plan activo
│       └── <plan-id>/            # Planes individuales
├── scripts/
│   ├── new_sprint_pack.sh        # Scaffolder
│   ├── doctor.sh                 # Verificador
│   ├── lint.sh                   # Linter
│   └── shared/utils.sh           # Slug validation
├── templates/sprint_base/        # Templates .tmpl
├── tests/                        # Tests Bash + Python
├── src/utils.py                  # Python: is_valid_slug
├── Makefile                      # Entrypoints
└── pyproject.toml                # Python config
```

## Out of Scope

- LLM integration
- Git hooks
- ADR generation
- External tooling (code review, CI/CD)

## For AI Agents

1. Read `_ctx/ANCHOR.md` — project SSOT
2. To work on a plan: load `_ctx/plans/<plan-id>/_ctx/ANCHOR.md`
3. Read the plan's `PRIME.md` — answer all gates
4. Read the plan's `AGENTS.md` — verify role
5. Verify with `doctor.sh --active` or `doctor.sh <plan-id>`
6. **Never delete `shared/utils.sh`**

## Prerequisites

- **Python 3.12+**, **uv**, **ShellCheck**

## Installation

```bash
git clone <repo-url> && cd sprint-pack-kit && uv sync
```

## License

MIT
