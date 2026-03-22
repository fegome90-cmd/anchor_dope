#!/usr/bin/env bash

# shellcheck disable=SC1091
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/shared/utils.sh"

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

function usage() {
    cat <<EOM

Crea un nuevo Sprint Pack con templates renderizados.

usage: $(basename "$0") <slug>

arguments:
    <slug>           Identificador del sprint (minúsculas, números, guiones)

options:
    -h|--help        Muestra esta ayuda

examples:
    $(basename "$0") sprint-01
    $(basename "$0") mi-feature-alpha

EOM
    exit 1
}

function main() {
    if [ $# -eq 0 ]; then
        echo -e "${RED}ERROR: Se requiere un SLUG como argumento.${NC}" >&2
        usage
    fi

    case "$1" in
    -h | --help)
        usage
        ;;
    esac

    local slug="$1"
    validate_slug "$slug" || exit 1

    local target_dir="./$slug"
    if [ -e "$target_dir" ]; then
        echo -e "${RED}💥 ERROR: El destino '$target_dir' ya existe.${NC}" >&2
        exit 1
    fi

    echo -e "${YELLOW}Creando Sprint Pack en '$target_dir'...${NC}"
    mkdir -p "$target_dir"

    local templates_source="$SCRIPT_DIR/../templates/sprint_base"

    if [ -d "$templates_source" ]; then
        while IFS= read -r tmpl; do
            [ -e "$tmpl" ] || continue
            local rel_path="${tmpl#"$templates_source"/}"
            local dest_path="${rel_path%.tmpl}"
            local dest_dir
            dest_dir=$(dirname "$target_dir/$dest_path")
            mkdir -p "$dest_dir"
            sed "s/{{SLUG}}/$slug/g" "$tmpl" > "$target_dir/$dest_path"
        done < <(find "$templates_source" -name "*.tmpl" -type f)
        echo -e "${GREEN}📦 Templates inyectados correctamente.${NC}"
    else
        echo -e "${YELLOW}⚠️  Aviso: No se encontró carpeta de templates en $templates_source.${NC}"
    fi

    echo -e "${GREEN}✅ Éxito: Sprint Pack '$slug' inicializado.${NC}"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
    exit 0
fi
