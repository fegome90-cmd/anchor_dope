#!/usr/bin/env bash

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
