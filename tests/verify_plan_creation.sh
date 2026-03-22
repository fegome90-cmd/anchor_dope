#!/usr/bin/env bash

SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../scripts" && pwd)"

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
    echo -e "${YELLOW}Ejecutando pruebas de creación de planes...${NC}"

    local pass=0
    local fail=0
    local tmp_dir
    tmp_dir=$(mktemp -d)
    trap 'rm -rf "$tmp_dir"' EXIT

    local original_dir="$PWD"
    cd "$tmp_dir" || exit 1

    # Test 1: Crear plan válido en _ctx/plans/
    if run_test "Crear plan válido" 0 bash "$SCRIPTS_DIR/new_sprint_pack.sh" "test-plan-01"; then
        if [ -d "_ctx/plans/test-plan-01/_ctx" ] && [ -f "_ctx/plans/test-plan-01/_ctx/ANCHOR.md" ]; then
            pass=$((pass + 1))
        else
            echo -e "${RED}FAIL:${NC} Plan no creado en _ctx/plans/test-plan-01/"
            fail=$((fail + 1))
        fi
    else
        fail=$((fail + 1))
    fi

    # Test 2: active_plan.json se genera/actualiza
    if [ -f "_ctx/plans/active_plan.json" ] && grep -q "test-plan-01" "_ctx/plans/active_plan.json"; then
        echo -e "${GREEN}PASS:${NC} active_plan.json actualizado"
        pass=$((pass + 1))
    else
        echo -e "${RED}FAIL:${NC} active_plan.json no se actualizó"
        fail=$((fail + 1))
    fi

    # Test 3: Colisión en _ctx/plans/
    if run_test "Colisión de plan" 1 bash "$SCRIPTS_DIR/new_sprint_pack.sh" "test-plan-01"; then
        pass=$((pass + 1))
    else
        fail=$((fail + 1))
    fi

    # Test 4: Slug inválido
    if run_test "Slug inválido" 1 bash "$SCRIPTS_DIR/new_sprint_pack.sh" "Invalid-Slug"; then
        pass=$((pass + 1))
    else
        fail=$((fail + 1))
    fi

    # Test 5: Sin argumentos
    if run_test "Sin argumentos" 1 bash "$SCRIPTS_DIR/new_sprint_pack.sh"; then
        pass=$((pass + 1))
    else
        fail=$((fail + 1))
    fi

    # Test 6: Templates copiados con slug reemplazado
    cd "$original_dir" || exit 1
    cd "$tmp_dir" || exit 1
    bash "$SCRIPTS_DIR/new_sprint_pack.sh" "slug-check" >/dev/null 2>&1
    if [ -f "_ctx/plans/slug-check/_ctx/ANCHOR.md" ] && grep -q "slug-check" "_ctx/plans/slug-check/_ctx/ANCHOR.md" && ! grep -q "{{SLUG}}" "_ctx/plans/slug-check/_ctx/ANCHOR.md"; then
        echo -e "${GREEN}PASS:${NC} Slug reemplazado en templates"
        pass=$((pass + 1))
    else
        echo -e "${RED}FAIL:${NC} Slug no reemplazado correctamente"
        fail=$((fail + 1))
    fi

    # Test 7: SKILL.md copiado
    if [ -f "_ctx/plans/slug-check/SKILL.md" ]; then
        echo -e "${GREEN}PASS:${NC} SKILL.md copiado"
        pass=$((pass + 1))
    else
        echo -e "${RED}FAIL:${NC} SKILL.md no copiado"
        fail=$((fail + 1))
    fi

    cd "$original_dir" || exit 1

    echo -e "\n------------------------------------------------"
    echo -e "${GREEN}PASS: $pass${NC} | ${RED}FAIL: $fail${NC}"
    if [ "$fail" -gt 0 ]; then
        echo -e "${RED}❌ Algunos tests fallaron.${NC}"
        exit 1
    else
        echo -e "${GREEN}✅ Todos los tests de creación de planes pasaron.${NC}"
        exit 0
    fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
