#!/bin/bash
set -e

: "${BOOTSTRAPS_OWNER:=ppaczk0wsk1}"
REPO_BASE="https://raw.githubusercontent.com/$BOOTSTRAPS_OWNER/gitkit/main"

echo "📘 Setting up git tooling for TypeScript project"
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
node_modules/
dist/
build/
.env
.env.*
!.env.example
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*
.DS_Store
Thumbs.db
.idea/
.vscode/settings.json
coverage/
*.tsbuildinfo
EOF

# ===== .pre-commit-config.yaml =====
safe_write .pre-commit-config.yaml << 'EOF'
repos:
  - repo: https://github.com/pre-commit/mirrors-eslint
    rev: v9.27.0
    hooks:
      - id: eslint
        files: \.(ts|tsx)$
        additional_dependencies:
          - eslint
          - typescript
          - typescript-eslint
          - "@eslint/js"

  - repo: https://github.com/pre-commit/mirrors-prettier
    rev: v4.0.0-alpha.8
    hooks:
      - id: prettier
        types_or: [typescript, tsx, json, css, markdown]

  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v5.0.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-json
      - id: check-added-large-files
        args: ['--maxkb=500']
      - id: check-merge-conflict
      - id: detect-private-key
EOF

# ===== Prettier config =====
safe_write .prettierrc << 'EOF'
{
  "semi": true,
  "trailingComma": "all",
  "singleQuote": false,
  "printWidth": 100,
  "tabWidth": 2
}
EOF

safe_write .prettierignore << 'EOF'
dist
node_modules
coverage
EOF

# ===== Pre-commit =====
echo "🪝 Hooks..."
install_precommit
print_done
