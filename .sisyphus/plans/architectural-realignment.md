# Plan: Reestructuración Documental — sprint-pack-kit

## VEREDICTO

**Estado actual: CRÍTICO.** `SKILL.md` compite directamente con `_ctx/ANCHOR.md` por soberanía. Es un duplicado casi textual del anchor con idéntica declaración de autoridad. El proyecto tiene dos reyes y ningún súbdito claro.

---

## CONFLICTOS DETECTADOS

### Conflicto 1 — SKILL.md declara soberanía propia (CRÍTICO)
- `SKILL.md:8-9` dice **"Rol: SSOT (Soberanía)"** y **"Este documento es la autoridad máxima del proyecto"**
- `_ctx/ANCHOR.md:3-4` dice **"Rol: SSOT (Soberanía)"** y **"Define el alcance, objetivos y decisiones irreversibles. Nada se mueve fuera de aquí"**
- **Dos documentos reclaman ser la autoridad máxima.** Contradicción fundacional.

### Conflicto 2 — SKILL.md duplica el 90% del contenido del anchor
Contenido duplicado palabra por palabra:
- Objective, North Star, In Scope, Out of Scope
- Irreversible Decisions, Local Guardrails
- Role Restrictions, Project Structure

### Conflicto 3 — PRIME.md referencia a SKILL.md como autoridad
- `PRIME.md:19` dice **"Leer SKILL.md para reglas no negociables"**
- Posiciona a SKILL.md como fuente de reglas, compitiendo con ANCHOR.md

### Conflicto 4 — PRIME.md referencia a archivo inexistente
- `PRIME.md:18` dice **"Leer `anchor.md`"** (sin prefijo `_ctx/`)
- El archivo correcto es `_ctx/ANCHOR.md`

### Conflicto 5 — AGENTS.md sin marcador de subordinación
- `_ctx/AGENTS.md` no tiene encabezado de derivación
- No declara que es subordinado al anchor

### Conflicto 6 — Contenido único que debe preservarse
Lo exclusivo de SKILL.md: COMANDOS ESENCIALES, FLUJO DE TRABAJO, Frontmatter YAML

---

## CONTENIDO QUE DEBE SALIR DE SKILL.md

| Sección SKILL.md | Razón para eliminar | Dónde vive |
|---|---|---|
| "Rol: SSOT (Soberanía)" | Competencia de soberanía | `_ctx/ANCHOR.md:3` |
| "autoridad máxima" claim | Competencia de soberanía | `_ctx/ANCHOR.md:4` |
| Objective | Duplicado | `_ctx/ANCHOR.md:9` |
| North Star | Duplicado | `_ctx/ANCHOR.md:12` |
| In Scope | Duplicado (desactualizado) | `_ctx/ANCHOR.md:15-20` |
| Out of Scope | Duplicado | `_ctx/ANCHOR.md:23-26` |
| IRREVERSIBLE DECISIONS | Duplicado | `_ctx/ANCHOR.md:32-37` |
| LOCAL GUARDRAILS | Duplicado | `_ctx/ANCHOR.md:39-44` |
| ANTES DE TOCAR CÓDIGO | Duplicado de PRIME.md | `_ctx/PRIME.md:10-14` |
| RESTRICCIONES DE ROLES | Duplicado de AGENTS.md | `_ctx/AGENTS.md:8-21` |
| ESTRUCTURA DEL PROYECTO | Documentación, no skill | `README.md` |

---

## PLAN APLICADO POR FASE

### Ownership — RACI por fase

| Fase | Responsable (R) | Aprueba (A) | Consultado (C) | Informado (I) |
|------|-----------------|-------------|-----------------|----------------|
| FASE 1 — SKILL.md | Ejecutor | Arquitecto | Revisor | Equipo |
| FASE 2 — ANCHOR.md patch | Arquitecto | Arquitecto | Revisor | Ejecutor |
| FASE 3 — PRIME.md | Ejecutor | Arquitecto | Revisor | Equipo |
| FASE 4 — SUMMARY.md | Ejecutor | Arquitecto | — | Equipo |
| FASE 5 — rules.json | Ejecutor | Arquitecto | Revisor | Equipo |
| Verificación final | Revisor | Arquitecto | Ejecutor | Equipo |

