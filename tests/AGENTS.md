# Tests - Sprint Pack Kit

**Parent:** `../AGENTS.md`

---

## OVERVIEW

Suite de tests mixta: pytest (Python) + verify_*.sh (Bash). Ejecutar con `make test` o componentes individuales.

## STRUCTURE

```
tests/
├── run_all.sh                      # Runner de tests Bash
├── verify_creation.sh              # Creación + colisiones
├── verify_doctor.sh                # doctor.sh behavior
├── verify_doctor_integration.sh    # Flujo integrado: new_sprint_pack → doctor
├── verify_lint.sh                  # lint.sh execution
├── verify_lint_paths.sh            # lint.sh path scanning
├── verify_validation.sh            # Slug validation via new_sprint_pack.sh
└── test/
    └── python/
        └── test_utils.py           # pytest: is_valid_slug parametrizado
```

## WHERE TO LOOK

| Test | Covers | Framework |
|------|--------|-----------|
| `verify_creation.sh` | Creación de packs, colisiones, slug inválido | Bash |
| `verify_doctor.sh` | Integridad de packs (ANCHOR, AGENTS, PRIME) | Bash |
| `verify_doctor_integration.sh` | Flujo completo: crear → verificar | Bash |
| `verify_lint.sh` | Ejecución de lint.sh | Bash |
| `verify_lint_paths.sh` | Path scanning de lint.sh | Bash |
| `verify_validation.sh` | Validación de slugs | Bash |
| `test_utils.py` | `is_valid_slug()` con parametrización | pytest |

## CONVENTIONS

- **TDD**: Ninguna funcionalidad sin su prueba previa
- **Naming Bash**: `verify_*.sh` prefix
- **Naming Python**: `test_*.py` prefix, `Test*` classes, `test_*` methods
- **Runner**: `tests/run_all.sh` ejecuta todos los verify_*.sh secuencialmente
- **Parametrización**: pytest usa `@pytest.mark.parametrize` en test_utils.py
- **Markers**: `unit`, `integration` definidos en pyproject.toml

## COMMANDS

```bash
# Todos los tests
make test

# Solo Bash
make shell-test
# o directamente:
bash tests/run_all.sh

# Solo Python
make python-test
# o directamente:
uv run pytest tests/test/python/
```

## ANTI-PATTERNS

- **NO eliminar tests sin justificación**: Cada test cubre un caso específico
- **NO modificar tests para que pasen**: Arreglar el código, no el test
- **NO saltar TDD**: Tests primero, implementación después
- **NO romper tests existentes al añadir features**: Verificar con `make test`
