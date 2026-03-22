#!/usr/bin/env bash

function main() {
    shopt -s nullglob
    echo "🚀 Iniciando Suite de Pruebas Completa..."
    for test_script in tests/verify_*.sh; do
        echo "------------------------------------------------"
        if ! bash "$test_script"; then
            echo "❌ Test falló: $test_script"
            shopt -u nullglob
            exit 1
        fi
    done
    shopt -u nullglob
    echo "------------------------------------------------"
    echo "🌟 TODAS LAS SUITES PASARON CON ÉXITO 🌟"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
    exit 0
fi
