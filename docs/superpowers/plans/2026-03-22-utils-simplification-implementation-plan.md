# Plan de implementación: simplificación de `src/utils.py`

> Fecha: 2026-03-22
> Basado en: `docs/superpowers/specs/2026-03-22-utils-simplification-design.md`
> Tipo: cambios cosméticos pequeños y verificables

## Objetivo

Aplicar simplificaciones cosméticas en `src/utils.py` y ordenar los casos del parametrizado en `tests/test/python/test_utils.py`, sin cambiar comportamiento ni cobertura.

## Ajustes previos incorporados al plan

1. No mantener un string suelto debajo de `SLUG_PATTERN`; si se documenta la regex, usar comentario inline breve o eliminar documentación redundante.
2. No referenciar `CLAUDE.md` desde código productivo.
3. Verificación debe cubrir también `tests/`.

## Responsables por fase

- Implementación: agente.
- Validación local (`ruff`, `mypy`, `pytest`): agente.
- Aprobación para commit: usuario.

## Cambios

### 1. Simplificar imports y anotaciones en `src/utils.py`
- Eliminar `from typing import Final`.
- Cambiar `SLUG_PATTERN: Final[re.Pattern[str]]` por `SLUG_PATTERN: re.Pattern[str]`.
- Cambiar `__all__: list[str]` por `__all__` sin anotación explícita.

### 2. Simplificar documentación inline de `SLUG_PATTERN`
- Eliminar el bloque de string multilínea actual bajo `SLUG_PATTERN`.
- Reemplazarlo por una de estas opciones, priorizando la más simple:
  - comentario inline corto encima de la constante, o
  - sin documentación local si la regex ya es suficientemente clara.
- Mantener ejemplos o reglas solo si agregan valor inmediato al lector del código.

### 3. Reorganizar casos en `tests/test/python/test_utils.py`
- Mantener exactamente los mismos inputs y resultados esperados.
- Agrupar comentarios por categoría:
  - valid
  - invalid: empty
  - invalid: uppercase
  - invalid: dash position
  - invalid: special chars
- No agregar ni quitar casos en este cambio.

## Restricciones

- Sin cambios funcionales.
- Sin cambios en regex ni contrato de `is_valid_slug`.
- Sin cambios de cobertura.
- Mantener compatibilidad con mypy strict.

## Secuencia de ejecución

### Fase 1. Ajustes mínimos en `src/utils.py`
Criterio de salida: `src/utils.py` queda más idiomático y sin cambiar comportamiento.

1. Eliminar `Final` del import y de la anotación de `SLUG_PATTERN`.
2. Quitar la anotación explícita de `__all__`.
3. Eliminar el string multilínea usado como pseudo-docstring de variable.
4. Si hace falta contexto local, reemplazarlo por un comentario inline corto; si no agrega valor, omitirlo.

### Fase 2. Orden de casos en `tests/test/python/test_utils.py`
Criterio de salida: mismos casos, mismo orden lógico por categoría, mismo comportamiento esperado.

1. Reagrupar comentarios del parametrizado por categorías.
2. No agregar ni quitar inputs.
3. No modificar valores esperados.

### Fase 3. Verificación
Criterio de salida: todas las validaciones locales pasan sin cambios funcionales.

1. Ejecutar `uv run ruff check src tests`.
2. Ejecutar `uv run mypy src`.
3. Ejecutar `uv run pytest tests`.

### Fase 4. Cierre
Criterio de salida: cambios listos para revisión final del usuario.

1. Resumir archivos tocados y validaciones ejecutadas.
2. Dejar listo para commit, sin commitear hasta aprobación del usuario.

## Criterios de aceptación

- `src/utils.py` queda más corto y más idiomático.
- No queda referencia a `CLAUDE.md` en código productivo.
- No queda string suelto usado como pseudo-docstring de variable.
- `tests/test/python/test_utils.py` conserva exactamente los mismos casos y resultados esperados.
- `uv run ruff check src tests` pasa.
- `uv run mypy src` pasa.
- `uv run pytest tests` pasa.

## Riesgos

- Riesgo bajo: convertir documentación inline en algo demasiado escueto.
- Mitigación: preservar claridad mínima en nombre de constante + regex + tests parametrizados.
