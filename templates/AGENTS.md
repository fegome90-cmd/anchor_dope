# Templates - Sprint Pack Kit

**Parent:** `../AGENTS.md`

---

## OVERVIEW

Templates .tmpl para generar sprint packs. Contienen placeholders `{{SLUG}}` reemplazados por sed. Zero lógica, solo estructura.

## STRUCTURE

```
templates/
└── sprint_base/
    ├── SKILL.md.tmpl           # Template para SKILL.md del sprint
    └── _ctx/
        ├── ANCHOR.md.tmpl      # Template para ANCHOR.md (fuente de verdad)
        ├── AGENTS.md.tmpl      # Template para AGENTS.md (roles)
        └── PRIME.md.tmpl       # Template para PRIME.md (pre-flight)
```

## WHERE TO LOOK

| File | Purpose |
|------|---------|
| `SKILL.md.tmpl` | Skill del sprint, se copia a la raíz del pack |
| `_ctx/ANCHOR.md.tmpl` | Contexto del sprint, fuente de verdad |
| `_ctx/AGENTS.md.tmpl` | Definición de roles (Arquitecto, Ejecutor, Revisor) |
| `_ctx/PRIME.md.tmpl` | Pre-flight checks antes de ejecutar |

## CONVENTIONS

- **Pureza del dominio**: Templates NO contienen lógica, solo estructura estática
- **Cero magia**: Solo reemplazo de variables explícitas (`{{SLUG}}`)
- **Placeholder**: `{{SLUG}}` es el único placeholder soportado
- **Reemplazo**: `sed "s/{{SLUG}}/$SLUG/g"` en `new_sprint_pack.sh`
- **Integridad**: Cualquier cambio en templates requiere actualización de tests

## ANTI-PATTERNS

- **NO añadir lógica a templates**: Solo estructura y placeholders
- **NO usar placeholders diferentes a `{{SLUG}}`**: Mantener consistencia
- **NO modificar sin actualizar tests**: `tests/verify_creation.sh` valida templates
