#!/usr/bin/env bash
# ==============================================================================
# claude-login.sh
# Begeleide login voor Claude Code.
#
# Lost het probleem op dat de login-URL over twee regels afbreekt en dan niet
# klikbaar is: een achtergrond-watcher leest de volledige URL uit het
# tmux-venster (regels samengevoegd met -J) en schrijft die op ÉÉN regel naar
# /config/claude-login-url.txt, zodat je hem foutloos kunt kopiëren.
# ==============================================================================
set -uo pipefail

SESSION="claude"
URL_FILE="/config/claude-login-url.txt"

echo
echo "── Claude Code login ─────────────────────────────────────────────"
echo
echo "  Zo dadelijk verschijnt er een login-URL."
echo "  Als die over twee regels afbreekt en niet goed klikbaar is:"
echo
echo "    -> De VOLLEDIGE URL wordt op één regel opgeslagen in:"
echo "         ${URL_FILE}"
echo "       Open dat bestand (File editor / Samba), kopieer de URL en"
echo "       plak hem in je browser."
echo
echo "  Na het inloggen toont je browser een code -> plak die hier terug"
echo "  met rechtermuisklik -> Plakken (of Ctrl+Shift+V)."
echo "──────────────────────────────────────────────────────────────────"
echo
sleep 2

# Verwijder een oude URL zodat je niet per ongeluk een verlopen link kopieert
rm -f "${URL_FILE}" 2>/dev/null || true

# ------------------------------------------------------------------------------
# Watcher: vist de login-URL uit het tmux-venster en bewaart hem als platte tekst
# ------------------------------------------------------------------------------
(
  for _ in $(seq 1 240); do
    if tmux has-session -t "${SESSION}" 2>/dev/null; then
      url="$(tmux capture-pane -t "${SESSION}" -p -J 2>/dev/null \
             | grep -oE 'https://[A-Za-z0-9._~:/?#@!$&'"'"'()*+,;=%-]+' \
             | grep -iE 'oauth|claude\.ai|anthropic' \
             | head -1 || true)"
      if [ -n "${url:-}" ]; then
        printf '%s\n' "${url}" > "${URL_FILE}" 2>/dev/null || true
        tmux display-message -d 0 -t "${SESSION}" \
          "Login-URL opgeslagen in ${URL_FILE} - open dat bestand om de volledige URL te kopieren" \
          2>/dev/null || true
        break
      fi
    fi
    sleep 0.5
  done
) &

# Claude starten in een tmux-sessie (de watcher leest hieruit mee)
exec tmux new-session -A -s "${SESSION}" claude
