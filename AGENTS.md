# PROJECT KNOWLEDGE BASE

**Generated:** 2026-03-22T13:37:00Z
**Commit:** 19cb759
**Branch:** main

## OVERVIEW

Sprint Pack Kit — infraestructura mínima para materializar sprint packs de forma determinista y fail-closed. Genera carpetas con documentos de sprint (`ANCHOR.md`, `SKILL.md`, `AGENTS.md`, `PRIME.md`) a partir de un slug. Stack: Bash + Python 3.12+.

## STRUCTURE

```
anchor_dope/
├── _ctx/              # Contexto del proyecto (ANCHOR, AGENTS, PRIME) + review_runs/
├── scripts/           # Scripts operativos (scaffolding, doctor, lint)
│   ├── shared/        # Utilidades comunes (validate_slug)
│   └── reviewctl-wrappers/  # Wrappers para branch-review
├── templates/         # Templates .tmpl para sprint packs
│   └── sprint_base/_ctx/   # Templates de contexto (ANCHOR, AGENTS, PRIME)
├── tests/             # Tests Bash + Python
│   └── test/python/   # Tests pytest
├── src/               # Código Python (utils.py)
├── AGENTS.md          # Este archivo
├── CLAUDE.md          # Documentación del proyecto
├── Makefile           # Entrypoints: format, lint, test
└── pyproject.toml     # Config Python (ruff, mypy, pytest)
```

## WHERE TO LOOK

| Task | Location | Notes |
|------|----------|-------|
| Crear sprint pack | `scripts/new_sprint_pack.sh` | Slug → directorio con templates |
| Verificar integridad | `scripts/doctor.sh` | Valida _ctx/ANCHOR.md, AGENTS.md, PRIME.md |
| Validar slug | `scripts/shared/utils.sh` o `src/utils.py` | Regex: `^[a-z0-9]+(-[a-z0-9]+)*$` |
| Templates sprint | `templates/sprint_base/` | .tmpl files con {{SLUG}} placeholders |
| Tests Python | `tests/test/python/test_utils.py` | pytest con parametrización |
| Tests Bash | `tests/verify_*.sh` | Ejecutados por tests/run_all.sh |
| Config linters | `pyproject.toml` | ruff, mypy, pytest |
| Flujo review | `scripts/reviewctl-wrappers/` | Integración branch-review |

## CODE MAP

| Symbol | Type | Location | Role |
|--------|------|----------|------|
| `is_valid_slug` | function | `src/utils.py` | Validación Python de slugs |
| `validate_slug` | function | `scripts/shared/utils.sh` | Validación Bash de slugs |
| `new_sprint_pack.sh` | script | `scripts/` | CLI principal: crea sprint pack |
| `doctor.sh` | script | `scripts/` | Verificador de integridad |
| `lint.sh` | script | `scripts/` | Orquestador de linters |
| `run_all.sh` | script | `tests/` | Runner de tests Bash |
| `TestIsValidSlug` | class | `tests/test/python/test_utils.py` | Tests pytest para validación |

## CONVENTIONS

- **Fail-closed**: Scripts fallan si detectan colisiones o datos inválidos
- **TDD**: Ninguna funcionalidad sin su prueba previa
- **Pureza del dominio**: Templates no contienen lógica, solo estructura
- **Cero magia**: Solo reemplazo de variables explícitas en templates
- **Python 3.12+**: Requisito mínimo del proyecto
- **Strict typing**: mypy strict=true, disallow_untyped_defs
- **Ruff**: line-length=100, target-version=py312, reglas E/F/I/W/C90/UP

## ANTI-PATTERNS (THIS PROJECT)

- No eliminar `scripts/shared/utils.sh` (contiene validaciones de seguridad)
- No modificar templates directamente sin actualizar los tests
- No usar `set -e` en scripts Bash (manejo explícito de errores)
- No romper la relación slug ↔ regex `^[a-z0-9]+(-[a-z0-9]+)*$`

## UNIQUE STYLES

- Slug validation dual: Python (`src/utils.py`) + Bash (`scripts/shared/utils.sh`)
- Templates con placeholders `{{SLUG}}` reemplazados por sed
- Tests mixtos: pytest (Python) + verify_*.sh (Bash)
- Integración reviewctl para flujos de code review automatizados
- _ctx/ como fuente de verdad del contexto del proyecto

## COMMANDS

```bash
# Crear sprint pack
./scripts/new_sprint_pack.sh "mi-sprint-01"

# Verificar integridad
./scripts/doctor.sh "mi-sprint-01"

# Formatear código
make format

# Lint (ShellCheck + Mypy + Ruff)
make lint

# Tests completos
make test

# Solo tests Bash
make shell-test

# Solo tests Python
make python-test
```

## NOTES

- `_ctx/ANCHOR.md` es la fuente de verdad del proyecto
- `pyproject.toml` centraliza config de ruff, mypy, pytest (no hay pytest.ini separado)
- pytest-cov está en dev dependencies pero no habilitado por default
- Scripts Bash usan patrón main() con guard clause para sourceabilidad
- reviewctl-wrappers requiere branch-review clonado y opcionalmente REVIEW_API_TOKEN
