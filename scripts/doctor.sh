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

function usage() {
    cat <<EOM

Verifica la integridad de un Sprint Pack.

usage: $(basename "$0") <directorio>

arguments:
    <directorio>     Ruta al Sprint Pack a auditar

options:
    -h|--help        Muestra esta ayuda

examples:
    $(basename "$0") ./sprint-01
    $(basename "$0") /path/to/sprint

EOM
    exit 1
}

function main() {
    if [ $# -eq 0 ]; then
        echo -e "${RED}ERROR: Se requiere el directorio del Sprint Pack.${NC}" >&2
        usage
    fi

    case "$1" in
    -h | --help)
        usage
        ;;
    esac

    local target_dir="${1%/}"

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
    exit 0
fi
