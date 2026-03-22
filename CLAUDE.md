# anchor_dope - Sprint Pack Kit

> Infraestructura mínima para materializar sprint packs de forma determinista y fail-closed.

## Propósito

Genera carpetas con documentos de sprint (`ANCHOR.md`, `SKILL.md`, `AGENTS.md`, `PRIME.md`) a partir de un slug, garantizando que cada sprint tenga un contrato de contexto claro antes de la ejecución.

## Tecnologías

- **Bash** - Scripts de scaffolding y validación
- **Python 3.12+** - Utilidades de validación (is_valid_slug)
- **uv** - Gestión de dependencias
- **ruff** - Linting y formateo
- **mypy** - Type checking strict
- **pytest** - Testing

## Comandos Principales

```bash
# Crear sprint pack
./scripts/new_sprint_pack.sh "mi-sprint-01"

# Verificar integridad
./scripts/doctor.sh "mi-sprint-01"

# Tests
make test          # Bash + Python
make shell-test    # Solo bash
make python-test   # Solo pytest

# Lint
make lint          # ShellCheck + Mypy + Ruff
```

## Slug Rules

- Solo minúsculas, números y guiones medios
- No puede iniciar ni terminar con `-`
- No puede tener guiones consecutivos (`--`)
- Regex: `^[a-z0-9]+(-[a-z0-9]+)*$`

## Estructura del Proyecto

```
├── _ctx/           # Contexto del proyecto (ANCHOR, AGENTS, PRIME)
├── scripts/        # Scripts operativos
│   ├── new_sprint_pack.sh
│   ├── doctor.sh
│   ├── lint.sh
│   └── shared/utils.sh
├── templates/      # Templates .tmpl
├── tests/          # Tests bash y pytest
├── src/            # Código Python
└── Makefile
```

## Convenciones

- **Fail-closed**: Los scripts fallan si detectan colisiones o datos inválidos
- **TDD**: Ninguna funcionalidad sin su prueba previa
- **Pureza del dominio**: Los templates no contienen lógica, solo estructura
- **Cero magia**: Solo reemplazo de variables explícitas

## Para Agentes IA

1. Crea packs con `scripts/new_sprint_pack.sh <slug>`
2. Verifica con `scripts/doctor.sh <directorio>`
3. El `_ctx/ANCHOR.md` es la fuente de verdad del proyecto
4. No elimines `shared/utils.sh` (contiene validaciones de seguridad)
