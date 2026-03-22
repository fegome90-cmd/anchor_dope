#!/usr/bin/env bash

SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../scripts" && pwd)"

function main() {
    echo "Ejecutando integración: create → doctor..."

    local tmp_dir
    tmp_dir=$(mktemp -d)
    trap 'rm -rf "$tmp_dir"' EXIT

    local original_dir="$PWD"
    cd "$tmp_dir" || exit 1

    if ! bash "$SCRIPTS_DIR/new_sprint_pack.sh" "integration-test" >/dev/null 2>&1; then
        echo "FAIL: new_sprint_pack.sh falló al crear pack."
        cd "$original_dir" || exit 1
        exit 1
    fi

    if ! bash "$SCRIPTS_DIR/doctor.sh" "integration-test" >/dev/null 2>&1; then
        echo "FAIL: doctor.sh marcó pack creado como corrupto."
        cd "$original_dir" || exit 1
        exit 1
    fi

    cd "$original_dir" || exit 1
    echo "PASS: Integración create → doctor exitosa."
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
    exit 0
fi
