#!/usr/bin/env bash

SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../scripts" && pwd)"

function main() {
    echo "Ejecutando pruebas de validación..."

    local pass=0
    local fail=0
    local tmp_dir
    tmp_dir=$(mktemp -d)
    trap 'rm -rf "$tmp_dir"' EXIT

    local original_dir="$PWD"
    cd "$tmp_dir" || exit 1

    # Test 1: Slug válido
    if bash "$SCRIPTS_DIR/new_sprint_pack.sh" "slug-valido" >/dev/null 2>&1; then
        echo "PASS: Slug válido aceptado."
        pass=$((pass + 1))
        rm -rf "slug-valido"
    else
        echo "FAIL: Slug válido rechazado incorrectamente."
        fail=$((fail + 1))
    fi

    # Test 2: Slug inválido (mayúsculas)
    if bash "$SCRIPTS_DIR/new_sprint_pack.sh" "SLUG_INVALIDO" >/dev/null 2>&1; then
        echo "FAIL: Debería haber rechazado slug con mayúsculas."
        fail=$((fail + 1))
    else
        echo "PASS: Slug con mayúsculas rechazado."
        pass=$((pass + 1))
    fi

    # Test 3: Slug con doble guion
    if bash "$SCRIPTS_DIR/new_sprint_pack.sh" "a--b" >/dev/null 2>&1; then
        echo "FAIL: Debería haber rechazado slug con doble guion."
        fail=$((fail + 1))
    else
        echo "PASS: Slug con doble guion rechazado."
        pass=$((pass + 1))
    fi

    # Test 4: Slug terminando en guion
    if bash "$SCRIPTS_DIR/new_sprint_pack.sh" "sprint-" >/dev/null 2>&1; then
        echo "FAIL: Debería haber rechazado slug terminando en guion."
        fail=$((fail + 1))
    else
        echo "PASS: Slug terminando en guion rechazado."
        pass=$((pass + 1))
    fi

    cd "$original_dir" || exit 1

    echo -e "\n------------------------------------------------"
    echo "PASS: $pass | FAIL: $fail"
    if [ "$fail" -gt 0 ]; then
        echo "❌ Algunos tests de validación fallaron."
        exit 1
    else
        echo "✅ Todos los tests de validación pasaron."
        exit 0
    fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
    exit 0
fi
