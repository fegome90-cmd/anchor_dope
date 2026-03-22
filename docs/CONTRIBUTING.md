# Contributing to Sprint Pack Kit

## Development Environment Setup

### Prerequisites

- **Python 3.12+** — Runtime requirement
- **uv** — Python package manager (replaces pip)
- **ShellCheck** — Bash linter (`brew install shellcheck` on macOS)
- **Git** — Version control

### Install Dependencies

```bash
# Install dev dependencies via uv
uv sync
```

### Verify Setup

```bash
# Run all checks
make all

# Or individually
make format   # Format Python code
make lint     # Run linters
make test     # Run tests
```

<!-- AUTO-GENERATED: scripts-table -->
## Available Scripts

| Command | Description |
|---------|-------------|
| `make all` | Run format + lint + test (full CI pipeline) |
| `make format` | Auto-fix and format Python code with Ruff |
| `make lint` | Run ShellCheck (Bash) + Mypy (strict typing) + Ruff (Python lint) |
| `make test` | Run all tests (Bash + Python) |
| `make shell-test` | Run only Bash tests (`tests/run_all.sh`) |
| `make python-test` | Run only Python tests (pytest) |
| `./scripts/new_sprint_pack.sh <slug>` | Create a new sprint pack from slug |
| `./scripts/doctor.sh <slug>` | Verify integrity of a sprint pack |
| `./scripts/lint.sh` | Run linting manually (alternative to `make lint`) |
<!-- END-AUTO-GENERATED -->

## Testing

### Running Tests

```bash
# Full suite
make test

# Bash tests only
make shell-test
# or directly:
bash tests/run_all.sh

# Python tests only
make python-test
# or directly:
uv run pytest tests/test/python/
```

### Writing Tests

**Bash tests** (`tests/verify_*.sh`):
- Prefix: `verify_*.sh`
- Must be executable: `chmod +x tests/verify_*.sh`
- Use `tests/run_all.sh` as runner
- Follow existing patterns in `verify_creation.sh`

**Python tests** (`tests/test/python/test_*.py`):
- Prefix: `test_*.py`
- Classes: `Test*`
- Methods: `test_*`
- Use `@pytest.mark.parametrize` for data-driven tests
- Markers: `unit`, `integration`

## Code Style

### Python

- **Formatter**: Ruff (`ruff format`)
- **Linter**: Ruff (`ruff check`)
- **Type checker**: Mypy (strict mode)
- **Line length**: 100 characters
- **Target**: Python 3.12+

Config in `pyproject.toml`:
```toml
[tool.ruff]
line-length = 100
target-version = "py312"

[tool.ruff.lint]
select = ["E", "F", "I", "W", "C90", "UP"]

[tool.mypy]
strict = true
disallow_untyped_defs = true
```

### Bash

- **Linter**: ShellCheck
- **Pattern**: `main()` with guard clause
- **No `set -e`**: Explicit error handling only
- **Sourceability**: Scripts must be sourceable without side effects

## PR Submission Checklist

- [ ] `make format` passes
- [ ] `make lint` passes (ShellCheck + Mypy + Ruff)
- [ ] `make test` passes (Bash + Python)
- [ ] New features have tests written first (TDD)
- [ ] Slug regex unchanged or tests updated
- [ ] Templates updated with corresponding tests
- [ ] `scripts/shared/utils.sh` not deleted
