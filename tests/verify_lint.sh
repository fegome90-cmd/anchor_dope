#!/usr/bin/env bash

function main() {
    echo "🧪 Ejecutando Suite: Calidad de Código (Linter)..."
    if ! bash scripts/lint.sh; then
        echo "FAIL: Lint falló."
        exit 1
    fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
    exit 0
fi
