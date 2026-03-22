#!/usr/bin/env bash

DOCTOR_SCRIPT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../scripts" && pwd)/doctor.sh"
SKELETON_SCRIPT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../scripts" && pwd)/new_sprint_pack.sh"

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

function run_test() {
    local name="$1"
    local expected_exit="$2"
    shift 2

    echo -e "\n${YELLOW}[TEST] $name${NC}"

    if "$@" >/dev/null 2>&1; then
        local actual_exit=0
    else
        local actual_exit=1
    fi

    if [ "$actual_exit" -eq "$expected_exit" ]; then
        echo -e "${GREEN}PASS:${NC} $name"
        return 0
    else
        echo -e "${RED}FAIL:${NC} $name (esperado exit=$expected_exit, obtuvo exit=$actual_exit)"
        return 1
    fi
}

function main() {
    echo -e "${YELLOW}Ejecutando pruebas de doctor con planes...${NC}"

    local pass=0
    local fail=0
    local tmp_dir
    tmp_dir=$(mktemp -d)
    trap 'rm -rf "$tmp_dir"' EXIT

    local original_dir="$PWD"
    cd "$tmp_dir" || exit 1

    bash "$SKELETON_SCRIPT" "doctor-test-plan" >/dev/null 2>&1

    # Test 1: Doctor con --active (plan válido)
    if run_test "Doctor --active con plan válido" 0 bash "$DOCTOR_SCRIPT" --active; then
        pass=$((pass + 1))
    else
        fail=$((fail + 1))
    fi

    # Test 2: Doctor con plan-id explícito
    if run_test "Doctor con plan-id" 0 bash "$DOCTOR_SCRIPT" "doctor-test-plan"; then
        pass=$((pass + 1))
    else
        fail=$((fail + 1))
    fi

    # Test 3: Doctor con plan-id inexistente
    if run_test "Doctor con plan inexistente" 1 bash "$DOCTOR_SCRIPT" "no-existe-plan"; then
        pass=$((pass + 1))
    else
        fail=$((fail + 1))
    fi

    # Test 4: Doctor sin argumentos
    if run_test "Doctor sin argumentos" 1 bash "$DOCTOR_SCRIPT"; then
        pass=$((pass + 1))
    else
        fail=$((fail + 1))
    fi

    # Test 5: Doctor con --active sin active_plan.json
    rm -f "_ctx/plans/active_plan.json"
    if run_test "Doctor --active sin active_plan.json" 1 bash "$DOCTOR_SCRIPT" --active; then
        pass=$((pass + 1))
    else
        fail=$((fail + 1))
    fi

    # Test 6: Doctor con --active y active_plan null
    mkdir -p "_ctx/plans"
    cat > "_ctx/plans/active_plan.json" <<'EOF'
{"active_plan": null, "plan_path": null}
EOF
    if run_test "Doctor --active con plan null" 1 bash "$DOCTOR_SCRIPT" --active; then
        pass=$((pass + 1))
    else
        fail=$((fail + 1))
    fi

    # Test 7: Doctor con plan corrupto (falta ANCHOR.md)
    mkdir -p "_ctx/plans/corrupt-plan/_ctx"
    touch "_ctx/plans/corrupt-plan/_ctx/AGENTS.md"
    touch "_ctx/plans/corrupt-plan/_ctx/PRIME.md"
    if run_test "Doctor con plan corrupto" 1 bash "$DOCTOR_SCRIPT" "corrupt-plan"; then
        pass=$((pass + 1))
    else
        fail=$((fail + 1))
    fi

    # Test 8: Doctor con directorio directo (compatibilidad)
    mkdir -p "direct-pack/_ctx"
    touch "direct-pack/_ctx/ANCHOR.md"
    touch "direct-pack/_ctx/AGENTS.md"
    touch "direct-pack/_ctx/PRIME.md"
    if run_test "Doctor con directorio directo" 0 bash "$DOCTOR_SCRIPT" "direct-pack"; then
        pass=$((pass + 1))
    else
        fail=$((fail + 1))
    fi

    # Test 9: Doctor con plan inválido lista planes disponibles
    bash "$SKELETON_SCRIPT" "list-test-plan" >/dev/null 2>&1
    echo -e "\n${YELLOW}[TEST] Doctor con plan inválido lista planes${NC}"
    local listing_output
    listing_output=$(bash "$DOCTOR_SCRIPT" "invalid-plan" 2>&1)
    if echo "$listing_output" | grep -q "list-test-plan"; then
        echo -e "${GREEN}PASS:${NC} Doctor con plan inválido lista planes"
        pass=$((pass + 1))
    else
        echo -e "${RED}FAIL:${NC} Listing no contiene 'list-test-plan'"
        fail=$((fail + 1))
    fi

    # Test 10: Doctor --active con JSON malformado
    mkdir -p "_ctx/plans"
    echo "not json at all" > "_ctx/plans/active_plan.json"
    if run_test "Doctor --active con JSON malformado" 1 bash "$DOCTOR_SCRIPT" --active; then
        pass=$((pass + 1))
    else
        fail=$((fail + 1))
    fi

    cd "$original_dir" || exit 1

    echo -e "\n------------------------------------------------"
    echo -e "${GREEN}PASS: $pass${NC} | ${RED}FAIL: $fail${NC}"
    if [ "$fail" -gt 0 ]; then
        echo -e "${RED}❌ Algunos tests de doctor con planes fallaron.${NC}"
        exit 1
    else
        echo -e "${GREEN}✅ Todos los tests de doctor con planes pasaron.${NC}"
        exit 0
    fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
