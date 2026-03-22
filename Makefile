.PHONY: check format lint test shell-test python-test all

all: format lint test

format:
	@echo "🎨 Formateando código Python (Ruff)..."
	uv run ruff check --fix src/ tests/python/
	uv run ruff format src/ tests/python/

lint:
	@echo "🛡️  Ejecutando ShellCheck (Bash)..."
	find scripts tests -name "*.sh" -type f -exec shellcheck -e SC1091 {} +
	@echo "🛡️  Ejecutando Mypy (Tipado Estricto Python)..."
	uv run mypy src/ tests/python/
	@echo "🛡️  Ejecutando Ruff Linter (Python)..."
	uv run ruff check src/ tests/python/

test: shell-test python-test

shell-test:
	@echo "🧪 Ejecutando Pruebas de Bash..."
	bash tests/run_all.sh

python-test:
	@echo "🧪 Ejecutando Pytest (Python)..."
	uv run pytest tests/python/
