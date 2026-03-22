# sprint-pack-kit

Herramienta de infraestructura mínima para materializar **sprint packs** de forma determinista y fail-closed.

## Qué hace

Genera una carpeta con los documentos del sprint (`ANCHOR.md`, `SKILL.md`, `AGENTS.md`, `PRIME.md`) a partir de un slug, garantizando que cada sprint tenga un contrato de contexto claro antes de la ejecución.

```
./scripts/new_sprint_pack.sh mi-feature
```

## Estructura

```
├── _ctx/
│   ├── ANCHOR.md              # SSOT del proyecto
│   ├── AGENTS.md              # Definición de roles
│   └── PRIME.md               # Pre-flight checks
├── README.md                  # Documentación de uso
├── scripts/
│   ├── new_sprint_pack.sh     # Generador de sprint packs
│   ├── doctor.sh              # Validador de integridad
│   ├── lint.sh                # ShellCheck linter
│   ├── reviewctl-wrappers/    # Wrappers para branch-review
│   └── shared/
│       └── utils.sh           # Utilidades (validate_slug)
├── templates/
│   └── sprint_base/           # Templates .tmpl (ANCHOR, SKILL, AGENTS, PRIME)
├── tests/
│   ├── run_all.sh             # Test runner
│   ├── verify_creation.sh     # Tests de creación y colisión
│   ├── verify_doctor.sh       # Tests de doctor.sh
│   ├── verify_lint_paths.sh   # Tests de lint.sh
│   ├── verify_utils.sh        # Tests de validate_slug
│   ├── verify_validation.sh   # Tests de validación de slugs
│   └── test/python/           # Tests pytest
├── src/
│   └── utils.py               # Validación Python (is_valid_slug)
├── Makefile                   # make lint, make test, make format
└── pyproject.toml             # Config Python (ruff, mypy, pytest)
```

## Uso

### Crear un sprint pack
```bash
./scripts/new_sprint_pack.sh "mi-sprint-01"
```

### Verificar integridad
```bash
./scripts/doctor.sh "mi-sprint-01"
```

### Ejecutar tests
```bash
make test          # Bash + Python
make shell-test    # Solo bash
make python-test   # Solo pytest
```

### Lint
```bash
make lint          # ShellCheck + Mypy + Ruff
```

## Slug Rules

- Solo minúsculas, números y guiones medios
- No puede iniciar ni terminar con `-`
- No puede tener guiones consecutivos (`--`)
- Regex: `^[a-z0-9]+(-[a-z0-9]+)*$`

Válidos: `sprint-01`, `mi-feature-alpha`, `v2`
Inválidos: `Sprint_01`, `-sprint`, `a--b`, `sprint-`

## Code Review con reviewctl

Este proyecto tiene integración con [branch-review](https://github.com/fegome90-cmd/branch-review) para revisiones de código automatizadas.

### Configuración

Opcionalmente, configura `REVIEW_API_TOKEN` para usar el modo API. Sin él, el wrapper ejecuta en modo local-direct.

```bash
export REVIEW_API_TOKEN=tu_token  # Opcional
```

### Comandos

```bash
# Cargar wrappers
source scripts/reviewctl-wrappers/reviewctl-wrapper.sh

# Flujo completo (usa --reset para limpiar estado previo)
reviewctl_full_workflow
reviewctl_full_workflow --reset

# Paso a paso
reviewctl_init      # Iniciar revisión
reviewctl_plan      # Generar plan
reviewctl_run       # Ejecutar agentes
reviewctl_verdict   # Obtener veredicto (PASS/FAIL)

# Comandos adicionales
reviewctl_status    # Ver estado actual
reviewctl_explore   # Explorar contexto/diff
```

## Docs para Agentes IA

Si eres un agente de IA operando en este repo:

1. Crea packs con `scripts/new_sprint_pack.sh <slug>`
2. Verifica con `scripts/doctor.sh <directorio>`
3. No elimines `shared/utils.sh` (contiene validaciones de seguridad)
4. El `_ctx/ANCHOR.md` es la fuente de verdad del proyecto
5. Usa `reviewctl_*` para revisiones de código antes de merge