### FASE 1 — Reescritura total de SKILL.md
SKILL.md se convierte en puente operativo subordinado. **Operación atómica:** sobrescribir el archivo completo en una sola operación para evitar estados intermedios inconsistentes.
- Frontmatter con `plan_id`, `document_role: operational_bridge`, `authority_level: derived`, `obeys: "_ctx/ANCHOR.md"`
- Propósito: re-anclar al agente al contexto soberano
- Procedimiento de carga: ANCHOR → PRIME → AGENTS (orden obligatorio)
- Comandos esenciales y flujo de trabajo (contenido único preservado)
- Restricciones, failure modes, referencias autoritativas
- **Verificación post-escritura:** diff del nuevo SKILL.md contra ANCHOR.md — confirmar que NO queda contenido soberano (Objective, North Star, Irreversibles, Guardrails). Si aparece, reescribir.

### FASE 2 — Endurecimiento del anchor
Patch a `_ctx/ANCHOR.md`: añadir sección "Documentos Derivados — Jerarquía de Autoridad" con tabla de subordinación explícita.

### FASE 3 — PRIME.md como gate
Reescribir `_ctx/PRIME.md` con 4 gates obligatorios:
1. Confirmar carga del Anchor
2. Identificar fase actual (plan/execute/verify)
3. Verificar rol y superficie
4. Estado limpio (tests + lint)

### FASE 4 — Continuidad derivada
Crear `_ctx/SUMMARY.md` con estado actual, último batch, riesgos abiertos, siguiente paso.
Encabezado: "Documento derivado. Si contradice al Anchor, pierde."
**Regeneración:** SUMMARY.md se regenera desde el Anchor. Incluir timestamp de última actualización y nota: "Si este documento tiene más de 1 sprint de antigüedad, regenerar desde _ctx/ANCHOR.md."

### FASE 5 — Reglas operativas livianas
Crear `_ctx/rules.json` con tools por fase (plan: lectura, execute: mutación, verify: validación).
No segunda constitución.

---

## BORRADOR NUEVO SKILL.md

