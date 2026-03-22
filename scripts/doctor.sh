#!/usr/bin/env bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

if [[ -n "${NO_COLOR:-}" ]] || [[ "${TERM:-}" == "dumb" ]]; then
    RED=""
    GREEN=""
    YELLOW=""
    NC=""
fi

REQUIRED_FILES=("_ctx/ANCHOR.md" "_ctx/AGENTS.md" "_ctx/PRIME.md")
PLANS_DIR="_ctx/plans"
ACTIVE_PLAN_FILE="$PLANS_DIR/active_plan.json"

function usage() {
    cat <<EOM

Verifica la integridad de un Sprint Pack.

usage: $(basename "$0") [opción | directorio]

arguments:
    <plan-id>        ID del plan a auditar (busca en _ctx/plans/<plan-id>/)
    <directorio>     Ruta directa al Sprint Pack

options:
    --active         Audita el plan activo (lee active_plan.json)
    -h|--help        Muestra esta ayuda

examples:
    $(basename "$0") --active
    $(basename "$0") sprint-01
    $(basename "$0") ./mi-pack

EOM
    exit 1
}

function resolve_plan_dir() {
    local input="$1"

    if [ "$input" = "--active" ]; then
        if [ ! -f "$ACTIVE_PLAN_FILE" ]; then
            echo -e "${RED}ERROR: No existe $ACTIVE_PLAN_FILE.${NC}" >&2
            echo -e "${YELLOW}Cree un plan primero con new_sprint_pack.sh <slug>.${NC}" >&2
            exit 1
        fi
        local plan_path
        plan_path=$(grep '"plan_path"' "$ACTIVE_PLAN_FILE" | sed 's/.*"plan_path": *"//;s/".*//')
        if [ "$plan_path" = "null" ] || [ -z "$plan_path" ]; then
            echo -e "${RED}ERROR: No hay plan activo en active_plan.json.${NC}" >&2
            echo -e "${YELLOW}Cree un plan con new_sprint_pack.sh <slug>.${NC}" >&2
            exit 1
        fi
        echo "$plan_path"
        return 0
    fi

    if [ -d "_ctx/plans/$input" ]; then
        echo "_ctx/plans/$input"
        return 0
    fi

    if [ -d "$input" ]; then
        echo "$input"
        return 0
    fi

    echo -e "${RED}ERROR: '$input' no es un plan ni un directorio válido.${NC}" >&2
    echo -e "${YELLOW}Planes disponibles:${NC}" >&2
    if [ -d "$PLANS_DIR" ]; then
        local found=0
        for d in "$PLANS_DIR"/*/; do
            [ -d "$d" ] || continue
            echo -e "   $(basename "$d")"
            found=1
        done
        [ "$found" -eq 0 ] && echo -e "   (ninguno)"
    fi
    exit 1
}

function main() {
    if [ $# -eq 0 ]; then
        echo -e "${RED}ERROR: Se requiere un argumento.${NC}" >&2
        usage
    fi

    case "$1" in
    -h | --help)
        usage
        ;;
    esac

    local target_dir
    target_dir=$(resolve_plan_dir "$1")
    target_dir="${target_dir%/}"

    if [ ! -d "$target_dir" ]; then
        echo -e "${RED}💥 ERROR: El directorio '$target_dir' no existe.${NC}" >&2
        exit 1
    fi

    echo -e "${YELLOW}🩺 Auditando: $target_dir${NC}"

    local corrupt=0

    for file in "${REQUIRED_FILES[@]}"; do
        if [ -f "$target_dir/$file" ]; then
            echo -e "   ${GREEN}[OK]${NC} $file"
        else
            echo -e "   ${RED}[FALTA]${NC} $file"
            corrupt=1
        fi
    done

    if [ "$corrupt" -eq 1 ]; then
        echo -e "${RED}❌ DIAGNÓSTICO: Sprint Pack CORRUPTO.${NC}" >&2
        exit 1
    else
        echo -e "${GREEN}✅ DIAGNÓSTICO: Sprint Pack 100% SANO.${NC}"
        exit 0
    fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
