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
    echo -e "${YELLOW}Ejecutando pruebas de creación y colisión...${NC}"

    local pass=0
    local fail=0
    local tmp_dir
    tmp_dir=$(mktemp -d)
    trap 'rm -rf "$tmp_dir"' EXIT

    local original_dir="$PWD"
    cd "$tmp_dir" || exit 1

    # Test 1: Crear sprint pack válido
    if run_test "Crear sprint pack válido" 0 bash "$SCRIPTS_DIR/new_sprint_pack.sh" "mi-sprint-01"; then
        if [ -d "mi-sprint-01" ]; then
            pass=$((pass + 1))
        else
            echo -e "${RED}FAIL:${NC} Directorio no creado."
            fail=$((fail + 1))
        fi
        rm -rf "mi-sprint-01"
    else
        fail=$((fail + 1))
    fi

    # Test 2: Colisión de directorio
    mkdir -p "sprint-colision"
    if run_test "Colisión de directorio" 1 bash "$SCRIPTS_DIR/new_sprint_pack.sh" "sprint-colision"; then
        pass=$((pass + 1))
    else
        fail=$((fail + 1))
    fi
    rm -rf "sprint-colision"

    # Test 3: Slug inválido con mayúsculas
    if run_test "Slug inválido con mayúsculas" 1 bash "$SCRIPTS_DIR/new_sprint_pack.sh" "Sprint-Invalido"; then
        pass=$((pass + 1))
    else
        fail=$((fail + 1))
    fi

    # Test 4: Slug inválido con guion al inicio
    if run_test "Slug inválido con guion al inicio" 1 bash "$SCRIPTS_DIR/new_sprint_pack.sh" "-sprint"; then
        pass=$((pass + 1))
    else
        fail=$((fail + 1))
    fi

    # Test 5: Slug vacío
    if run_test "Slug vacío" 1 bash "$SCRIPTS_DIR/new_sprint_pack.sh" ""; then
        pass=$((pass + 1))
    else
        fail=$((fail + 1))
    fi

    # Test 6: Sin argumentos
    if run_test "Sin argumentos" 1 bash "$SCRIPTS_DIR/new_sprint_pack.sh"; then
        pass=$((pass + 1))
    else
        fail=$((fail + 1))
    fi

    # Test 7: -h flag → usage
    if run_test "-h → exit 1 (usage)" 1 bash "$SCRIPTS_DIR/new_sprint_pack.sh" -h; then
        pass=$((pass + 1))
    else
        fail=$((fail + 1))
    fi

    # Test 8: --help flag → usage
    if run_test "--help → exit 1 (usage)" 1 bash "$SCRIPTS_DIR/new_sprint_pack.sh" --help; then
        pass=$((pass + 1))
    else
        fail=$((fail + 1))
    fi

    # Test 9: Templates se copian (sin extensión .tmpl)
    if run_test "Templates copiados" 0 bash "$SCRIPTS_DIR/new_sprint_pack.sh" "test-templates"; then
        if [ -f "test-templates/_ctx/ANCHOR.md" ] && [ -f "test-templates/SKILL.md" ] && [ -f "test-templates/_ctx/AGENTS.md" ] && [ -f "test-templates/_ctx/PRIME.md" ]; then
            pass=$((pass + 1))
        else
            echo -e "${RED}FAIL:${NC} Templates no copiados correctamente."
            fail=$((fail + 1))
        fi
        rm -rf "test-templates"
    else
        fail=$((fail + 1))
    fi

    # Test 10: SLUG se reemplaza en templates
    if run_test "SLUG reemplazado en templates" 0 bash "$SCRIPTS_DIR/new_sprint_pack.sh" "my-slug-test"; then
        if grep -q "my-slug-test" "my-slug-test/_ctx/ANCHOR.md" && ! grep -q "{{SLUG}}" "my-slug-test/_ctx/ANCHOR.md"; then
            pass=$((pass + 1))
        else
            echo -e "${RED}FAIL:${NC} SLUG no se reemplazó en templates."
            fail=$((fail + 1))
        fi
        rm -rf "my-slug-test"
    else
        fail=$((fail + 1))
    fi

    cd "$original_dir" || exit 1

    echo -e "\n------------------------------------------------"
    echo -e "${GREEN}PASS: $pass${NC} | ${RED}FAIL: $fail${NC}"
    if [ "$fail" -gt 0 ]; then
        echo -e "${RED}❌ Algunos tests fallaron.${NC}"
        exit 1
    else
        echo -e "${GREEN}✅ Todos los tests de creación pasaron.${NC}"
        exit 0
    fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
