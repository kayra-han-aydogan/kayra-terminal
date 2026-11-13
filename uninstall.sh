#!/usr/bin/env bash
set -euo pipefail

MARKER="# >>> kayra-terminal >>>"
END_MARKER="# <<< kayra-terminal <<<"

for rc in "$HOME/.bashrc" "$HOME/.zshrc" "${XDG_CONFIG_HOME:-$HOME/.config}/fish/config.fish"; do
    if [[ -f "$rc" ]] && grep -Fq "$MARKER" "$rc"; then
        tmp="$(mktemp)"
        awk -v start="$MARKER" -v finish="$END_MARKER" '
            $0 == start { skip=1; next }
            $0 == finish { skip=0; next }
            !skip { print }
        ' "$rc" > "$tmp"
        cat "$tmp" > "$rc"
        rm -f "$tmp"
        printf 'Removed banner from %s\n' "$rc"
    fi
done

printf 'Uninstall complete.\n'
