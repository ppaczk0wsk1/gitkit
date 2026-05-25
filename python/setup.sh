#!/bin/bash
set -e

: "${BOOTSTRAPS_OWNER:=ppaczk0wsk1}"
REPO_BASE="https://raw.githubusercontent.com/$BOOTSTRAPS_OWNER/gitkit/main"

echo "🐍 Setting up git tooling for Python project"
echo ""

# ===== Load helpers =====
source <(curl -fsSL "$REPO_BASE/common/helpers.sh")

# ===== Git =====
init_git

# ===== .gitconfig =====
echo "📂 Adding config files..."
install_gitconfig "$REPO_BASE"

# ===== .gitignore =====
safe_write .gitignore << 'EOF'
__pycache__/
*.py[cod]
*$py.class
*.egg-info/
dist/
build/
.eggs/
.venv/
venv/
.env
.env.*
!.env.example
.mypy_cache/
.ruff_cache/
.pytest_cache/
htmlcov/
.coverage
*.cover
*.log
.DS_Store
Thumbs.db
.idea/
.vscode/settings.json
EOF

# ===== .pre-commit-config.yaml =====
safe_write .pre-commit-config.yaml << 'EOF'
repos:
  - repo: https://github.com/astral-sh/ruff-pre-commit
    rev: v0.11.13
    hooks:
      - id: ruff
        args: ["--ignore", "E402"]
      - id: ruff-format

  - repo: https://github.com/pre-commit/mirrors-mypy
    rev: v2.1.0
    hooks:
      - id: mypy
        additional_dependencies:
          - sqlalchemy[mypy]
          - types-bleach

  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v5.0.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-json
      - id: check-toml
      - id: check-added-large-files
        args: ['--maxkb=500']
      - id: check-merge-conflict
      - id: detect-private-key
EOF

# ===== Ruff + mypy config =====
if [ ! -f pyproject.toml ]; then
    safe_write pyproject.toml << 'EOF'
[tool.ruff]
target-version = "py310"
line-length = 120

[tool.ruff.lint]
select = ["E", "W", "F", "I", "B", "C4", "UP", "SIM"]
ignore = ["E402", "E501", "B008"]

[tool.ruff.format]
quote-style = "double"
indent-style = "space"

[tool.mypy]
python_version = "3.10"
warn_return_any = true
warn_unused_configs = true
check_untyped_defs = true
ignore_missing_imports = true

[tool.pytest.ini_options]
testpaths = ["tests"]
addopts = "-v --tb=short"
EOF
else
    echo "  ⏭️  pyproject.toml exists — not touching it"
fi

# ===== Pre-commit =====
echo "🪝 Hooks..."
install_precommit
print_done
