#!/usr/bin/env bash

LINT_SCRIPT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../scripts" && pwd)/lint.sh"

function run_lint_test() {
    local name="$1"
    local expected_exit="$2"
    shift 2

    echo -e "\n   [TEST] $name"

    local tmp_dir
    tmp_dir=$(mktemp -d)
    trap 'rm -rf "$tmp_dir"' EXIT

    if "$@" >/dev/null 2>&1; then
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
    echo "Ejecutando pruebas de paths de lint.sh..."

    local pass=0
    local fail=0
    local tmp_dir
    tmp_dir=$(mktemp -d)
    trap 'rm -rf "$tmp_dir"' EXIT

    # Test 1: -h flag → exit 1
    if run_lint_test "-h → exit 1 (usage)" 1 bash "$LINT_SCRIPT" -h; then
        pass=$((pass + 1))
    else
        fail=$((fail + 1))
    fi

    # Test 2: Directorio con scripts limpios → exit 0
    local clean_dir="$tmp_dir/clean"
    mkdir -p "$clean_dir"
    cat > "$clean_dir/clean.sh" << 'INNER_EOF'
#!/usr/bin/env bash
echo "hello"
INNER_EOF
    if run_lint_test "Scripts limpios → exit 0" 0 bash "$LINT_SCRIPT" "$clean_dir"; then
        pass=$((pass + 1))
    else
        fail=$((fail + 1))
    fi

    # Test 3: Directorio con script con error → exit 1
    local bad_dir="$tmp_dir/bad"
    mkdir -p "$bad_dir"
    cat > "$bad_dir/bad.sh" << 'INNER_EOF'
#!/usr/bin/env bash
for i in $unquoted; do echo $i; done
INNER_EOF
    if run_lint_test "Script con error → exit 1" 1 bash "$LINT_SCRIPT" "$bad_dir"; then
        pass=$((pass + 1))
    else
        fail=$((fail + 1))
    fi

    # Test 4: Directorio vacío (sin .sh) → exit 0
    local empty_dir="$tmp_dir/empty"
    mkdir -p "$empty_dir"
    if run_lint_test "Directorio vacío → exit 0" 0 bash "$LINT_SCRIPT" "$empty_dir"; then
        pass=$((pass + 1))
    else
        fail=$((fail + 1))
    fi

    echo -e "\n------------------------------------------------"
    echo "PASS: $pass | FAIL: $fail"
    if [ "$fail" -gt 0 ]; then
        echo "❌ Algunos tests de lint paths fallaron."
        exit 1
    else
        echo "✅ Todos los tests de lint paths pasaron."
        exit 0
    fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
