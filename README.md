# vibe-coding-devcontainer

A devcontainer template for vibe coding with Claude Code and Codex.

## Included

- Node.js 24 + TypeScript on Debian Bookworm
- Go
- Python 3.12
- GitHub CLI
- Docker CLI through the host Docker socket
- Playwright CLI with Chromium browser dependencies
- Claude Code CLI
- Codex CLI
- VS Code extensions for Node, Python, Docker, GitHub, Playwright, Markdown, and TOML

## First Start

Open the repository with VS Code Dev Containers or Codespaces and rebuild the container. The first `postCreateCommand` run installs Playwright, Claude Code, and Codex, so the first build can take a while.

The Claude and Codex config directories are stored in named Docker volumes:

- `claude-code-data` -> `/home/vscode/.claude`
- `codex-data` -> `/home/vscode/.codex`

These directories are writable container state. They are not seeded from repository files during `postCreateCommand`.

Host credentials are mounted separately:

- `${HOME}/.claude/.credentials.json` -> `/home/vscode/.claude/.credentials.json`
- `${HOME}/.claude.json` -> `/home/vscode/.claude.json`
- `${HOME}/.codex/auth.json` -> `/home/vscode/.codex/auth.json`
- `${HOME}/.config/gh` -> `/home/vscode/.config/gh`

Sign in on the host or from inside the container when needed:

```bash
gh auth login
claude
codex
```

## Configuration Flags

The default behavior is controlled in `.devcontainer/devcontainer.json`:

- `INSTALL_PLAYWRIGHT=1` installs Playwright.
- `PLAYWRIGHT_BROWSERS=chromium` keeps the default install smaller. Use `all`, `firefox`, or `webkit` if needed.
- `INSTALL_CLAUDE_CODE=1` installs Claude Code.
- `INSTALL_CODEX=1` installs Codex.

Set any install flag to `0` before rebuilding if you want a lighter container.

## Reset Agent State

If Claude Code or Codex state gets corrupted, remove the named volumes before rebuilding:

```bash
docker volume rm claude-code-data codex-data
```

The next rebuild recreates empty writable volumes. Host credentials stay on the host and are mounted again by `devcontainer.json`.

## Docker Notes

This template uses `docker-outside-of-docker`, so Docker must be running on the host. For bind mounts from inside the container, use the host path exposed as `LOCAL_WORKSPACE_FOLDER`:

```bash
docker run --rm -v "$LOCAL_WORKSPACE_FOLDER:/workspace" debian:bookworm ls /workspace
```

## Quick Check

After the container starts, these commands should be available:

```bash
node --version
python --version
gh --version
docker --version
playwright --version
claude --version
codex --version
```
