# Design: Simplificación de src/utils.py y tests

> **Date:** 2026-03-22
> **Status:** Draft
> **Scope:** `src/utils.py`, `tests/test/python/test_utils.py`

---

## Context

Durante `/mr-quick` review se identificaron 4 sugerencias menores de simplificación:

1. `Final[re.Pattern[str]]` agrega complejidad sin beneficio
2. Docstring de `SLUG_PATTERN` duplica información de `CLAUDE.md`
3. `__all__: list[str]` es no convencional
4. Comentarios de tests desorganizados

---

## Decisiones

### 1. Simplificar `SLUG_PATTERN` type hint

**Antes:**
```python
SLUG_PATTERN: Final[re.Pattern[str]] = re.compile(...)
```

**Después:**
```python
SLUG_PATTERN: re.Pattern[str] = re.compile(...)
```

**Rationale:**
- Nombre en MAYÚSCULAS indica constante por convención
- `Final` es redundante para constantes de módulo
- Reduce complejidad cognitiva

### 2. Simplificar docstring

**Antes:** 11 líneas con reglas completas

**Después:**
```python
"""Regex for valid slugs. See CLAUDE.md for rules.

Examples:
    Valid: "sprint-01", "abc123"
    Invalid: "-sprint", "sprint-", "Sprint"
"""
```

**Rationale:**
- CLAUDE.md es la fuente de verdad para reglas
- Examples son útiles en código para quick reference
- Reduce duplicación

### 3. Simplificar `__all__` annotation

**Antes:**
```python
__all__: list[str] = ["is_valid_slug", "SLUG_PATTERN"]
```

**Después:**
```python
__all__ = ["is_valid_slug", "SLUG_PATTERN"]
```

**Rationale:**
- Python reconoce `__all__` sin type hint
- mypy strict no lo requiere para esta variable especial
- Sigue convención estándar

### 4. Reorganizar comentarios de tests

**Antes:** Comentarios mezclados

**Después:**
```python
[
    # === VALID ===
    ("sprint-valido-01", True),
    ...
    # === INVALID: empty ===
    ("", False),
    # === INVALID: uppercase ===
    ("A", False),
    # === INVALID: dash position ===
    ("-sprint", False),
    ...
    # === INVALID: special chars ===
    ("a_b", False),
]
```

**Rationale:**
- Agrupación por categoría mejora mantenibilidad
- Más fácil agregar edge cases nuevos
- Consistente con pattern de organizar tests

---

## Impacto

| Métrica | Antes | Después |
|---------|-------|---------|
| Líneas utils.py | 24 | ~18 |
| Complejidad type hints | Alta | Baja |
| Duplicación docs | Sí | No |
| Organización tests | Plana | Por categoría |

---

## Verificación

1. `uv run mypy src/` - debe pasar sin errores
2. `uv run pytest tests/` - 14 tests deben pasar
3. `uv run ruff check src/` - sin warnings

---

## Riesgos

**Ninguno crítico.** Los cambios son cosméticos y no afectan:
- Funcionalidad
- Type safety (mypy strict sigue pasando)
- Test coverage

---

## Rollout

1. Aplicar cambios a `src/utils.py`
2. Aplicar cambios a `tests/test/python/test_utils.py`
3. Correr `make lint && make test`
4. Commit con mensaje descriptivo
