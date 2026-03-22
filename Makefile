.PHONY: check format lint test shell-test python-test all install uninstall

all: format lint test

format:
	@echo "🎨 Formateando código Python (Ruff)..."
	uv run ruff check --fix src/ tests/test/python/
	uv run ruff format src/ tests/test/python/

lint:
	@echo "🛡️  Ejecutando ShellCheck (Bash)..."
	find scripts tests -name "*.sh" -type f -exec shellcheck -e SC1091 {} +
	@shellcheck -e SC1091 scripts/spk 2>/dev/null && echo "   [OK] scripts/spk" || true
	@echo "🛡️  Ejecutando Mypy (Tipado Estricto Python)..."
	uv run mypy src/ tests/test/python/
	@echo "🛡️  Ejecutando Ruff Linter (Python)..."
	uv run ruff check src/ tests/test/python/

test: shell-test python-test

shell-test:
	@echo "🧪 Ejecutando Pruebas de Bash..."
	bash tests/run_all.sh

python-test:
	@echo "🧪 Ejecutando Pytest (Python)..."
	uv run pytest tests/test/python/

install:
	@echo "📦 Instalando spk en ~/.local/bin..."
	@mkdir -p ~/.local/bin
	@ln -sf "$(CURDIR)/scripts/spk" ~/.local/bin/spk
	@chmod +x "$(CURDIR)/scripts/spk"
	@chmod +x "$(CURDIR)/scripts/new_sprint_pack.sh"
	@chmod +x "$(CURDIR)/scripts/doctor.sh"
	@chmod +x "$(CURDIR)/scripts/lint.sh"
	@echo "✅ Instalado: spk"
	@echo "   Verifica con: spk --help"
	@which spk >/dev/null 2>&1 || echo "⚠️  ~/.local/bin no está en PATH. Añádelo a tu shell."

uninstall:
	@echo "🗑️  Desinstalando spk..."
	@rm -f ~/.local/bin/spk
	@echo "✅ spk eliminado de ~/.local/bin"
