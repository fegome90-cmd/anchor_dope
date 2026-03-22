#!/usr/bin/env bash
# shellcheck disable=SC1090

UTILS_FILE="$(cd "$(dirname "${BASH_SOURCE[0]}")/../scripts/shared" && pwd)/utils.sh"

function run_utils_test() {
    local name="$1"
    local expected_exit="$2"
    shift 2

    echo -e "\n   [TEST] $name"

    if (source "$UTILS_FILE" && "$@") >/dev/null 2>&1; then
        local actual_exit=0
    else
        local actual_exit=1
    fi

    if [ "$actual_exit" -eq "$expected_exit" ]; then
        echo "   PASS: $name"
        return 0
    else
        echo "   FAIL: $name (esperado exit=$expected_exit, obtuvo exit=$actual_exit)"
        return 1
    fi
}

function main() {
    echo "Ejecutando pruebas de validate_slug (utils.sh)..."

    local pass=0
    local fail=0

    if run_utils_test "Slug vacío" 1 validate_slug ""; then
        pass=$((pass + 1))
    else
        fail=$((fail + 1))
    fi

    if run_utils_test "Slug válido: sprint-01" 0 validate_slug "sprint-01"; then
        pass=$((pass + 1))
    else
        fail=$((fail + 1))
    fi

    if run_utils_test "Slug doble guion: a--b" 1 validate_slug "a--b"; then
        pass=$((pass + 1))
    else
        fail=$((fail + 1))
    fi

    if run_utils_test "Slug trailing dash: sprint-" 1 validate_slug "sprint-"; then
        pass=$((pass + 1))
    else
        fail=$((fail + 1))
    fi

    if run_utils_test "Slug solo números: 123" 0 validate_slug "123"; then
        pass=$((pass + 1))
    else
        fail=$((fail + 1))
    fi

    if run_utils_test "Slug solo letras: abc" 0 validate_slug "abc"; then
        pass=$((pass + 1))
    else
        fail=$((fail + 1))
    fi

    if run_utils_test "Slug con espacio: a b" 1 validate_slug "a b"; then
        pass=$((pass + 1))
    else
        fail=$((fail + 1))
    fi

    if run_utils_test "Slug 1 char: a" 0 validate_slug "a"; then
        pass=$((pass + 1))
    else
        fail=$((fail + 1))
    fi

    echo -e "\n------------------------------------------------"
    echo "PASS: $pass | FAIL: $fail"
    if [ "$fail" -gt 0 ]; then
        echo "❌ Algunos tests de utils fallaron."
        exit 1
    else
        echo "✅ Todos los tests de utils pasaron."
        exit 0
    fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
