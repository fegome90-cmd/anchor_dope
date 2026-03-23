#!/usr/bin/env bash

DEPENDENCIES=(shellcheck find)

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

function exit_on_missing_tools() {
    for cmd in "$@"; do
        if command -v "$cmd" &>/dev/null; then
            continue
        fi
        printf "Error: Required tool '%s' is not installed or not in PATH\n" "$cmd"
        exit 1
    done
}

function usage() {
    cat <<EOM

Ejecuta ShellCheck sobre todos los scripts bash del proyecto.

usage: $(basename "$0") [directorio]

arguments:
    [directorio]     Directorio a escanear (default: scripts)

options:
    -h|--help        Muestra esta ayuda

dependencies: ${DEPENDENCIES[@]}

EOM
    exit 1
}

function main() {
    case "${1:-}" in
    -h | --help)
        usage
        ;;
    esac

    exit_on_missing_tools "${DEPENDENCIES[@]}"

    local scan_dir="${1:-scripts}"

    echo -e "${YELLOW}🔍 Iniciando ShellCheck (Excluyendo SC1091) en $scan_dir/...${NC}"

    local errors=0
    while IFS= read -r file; do
        if shellcheck -x -e SC1091 "$file"; then
            echo -e "   ${GREEN}[OK]${NC} $file"
        else
            echo -e "   ${RED}[FAIL]${NC} $file"
            errors=$((errors + 1))
        fi
    done < <(find "$scan_dir" -type f -name "*.sh" -not -path "*/.*")

    if [ "$errors" -gt 0 ]; then
        echo -e "\n${RED}❌ Se encontraron $errors problemas.${NC}"
        exit 1
    else
        echo -e "\n${GREEN}✅ Código limpio y validado.${NC}"
        exit 0
    fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
