# 🛠️ gitkit

One-liner to set up git tooling in any existing project. Adds gitignore, pre-commit hooks, linter config, and optionally a `.gitconfig` with aliases.

Does **not** scaffold your project - just the git stuff.

## Usage

`cd` into your project, then:

```bash
# Python
curl -fsSL https://raw.githubusercontent.com/ppaczk0wsk1/gitkit/main/python/setup.sh | bash

# TypeScript
curl -fsSL https://raw.githubusercontent.com/ppaczk0wsk1/gitkit/main/typescript/setup.sh | bash

# Go
curl -fsSL https://raw.githubusercontent.com/ppaczk0wsk1/gitkit/main/golang/setup.sh | bash
```

## What Gets Added

### `.gitconfig` (optional)

The script asks if you want it. If you already have one, it skips automatically.

| Alias | Command |
|-------|---------|
| `git st` | `status -s` |
| `git co` | `checkout` |
| `git ci` | `commit` |
| `git br` | `branch` |
| `git pl` | `pull --rebase` |
| `git f` | `fetch -p` |
| `git undo` | Undo last commit, keep changes |
| `git amend` | Amend last commit |
| `git hist` | Pretty commit graph |
| `git rank` | Contributor leaderboard |
| `git finda` | Search aliases by keyword |
| `git ac` | AI commit message via Ollama |

### Per-language files

**Python** - `.gitignore`, `.pre-commit-config.yaml` (ruff, mypy, general hooks), `pyproject.toml` (ruff + mypy config)

**TypeScript** - `.gitignore`, `.pre-commit-config.yaml` (eslint, prettier, general hooks), `.prettierrc`, `.prettierignore`

**Go** - `.gitignore`, `.pre-commit-config.yaml` (go-fmt, go-vet, go-imports, general hooks), `.golangci.yml`

### Existing files

If a config file already exists, the script skips it and saves the new version as `<file>.bootstrap` so you can diff and merge what you want.

## Forking

```bash
# Add to .bashrc / .zshrc
export BOOTSTRAPS_OWNER="your_username"

# Then curl from your fork
curl -fsSL https://raw.githubusercontent.com/your_username/gitkit/main/python/setup.sh | bash
```

## Requirements

- Git
- [pre-commit](https://pre-commit.com/) (`pip install pre-commit`)

## AI Commit Messages (optional)

The `git ac` alias uses [Ollama](https://ollama.ai) to generate commit messages from your staged diff - fully local, no API keys, no internet needed.

### Setup

```bash
# Install Ollama
curl -fsSL https://ollama.ai/install.sh | sh   # Linux
brew install ollama                              # macOS

# Pull a model
ollama pull phi3:mini
```

### Usage

```bash
git add .
git ac
```

It reads your diff, suggests a conventional commit message, and lets you accept, edit, or reject it.

### Choosing a model

You can swap the model in `.gitconfig` by changing `phi3:mini` to any Ollama model:

| Model | RAM | Quality |
|-------|-----|---------|
| `tinyllama` | ~1 GB | Good enough |
| `phi3:mini` | ~3 GB | Recommended |
| `mistral` | ~5 GB | Excellent |
| `llama3` | ~6 GB | Excellent |

No GPU required - runs on CPU, just takes a few seconds. 8 GB RAM is enough for `phi3:mini`.
