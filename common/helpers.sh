#!/bin/bash
# ===== Shared helpers =====

init_git() {
    if [ ! -d .git ]; then
        git init -q
        echo "  ✅ Git initialized"
    else
        echo "  ⏭️  Git already initialized"
    fi
}

safe_write() {
    local file="$1"
    if [ -f "$file" ]; then
        echo "  ⚠️  $file exists — saved new version as $file.bootstrap"
        cat > "$file.bootstrap"
    else
        cat > "$file"
        echo "  ✅ $file"
    fi
}

install_gitconfig() {
    local repo_base="$1"

    if [ -f .gitconfig ]; then
        echo "  ⏭️  .gitconfig already exists — skipping"
        return
    fi

    read -p "  Add .gitconfig with aliases (git ac, git hist, etc.)? (y/n): " choice
    if [ "$choice" = "y" ]; then
        curl -fsSL "$repo_base/.gitconfig" -o .gitconfig
        git config --local --add include.path .gitconfig
        echo "  ✅ .gitconfig added and included"
    else
        echo "  ⏭️  Skipped .gitconfig"
    fi
}

install_precommit() {
    if command -v pre-commit &> /dev/null; then
        pre-commit install -q
        echo "  ✅ Pre-commit hooks installed"
    else
        echo "  ⚠️  pre-commit not found — run: pip install pre-commit && pre-commit install"
    fi
}

print_done() {
    echo ""
    echo "=============================="
    echo "✅ Git tooling ready!"
    echo ""
    echo "  git ac   — AI commit (needs Ollama)"
    echo "  git hist — pretty log"
    echo "  git st   — short status"
    echo "  git finda <keyword> — search aliases"
    echo ""
}
