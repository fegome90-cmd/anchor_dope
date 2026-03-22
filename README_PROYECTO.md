# Documentación: sprint-pack-kit

**Documento derivado. En caso de conflicto, prevalece el Anchor.**
**Derivado de:** `_ctx/ANCHOR.md`
**Última actualización:** 2026-03-22 — Verificar alineación con el Anchor si pasó más de 1 sprint.

---

Herramienta de infraestructura mínima para materializar **sprint packs** de forma determinista y fail-closed.

## Estructura
- `_ctx/`: Documentos soberanos del proyecto (ANCHOR, PRIME, AGENTS, SUMMARY, rules)
- `scripts/`: Lógica operativa (scaffolder, doctor, linter)
- `templates/`: Plantillas base `.tmpl`
- `tests/`: Pruebas de regresión (bash + pytest)

## Instrucciones para LLMs
Si eres un agente de IA operando en este repo:
1. Leer `_ctx/ANCHOR.md` primero — es el SSOT soberano
2. Leer `_ctx/PRIME.md` — responder todos los gates antes de tocar código
3. Leer `_ctx/AGENTS.md` — verificar rol y restricciones
4. Usar `scripts/new_sprint_pack.sh` para crear packs
5. Usar `scripts/doctor.sh` para verificar integridad
6. No eliminar `scripts/shared/utils.sh` (contiene validaciones de seguridad)

## Comandos

```bash
./scripts/new_sprint_pack.sh <slug>  # Crear sprint pack
./scripts/doctor.sh <dir>            # Verificar integridad
make test                            # Ejecutar tests
make lint                            # Ejecutar linters
```

## Slug Rules

Reglas canónicas en `_ctx/ANCHOR.md` → sección **Slug Rules**.
Resumen: `^[a-z0-9]+(-[a-z0-9]+)*$` — minúsculas, números, guiones medios, sin extremos ni consecutivos.
