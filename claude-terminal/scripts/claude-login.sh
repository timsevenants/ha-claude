#!/usr/bin/env bash
# ==============================================================================
# claude-login.sh
# Begeleide eerste login voor Claude Code, volledig op het scherm.
#
# Toont een stap-voor-stap wizard en vangt de login-URL op uit het tmux-venster.
# Zodra de URL verschijnt, opent een pop-up met een KLIKBARE link (terminal-
# hyperlink, werkt ook als de URL normaal over twee regels zou afbreken).
# Geen tekstbestand nodig.
# ==============================================================================
set -uo pipefail

SESSION="claude"
URL_TMP="/tmp/claude_login_url"

clear
cat <<'EOF'

  ╔══════════════════════════════════════════════════════════════════╗
  ║   Claude Terminal — eerste keer inloggen                          ║
  ╚══════════════════════════════════════════════════════════════════╝

  Volg deze stappen (je hoeft niets te onthouden, ze verschijnen ook
  straks in een venster op je scherm):

    STAP 1  Wacht tot Claude een login-link toont (een paar seconden).
    STAP 2  Er verschijnt automatisch een VENSTER met een klikbare link.
            Klik erop — je browser opent met de Anthropic-loginpagina.
    STAP 3  Log in bij je Anthropic-account en klik op "Authorize".
    STAP 4  Je browser toont daarna een CODE. Kopieer die code.
    STAP 5  Sluit het venster (druk op Enter) en PLAK de code terug in
            de terminal:  rechtermuisklik → Plakken  (of Ctrl+Shift+V).

  Bezig met starten...

EOF
sleep 3

rm -f "${URL_TMP}" 2>/dev/null || true

# ------------------------------------------------------------------------------
# Watcher: vist de login-URL uit het tmux-venster en toont 'm in een pop-up
# ------------------------------------------------------------------------------
(
  for _ in $(seq 1 240); do
    if tmux has-session -t "${SESSION}" 2>/dev/null; then
      url="$(tmux capture-pane -t "${SESSION}" -p -J 2>/dev/null \
             | grep -oE 'https://[A-Za-z0-9._~:/?#@!$&'"'"'()*+,;=%-]+' \
             | grep -iE 'oauth|claude\.ai|anthropic' \
             | head -1 || true)"
      if [ -n "${url:-}" ]; then
        printf '%s' "${url}" > "${URL_TMP}" 2>/dev/null || true
        # Eerst proberen als net pop-upvenster; lukt dat niet, dan direct tonen.
        if ! tmux display-popup -E -w 90% -h 60% "/opt/scripts/login-popup.sh" 2>/dev/null; then
          printf '\n\n  >>> Login-link (klik of selecteer + kopieer): <<<\n\n'
          printf '      \033]8;;%s\033\\KLIK HIER OM IN TE LOGGEN\033]8;;\033\\\n\n' "${url}"
          printf '      %s\n\n' "${url}"
        fi
        break
      fi
    fi
    sleep 0.5
  done
) &

# Claude starten in een tmux-sessie (de watcher leest hieruit mee)
exec tmux new-session -A -s "${SESSION}" claude