```markdown
---
name: sprint-pack-kit
description: Re-anchor al proyecto sprint-pack-kit. Carga contexto soberano desde _ctx/ANCHOR.md.
plan_id: sprint-pack-kit
document_role: operational_bridge
authority_level: derived
obeys: "_ctx/ANCHOR.md"
---

# SKILL: sprint-pack-kit
**Rol:** Puente Operativo
**Derivado de:** `_ctx/ANCHOR.md`
**Autoridad:** NINGUNA. Si contradice al Anchor, pierde.

## Propósito
Re-anclar al agente al contexto soberano del proyecto antes de cualquier acción.

## Cuándo se activa
- Trabajo sobre sprint packs (crear, validar, modificar)
- Slug validation, templates, scaffolding

## Procedimiento de Re-Anchor (orden obligatorio)
1. Cargar ANCHOR → Leer `_ctx/ANCHOR.md`
2. Cargar PRIME → Leer `_ctx/PRIME.md`
3. Cargar AGENTS → Leer `_ctx/AGENTS.md`
4. Identificar fase → plan/execute/verify
5. Verificar estado → make test && make lint

## Comandos esenciales
| Comando | Descripción |
|---------|-------------|
| ./scripts/new_sprint_pack.sh <slug> | Crea un nuevo sprint pack |
| ./scripts/doctor.sh <dir> | Verifica integridad de un pack |
| ./scripts/lint.sh [dir] | Ejecuta ShellCheck sobre scripts |
| make test | Ejecuta toda la suite de tests |
| make lint | Ejecuta ShellCheck + Mypy + Ruff |
| make format | Formatea código con Ruff |

## Flujo de trabajo
1. Definir slug → `validate_slug` en `scripts/shared/utils.sh` | **Responsable:** Ejecutor | **Done:** slug pasa regex `^[a-z0-9]+(-[a-z0-9]+)*$` + script retorna 0
2. Generar pack → `new_sprint_pack.sh <slug>` | **Responsable:** Ejecutor | **Done:** 4 archivos creados en directorio `<slug>/_ctx/`, sin errores, fail-closed si directorio existe
3. Verificar → `doctor.sh <slug>/` | **Responsable:** Ejecutor | **Done:** doctor retorna exit 0, todos los archivos presentes
4. Editar templates | **Responsable:** Arquitecto aprueba contenido, Ejecutor escribe | **Done:** templates contienen datos reales (no solo `{{SLUG}}`)
5. `make test && make lint` | **Responsable:** Ejecutor | **Done:** 0 fallos, 0 errores de lint

## Restricciones
- No redefine objetivo, scope, ni irreversibles
- No redefine roles
- No redefine pre-flight checks

## Failure Modes
| Modo | Causa | Recuperación |
|------|-------|-------------|
| Agent no carga anchor | Saltó paso 1 | Abortar. Cargar ANCHOR.md primero |
| SKILL.md contradice ANCHOR | Derivado desactualizado | Ignorar SKILL.md. Seguir ANCHOR.md |
| Conflicto entre docs | Derivado no sincronizado | Gana el Anchor |
| Anchor no encontrado | `_ctx/ANCHOR.md` no existe o fue movido | Abortar toda operación. No continuar sin SSOT. Reportar al Arquitecto. |
| Derivado corrupto | PRIME.md o AGENTS.md con sintaxis inválida o contenido ilegible | Leer directamente el Anchor como fallback. Regenerar derivado corrupto desde el Anchor. |

## Referencias autoritativas
- `_ctx/ANCHOR.md` — SSOT soberano
- `_ctx/PRIME.md` — Pre-flight checks
- `_ctx/AGENTS.md` — Roles y restricciones
- `_ctx/SUMMARY.md` — Estado y continuidad
- `_ctx/rules.json` — Reglas operativas por fase
```

---

## PATCH ANCHOR.md

Añadir después de `## Local Guardrails`:

```markdown
## Documentos Derivados — Jerarquía de Autoridad

| Documento | Rol | Autoridad |
|-----------|-----|-----------|
| `_ctx/PRIME.md` | Pre-flight gate | Derivado |
| `_ctx/AGENTS.md` | Definición de roles | Derivado |
| `_ctx/SUMMARY.md` | Estado y continuidad | Derivado |
| `_ctx/rules.json` | Reglas operativas | Derivado |
| `.claude/skills/sprint-pack-kit/SKILL.md` | Puente operativo | Derivado |

Regla: Si cualquier derivado contradice al Anchor, gana el Anchor.
```

---

## BORRADOR PRIME.md

```markdown
# Prime: sprint-pack-kit
**Rol:** Pre-flight Gate
**Derivado de:** `_ctx/ANCHOR.md`
**Autoridad:** NINGUNA.

## Pre-flight Checks (orden obligatorio)

### Gate 1 — Confirmar carga del Anchor
- He leído _ctx/ANCHOR.md antes de cualquier acción
- Conozco el objetivo, scope, y decisiones irreversibles
- Si no lo he leído → ABORTAR. Cargar primero.

### Gate 2 — Identificar fase actual
- ¿Estoy en fase plan? → Solo lectura/inspección
- ¿Estoy en fase execute? → Mutación controlada
- ¿Estoy en fase verify? → Validación con tests + lint

### Gate 3 — Verificar rol y superficie
- ¿Qué rol estoy ejecutando?
- ¿Qué slug voy a usar? ¿Pasa validate_slug?
- ¿El directorio destino ya existe?

### Gate 4 — Estado limpio
- make test pasa
- make lint pasa
- doctor.sh pasa (si trabajo sobre pack existente)
```

---

## BORRADOR AGENTS.md (patch — añadir header de derivación)

Añadir al inicio del archivo existente `_ctx/AGENTS.md`:

```markdown
**Documento derivado. Si contradice al Anchor, pierde.**
**Derivado de:** `_ctx/ANCHOR.md`

---
```

