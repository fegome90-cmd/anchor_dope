# Scripts - Sprint Pack Kit

**Parent:** `../AGENTS.md`

---

## OVERVIEW

Scripts operativos para crear, verificar y lintear sprint packs. Bash puro con patrón main() + guard clause.

## STRUCTURE

```
scripts/
├── new_sprint_pack.sh      # CLI principal: crea sprint pack desde slug
├── doctor.sh               # Verifica integridad de sprint pack
├── lint.sh                 # Orquestador de linters (ShellCheck, Mypy, Ruff)
├── shared/
│   └── utils.sh            # validate_slug() — NO ELIMINAR
└── reviewctl-wrappers/
    ├── reviewctl-wrapper.sh   # Wrapper Bash para branch-review
    └── reviewctl-wrapper.fish # Wrapper Fish (compatibilidad)
```

## WHERE TO LOOK

| Task | File | Notes |
|------|------|-------|
| Crear sprint pack | `new_sprint_pack.sh` | Llama a validate_slug, copia templates, reemplaza {{SLUG}} |
| Validar slug | `shared/utils.sh` | Regex: `^[a-z0-9]+(-[a-z0-9]+)*$` |
| Verificar pack | `doctor.sh` | Chequea _ctx/ANCHOR.md, AGENTS.md, PRIME.md |
| Lint proyecto | `lint.sh` | ShellCheck + Mypy + Ruff |
| Code review | `reviewctl-wrappers/` | Integración con branch-review CLI |

## CONVENTIONS

- **Patrón main()**: Todos los scripts usan `main()` con guard clause `if [[ "${BASH_SOURCE[0]}" == "${0}" ]]`
- **Sin `set -e`**: Manejo explícito de errores, no implícito
- **Fail-closed**: Scripts fallan ante datos inválidos o colisiones
- **Sourceabilidad**: Scripts pueden ser sourceados sin ejecutar
- **Colores**: Usar funciones de color para output legible

## ANTI-PATTERNS

- **NO eliminar `shared/utils.sh`**: Contiene validaciones de seguridad críticas
- **NO usar `set -e`**: Preferir manejo explícito de errores
- **NO hardcodear paths**: Usar variables o detección dinámica
- **NO modificar templates directamente**: Los cambios deben ir acompañados de tests
