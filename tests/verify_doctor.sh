#!/usr/bin/env bash

DOCTOR_SCRIPT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../scripts" && pwd)/doctor.sh"

function run_doctor_test() {
    local name="$1"
    local expected_exit="$2"
    shift 2

    echo -e "\n   [TEST] $name"

    local tmp_dir
    tmp_dir=$(mktemp -d)

    if "$@" >/dev/null 2>&1; then
        local actual_exit=0
    else
        local actual_exit=1
    fi

    rm -rf "$tmp_dir"

    if [ "$actual_exit" -eq "$expected_exit" ]; then
        echo "   PASS: $name"
        return 0
    else
        echo "   FAIL: $name (esperado exit=$expected_exit, obtuvo exit=$actual_exit)"
        return 1
    fi
}

function make_healthy_pack() {
    local dir="$1"
    mkdir -p "$dir"
    touch "$dir/ANCHOR.md"
    touch "$dir/AGENTS.md"
    touch "$dir/PRIME.md"
}

function main() {
    echo "Ejecutando pruebas de doctor.sh..."

    local pass=0
    local fail=0
    local tmp_dir
    tmp_dir=$(mktemp -d)
    trap 'rm -rf "$tmp_dir"' EXIT

    # Test 1: Sin argumentos
    if run_doctor_test "Sin argumentos → exit 1" 1 bash "$DOCTOR_SCRIPT"; then
        pass=$((pass + 1))
    else
        fail=$((fail + 1))
    fi

    # Test 2: -h flag
    if run_doctor_test "-h → exit 1 (usage)" 1 bash "$DOCTOR_SCRIPT" -h; then
        pass=$((pass + 1))
    else
        fail=$((fail + 1))
    fi

    # Test 3: --help flag
    if run_doctor_test "--help → exit 1 (usage)" 1 bash "$DOCTOR_SCRIPT" --help; then
        pass=$((pass + 1))
    else
        fail=$((fail + 1))
    fi

    # Test 4: Directorio inexistente
    if run_doctor_test "Directorio inexistente → exit 1" 1 bash "$DOCTOR_SCRIPT" "$tmp_dir/no-existe"; then
        pass=$((pass + 1))
    else
        fail=$((fail + 1))
    fi

    # Test 5: Directorio con trailing slash
    local healthy_dir="$tmp_dir/healthy"
    make_healthy_pack "$healthy_dir"
    if run_doctor_test "Directorio con trailing slash" 0 bash "$DOCTOR_SCRIPT" "$healthy_dir/"; then
        pass=$((pass + 1))
    else
        fail=$((fail + 1))
    fi

    # Test 6: Pack sano (4 archivos)
    local healthy2="$tmp_dir/healthy2"
    make_healthy_pack "$healthy2"
    if run_doctor_test "Pack sano → exit 0" 0 bash "$DOCTOR_SCRIPT" "$healthy2"; then
        pass=$((pass + 1))
    else
        fail=$((fail + 1))
    fi

    # Test 7: Pack corrupto (falta 1 archivo)
    local corrupt1="$tmp_dir/corrupt1"
    mkdir -p "$corrupt1"
    touch "$corrupt1/ANCHOR.md"
    touch "$corrupt1/AGENTS.md"
    if run_doctor_test "Pack corrupto (falta PRIME.md) → exit 1" 1 bash "$DOCTOR_SCRIPT" "$corrupt1"; then
        pass=$((pass + 1))
    else
        fail=$((fail + 1))
    fi

    # Test 8: Pack corrupto (faltan todos)
    local corrupt2="$tmp_dir/corrupt2"
    mkdir -p "$corrupt2"
    if run_doctor_test "Pack corrupto (vacío) → exit 1" 1 bash "$DOCTOR_SCRIPT" "$corrupt2"; then
        pass=$((pass + 1))
    else
        fail=$((fail + 1))
    fi

    echo -e "\n------------------------------------------------"
    echo "PASS: $pass | FAIL: $fail"
    if [ "$fail" -gt 0 ]; then
        echo "❌ Algunos tests de doctor fallaron."
        exit 1
    else
        echo "✅ Todos los tests de doctor pasaron."
        exit 0
    fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
