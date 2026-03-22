# Runbook — Sprint Pack Kit

## Overview

Sprint Pack Kit is a CLI tool that generates sprint pack directories from a slug. It runs locally (no server), so "deployment" means ensuring the scripts work correctly in the target environment.

## Health Checks

### Verify Tool Integrity

```bash
# Check that a sprint pack can be created and validated
./scripts/new_sprint_pack.sh "health-check-test"
./scripts/doctor.sh "health-check-test"
rm -rf "health-check-test"
```

### Run Full Test Suite

```bash
make test
```

Expected: All tests pass (exit code 0).

## Common Issues and Fixes

### Issue: "validate_slug: command not found"

**Symptom**: `new_sprint_pack.sh` fails with missing function.

**Cause**: `scripts/shared/utils.sh` not found or not sourced.

**Fix**:
```bash
# Verify file exists
ls -la scripts/shared/utils.sh

# If missing, restore from git
git checkout scripts/shared/utils.sh
```

### Issue: ShellCheck errors on scripts

**Symptom**: `make lint` fails with ShellCheck warnings.

**Fix**:
```bash
# See specific errors
shellcheck scripts/*.sh

# Common fixes:
# - SC1091: Add # shellcheck disable=SC1091 for sourced files
# - SC2086: Quote variables "$var" instead of $var
```

### Issue: Mypy strict errors

**Symptom**: `make lint` fails with type errors.

**Fix**:
```bash
# See specific errors
uv run mypy src/

# Ensure all functions have type hints
# Ensure return types are explicit (not Any)
```

### Issue: Slug validation inconsistency

**Symptom**: Python validates slug but Bash rejects it (or vice versa).

**Cause**: Regex mismatch between `src/utils.py` and `scripts/shared/utils.sh`.

**Fix**:
1. Check `SLUG_PATTERN` in `src/utils.py`
2. Check regex in `scripts/shared/utils.sh`
3. Both must match: `^[a-z0-9]+(-[a-z0-9]+)*$`
4. Run tests: `make test`

### Issue: Template placeholders not replaced

**Symptom**: Generated sprint pack contains literal `{{SLUG}}`.

**Cause**: `sed` command failed or template file corrupted.

**Fix**:
```bash
# Check template files
ls templates/sprint_base/**/*.tmpl

# Verify sed is available
which sed

# Test replacement manually
echo "{{SLUG}}" | sed "s/{{SLUG}}/test-slug/g"
```

## Rollback Procedures

### Revert Sprint Pack Creation

```bash
# Simply delete the generated directory
rm -rf <slug-name>
```

### Revert to Previous Git State

```bash
# Undo uncommitted changes
git checkout -- .

# Revert to specific commit
git revert <commit-hash>
```

## Monitoring

Since this is a CLI tool (no server), monitoring means:

1. **CI Pipeline**: Ensure `make test` passes on every commit
2. **Dependency Updates**: Periodically run `uv sync` and check for updates
3. **ShellCheck Updates**: Keep ShellCheck current for new rules

## Alerting

No external alerting configured. Manual verification:

```bash
# Pre-commit check
make all

# Periodic health check
make test && echo "OK" || echo "FAILED"
```
