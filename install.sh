#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
SOURCE="$ROOT/banner.sh"
MARKER="# >>> kayra-terminal >>>"

install_line() {
    local rc="$1"
    local line="$2"
    touch "$rc"
    if ! grep -Fq "$MARKER" "$rc"; then
        cp "$rc" "$rc.kayra-backup"
        {
            printf '\n%s\n' "$MARKER"
            printf '%s\n' "$line"
            printf '%s\n' "# <<< kayra-terminal <<<"
        } >> "$rc"
        printf 'Updated %s (backup: %s.kayra-backup)\n' "$rc" "$rc"
    else
        printf 'Already installed in %s\n' "$rc"
    fi
}

case "$(basename "${SHELL:-bash}")" in
    fish)
        FISH_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/fish/config.fish"
        mkdir -p "$(dirname "$FISH_CONFIG")"
        touch "$FISH_CONFIG"
        if ! grep -Fq "kayra-terminal" "$FISH_CONFIG"; then
            cp "$FISH_CONFIG" "$FISH_CONFIG.kayra-backup"
            {
                printf '\n%s\n' "$MARKER"
                printf 'sh "%s"\n' "$SOURCE"
                printf '%s\n' "# <<< kayra-terminal <<<"
            } >> "$FISH_CONFIG"
        fi
        printf 'Installed for Fish. Open a new terminal.\n'
        ;;
    zsh)
        install_line "$HOME/.zshrc" "sh \"$SOURCE\""
        ;;
    *)
        install_line "$HOME/.bashrc" "sh \"$SOURCE\""
        ;;
esac

printf 'Done. Open a new terminal to see KAYRA.\n'
