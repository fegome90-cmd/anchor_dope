# Documentación: Motor de Interacciones Aisladas

Este proyecto fue generado para gestionar unidades de trabajo (Sprints) de forma segura y automatizada.

## Estructura
- `scripts/`: Lógica operativa.
- `templates/`: Plantillas base.
- `tests/`: Pruebas de regresión.

## Instrucciones para LLMs
Si eres un agente de IA operando en este repo:
1. Usa `scripts/new_sprint_pack.sh` para crear carpetas.
2. Usa `scripts/doctor.sh` para verificar integridad.
3. No elimines la carpeta `shared/utils.sh` ya que contiene las validaciones de seguridad.



Para que este proyecto no derive en el caos que intenta solucionar, el **Anchor** debe ser de granito. Este documento es el **SSOT** (Single Source of Truth) y el guardián de la visión del `sprint-pack-kit`.

Aquí tienes la redacción constitucional para tu `docs/plans/SPRINT-PACK-KIT-ANCHOR.md`:

---

# SPRINT-PACK-KIT-ANCHOR

## Objective
Construir una herramienta de infraestructura mínima, determinista y "fail-closed" para materializar **sprint packs** (Anchor + Skill + Resources) de forma consistente en cualquier repositorio.

## North Star
Eliminar la fricción del arranque y la deriva operativa en sprints complejos, garantizando que cada pieza de trabajo tenga un contrato de contexto claro antes de la ejecución.

## In Scope (v1)
* **Templates:** Moldes base (`.tmpl`) para Anchor, Skill, Agents y Prime.
* **Scaffolder:** Script de Bash (`new_sprint_pack.sh`) para la generación de archivos.
* **Doctor:** Validador estructural (`doctor_sprint_pack.sh`).
* **TDD Harness:** Suite de pruebas para validar el contrato del generador.
* **Ejemplos:** Un pack de ejemplo funcional para referencia.

## Out of Scope (v1)
* Integración directa con LLMs (el kit prepara el terreno para la IA, no la ejecuta).
* Hooks de Git automáticos.
* Generación automática de ADRs complejos.
* Metadatos pesados o bases de datos de seguimiento.

## Active Phase
**V1 - Bootstrap & Core Logic**

## Irreversible Decisions
* **Repo Independiente:** El kit vive fuera de los proyectos que asiste para evitar contaminación de dependencias.
* **Anchor como Soberano:** El Anchor generado es siempre la autoridad máxima del sprint; la Skill es solo el puente operativo.
* **Shell Nativo:** Uso de Bash puro para minimizar dependencias en entornos de CI/CD o contenedores.
* **Prohibición de Sobreescritura:** El generador fallará si detecta que los archivos ya existen (Fail-closed), a menos que se use un flag explícito.

## Local Guardrails
* **Pureza del Dominio:** Los templates no deben contener lógica de implementación, solo estructura.
* **Cero "Magia":** No se permite inferencia semántica; el script solo reemplaza variables explícitas.
* **TDD Obligatorio:** Ninguna funcionalidad se integra sin su prueba roja previa.

## Current Batch
1.  Configuración de entorno en Colab/Drive.
2.  Definición de templates base.
3.  Implementación del Scaffolder con validación de contrato.

## Exit Criteria (v1)
* [ ] El script genera los 4 archivos correctamente desde un slug.
* [ ] El `doctor` valida la integridad del pack generado.
* [ ] Las pruebas de colisión funcionan (no borra archivos existentes accidentalmente).
* [ ] El pack generado es legible y útil para un agente de IA.

## Open Risks
* **Verbosity:** Que los templates se vuelvan demasiado densos y desincentiven su uso.
* **IO en Drive:** Latencia o errores de permisos al escribir desde Colab hacia Google Drive.

## Linked ADRs
* `ADR-000-tool-scope.md` (En proceso)

---

### ¿Cómo guardar esto en tu Colab?

Puedes usar esta celda para persistirlo de una vez en tu Drive:

```bash
%%writefile docs/plans/SPRINT-PACK-KIT-ANCHOR.md
# (Pega aquí el contenido anterior)
```

**Siguiente paso lógico:** Ahora que tenemos el Ancla, ¿quieres que redactemos el **`ADR-000`** para formalizar por qué elegimos Bash y esta estructura, o pasamos directo a crear el primer **Template** físico?