El contenido de roles (Arquitecto, Ejecutor, Revisor) permanece sin cambios.

---

## BORRADOR SUMMARY.md

```markdown
# Summary: sprint-pack-kit
**Documento derivado. Si contradice al Anchor, pierde.**
**Derivado de:** _ctx/ANCHOR.md
**Última actualización:** [FECHA] — Si tiene más de 1 sprint de antigüedad, regenerar desde Anchor.

## Estado actual
| Aspecto | Estado |
|---------|--------|
| Fase activa | V1 — Bootstrap & Core Logic ✅ COMPLETADA |
| Tests | 39 bash + 14 Python — todos pasando |
| Cobertura | 93% |
| Linter | 0 errores |

## Riesgos abiertos
- IO en Drive: latencia o errores de permisos
- Verbosity: templates podrían volverse densos

## Siguiente paso recomendado
- Pendiente: scaffold.sh de la skill integrado en flujo
```

---

## BORRADOR rules.json

```json
{
  "_derivation_notice": "Documento derivado de _ctx/ANCHOR.md. Si contradice al Anchor, pierde.",
  "project": "sprint-pack-kit",
  "phases": {
    "plan": {
      "description": "Exploración, lectura, diseño. Sin mutaciones.",
      "allowed_tools": ["read", "glob", "grep", "bash:read-only"],
      "forbidden_tools": ["write", "edit", "bash:destructive"]
    },
    "execute": {
      "description": "Mutación controlada.",
      "allowed_tools": ["read", "write", "edit", "bash"],
      "requirements": ["make test pasa", "make lint pasa", "Slug validado"]
    },
    "verify": {
      "description": "Validación.",
      "allowed_tools": ["bash:read-only", "bash:test"],
      "commands": ["make test", "make lint", "scripts/doctor.sh"]
    }
  },
  "conflict_resolution": "Gana _ctx/ANCHOR.md"
}
```

---

## RIESGOS RESIDUALES

| Riesgo | Probabilidad | Impacto | Mitigación |
|--------|-------------|---------|------------|
| SKILL.md viejo se queda en cache del agente | Alta | Medio | Reescribir inmediatamente después de aprobar |
| Agente no sigue orden de carga | Media | Medio | PRIME.md gate 1 es abort-si-no-cumple |
| SUMMARY.md se desactualiza | Alta | Bajo | Timestamp + staleness warning en header |
| rules.json se interpreta como segunda constitución | Baja | Alto | `_derivation_notice` + simplicidad del schema |
| Paths inconsistentes en PATCH ANCHOR.md | Baja | Medio | **FIXED** — paths corregidos a reales en este plan |
| AGENTS.md sin marcador de subordinación | Baja | Medio | **FIXED** — borrador con header de derivación añadido |

## SIGUIENTE PASO
Aprobar plan → ejecutar rewrites → verificar con make test && make lint

---

## AUDIT LOG

### tmux Plan Auditor (2026-03-22 08:52:49)
- 4 agentes, 51ms, confianza 0.88
- Patch-dedup-1 **APPROVED**: Aterrizar criterio exacto por paso → aplicado (Responsable + Done por paso)
- Patch-dedup-2 **APPROVED**: Operación atómica + verificación post-escritura → aplicado
- Patch-dedup-3 **REJECTED**: Falso positivo (bun/TS no aplica a proyecto bash/python)
- Patch-dedup-4 **APPROVED**: 2 failure modes añadidos → aplicado
- Patch-dedup-5 **NOTED**: Ya cubierto por gates existentes

### mr-quick (2026-03-22)
- 2 agentes (explore + explore)
- Critical-1 **FIXED**: Paths en PATCH ANCHOR.md corregidos
- Critical-2 **FIXED**: AGENTS.md header de derivación añadido al borrador
- Important-3 **FIXED**: SUMMARY.md staleness warning + timestamp
- Important-4 **NOTED**: rules.json schema — fuera de scope v1, suficientemente minimal
- Important-5 **FIXED**: RACI table por fase añadida
