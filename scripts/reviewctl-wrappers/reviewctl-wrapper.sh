#!/usr/bin/env bash
# reviewctl wrapper for anchor_dope - delegates to branch-review CLI
# Usage: source this file, then use reviewctl_* functions

: "${BRANCH_REVIEW_REPO:=${HOME}/Developer/branch-review}"
: "${BRANCH_REVIEW_API:=http://localhost:3001}"

log_info() { echo "[reviewctl:info] $1" >&2; }
log_warn() { echo "[reviewctl:warn] $1" >&2; }
log_error() { echo "[reviewctl:error] $1" >&2; }

resolve_core_cli_path() {
    if [[ -n "${REVIEWCTL_CORE_CLI_PATH:-}" ]]; then
        printf '%s' "$REVIEWCTL_CORE_CLI_PATH"
        return 0
    fi
    printf '%s/mini-services/reviewctl/src/index.ts' "$BRANCH_REVIEW_REPO"
}

json_escape() {
    local value="$1"
    value=${value//\\/\\\\}
    value=${value//\"/\\\"}
    value=${value//$'\n'/\\n}
    value=${value//$'\r'/\\r}
    value=${value//$'\t'/\\t}
    printf '%s' "$value"
}

build_args_json() {
    local cmd="$1"
    shift
    local json="{"
    local positional=()

    while (($# > 0)); do
        local arg="$1"
        shift
        if [[ "$arg" == --* ]]; then
            local key="${arg#--}"
            if (($# > 0)) && [[ "$1" != --* ]]; then
                local value="$1"
                shift
                json+="\"$(json_escape "$key")\":\"$(json_escape "$value")\","
            else
                json+="\"$(json_escape "$key")\":true,"
            fi
        else
            positional+=("$arg")
        fi
    done

    if ((${#positional[@]} > 0)); then
        if [[ "$cmd" == "explore" && ${#positional[@]} -eq 1 ]]; then
            json+="\"type\":\"$(json_escape "${positional[0]}")\","
        else
            return 2
        fi
    fi

    json="${json%,}}"
    [[ "$json" == "}" ]] && json="{}"
    printf '%s' "$json"
}

execute_local() {
    local cmd="$1"
    shift
    local cli_path
    cli_path="$(resolve_core_cli_path)"

    if [[ ! -f "$cli_path" ]]; then
        log_error "branch-review CLI not found: $cli_path"
        log_error "Set BRANCH_REVIEW_REPO or REVIEWCTL_CORE_CLI_PATH"
        return 1
    fi

    log_info "mode=local-direct command=$cmd"
    bun "$cli_path" "$cmd" "$@"
}

execute_cmd() {
    local cmd="$1"
    shift
    local args_raw=("$@")

    if [[ -n "${__REVIEWCTL_WRAPPER_LOOP:-}" ]]; then
        execute_local "$cmd" "${args_raw[@]}"
        return $?
    fi

    local cli_path
    cli_path="$(resolve_core_cli_path)"
    export __REVIEWCTL_WRAPPER_LOOP=1
    local exit_code=0

    if [[ -z "${REVIEW_API_TOKEN:-}" ]]; then
        log_warn "mode=local-direct reason=missing-review-api-token command=$cmd"
        execute_local "$cmd" "${args_raw[@]}"
        exit_code=$?
        unset __REVIEWCTL_WRAPPER_LOOP
        return $exit_code
    fi

    local args_json
    if ! args_json="$(build_args_json "$cmd" "${args_raw[@]}")"; then
        log_warn "mode=local-direct reason=unsupported-positional-args command=$cmd"
        execute_local "$cmd" "${args_raw[@]}"
        exit_code=$?
        unset __REVIEWCTL_WRAPPER_LOOP
        return $exit_code
    fi

    log_info "mode=api command=$cmd"
    local response
    response=$(curl -sS -w "\n%{http_code}" --connect-timeout 2 \
        -H "X-Review-Token: $REVIEW_API_TOKEN" \
        -H "Content-Type: application/json" \
        -d "{\"command\":\"$(json_escape "$cmd")\",\"args\":$args_json}" \
        "$BRANCH_REVIEW_API/api/review/command" 2>/dev/null || printf '\n000')

    local http_code
    http_code=$(echo "$response" | tail -n 1)
    local body
    body=$(echo "$response" | head -n -1)

    case "$http_code" in
        200) echo "$body"; exit_code=0 ;;
        000)
            log_warn "mode=local-fallback reason=api-unreachable command=$cmd"
            execute_local "$cmd" "${args_raw[@]}"
            exit_code=$?
            ;;
        4*|5*)
            log_error "mode=api command=$cmd http_status=$http_code"
            echo "$body" >&2
            exit_code=1
            ;;
        *)
            log_error "mode=api command=$cmd http_status=$http_code outcome=unexpected"
            echo "$body" >&2
            exit_code=1
            ;;
    esac

    unset __REVIEWCTL_WRAPPER_LOOP
    return $exit_code
}

# Public API
reviewctl_init()    { execute_cmd "init" "--create"; }
reviewctl_plan()    { execute_cmd "plan"; }
reviewctl_run()     { execute_cmd "run"; }
reviewctl_verdict() { execute_cmd "verdict" "--allow-incomplete"; }
reviewctl_status()  { execute_cmd "status"; }
reviewctl_explore() { execute_cmd "explore" "$@"; }

reviewctl_full_workflow() {
    if [[ "${1:-}" == "--reset" ]]; then
        log_warn "Resetting run state..."
        rm -f "_ctx/review_runs/current.json" 2>/dev/null
    fi
    reviewctl_init && reviewctl_plan && reviewctl_run && reviewctl_verdict
}
