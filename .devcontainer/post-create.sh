#!/usr/bin/env bash
set -euo pipefail

is_enabled() {
    case "${1:-1}" in
        1 | true | TRUE | yes | YES | on | ON) return 0 ;;
        *) return 1 ;;
    esac
}

mkdir -p "$HOME/.codex" "$HOME/.claude" "$HOME/.config"
sudo chown "$(id -u):$(id -g)" "$HOME/.codex" "$HOME/.claude" "$HOME/.config"

if is_enabled "${INSTALL_PLAYWRIGHT:-1}"; then
    echo -e "\033[1;36m==> Updating apt packages\033[0m"
    sudo apt update -yqq

    echo -e "\033[1;36m==> Installing Playwright\033[0m"
    if [[ "${PLAYWRIGHT_BROWSERS:-chromium}" == "all" ]]; then
        npx --yes playwright install --with-deps
    else
        read -r -a playwright_browsers <<<"${PLAYWRIGHT_BROWSERS:-chromium}"
        npx --yes playwright install --with-deps "${playwright_browsers[@]}"
    fi
else
    echo -e "\033[1;36m==> Skipping Playwright install\033[0m"
fi

if is_enabled "${INSTALL_CLAUDE_CODE:-1}"; then
    echo -e "\033[1;36m==> Installing Claude Code\033[0m"
    npm install -g @anthropic-ai/claude-code
    claude install
else
    echo -e "\033[1;36m==> Skipping Claude Code install\033[0m"
fi

if is_enabled "${INSTALL_CODEX:-1}"; then
    echo -e "\033[1;36m==> Installing Codex CLI\033[0m"
    npm install -g @openai/codex
else
    echo -e "\033[1;36m==> Skipping Codex CLI install\033[0m"
fi
