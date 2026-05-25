#!/bin/bash
set -e

: "${BOOTSTRAPS_OWNER:=ppaczk0wsk1}"
REPO_BASE="https://raw.githubusercontent.com/$BOOTSTRAPS_OWNER/gitkit/main"

echo "🐹 Setting up git tooling for Go project"
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
bin/
dist/
*.exe
*.exe~
*.dll
*.so
*.dylib
*.test
*.out
coverage.txt
coverage.html
vendor/
.idea/
.vscode/settings.json
*.swp
*.swo
*~
.DS_Store
Thumbs.db
.env
.env.*
!.env.example
EOF

# ===== .pre-commit-config.yaml =====
safe_write .pre-commit-config.yaml << 'EOF'
repos:
  - repo: https://github.com/dnephin/pre-commit-golang
    rev: v0.5.1
    hooks:
      - id: go-fmt
      - id: go-vet
      - id: go-imports
      - id: go-build

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

# ===== golangci-lint config =====
safe_write .golangci.yml << 'EOF'
run:
  timeout: 5m

linters:
  enable:
    - errcheck
    - gosimple
    - govet
    - ineffassign
    - staticcheck
    - unused
    - gocritic
    - gofmt
    - goimports
    - misspell
    - unconvert
    - unparam

linters-settings:
  gocritic:
    enabled-tags:
      - diagnostic
      - style
      - performance
  misspell:
    locale: US

issues:
  exclude-rules:
    - path: _test\.go
      linters:
        - errcheck
        - unparam
EOF

# ===== Pre-commit =====
echo "🪝 Hooks..."
install_precommit
print_done
