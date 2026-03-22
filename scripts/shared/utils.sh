#!/usr/bin/env bash

# shellcheck disable=SC2034
RED='\033[0;31m'
# shellcheck disable=SC2034
GREEN='\033[0;32m'
# shellcheck disable=SC2034
YELLOW='\033[0;33m'
# shellcheck disable=SC2034
NC='\033[0m'

if [[ -n "${NO_COLOR:-}" ]] || [[ "${TERM:-}" == "dumb" ]]; then
    RED=""
    GREEN=""
    YELLOW=""
    NC=""
fi

validate_slug() {
    local slug="${1:-}"
    if [ -z "$slug" ]; then
        echo "ERROR: El SLUG está vacío." >&2
        return 1
    fi
    if [[ ! "$slug" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
        echo "ERROR: El SLUG '$slug' es inválido." >&2
        echo "Solo se permiten minúsculas, números y guiones medios (-)." >&2
        echo "No puede iniciar/terminar con '-' ni tener guiones consecutivos." >&2
        return 1
    fi
}
