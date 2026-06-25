#!/usr/bin/env bash
# ==============================================================================
# login-popup.sh
# Wordt getoond in een tmux pop-up zodra de login-URL is gevonden.
# Toont de URL als KLIKBARE terminal-hyperlink (OSC 8), plus de platte URL als
# terugvaloptie. Sluit met Enter.
# ==============================================================================
URL="$(cat /tmp/claude_login_url 2>/dev/null)"

clear
echo
echo "  ┌────────────────────────────────────────────────────────────┐"
echo "  │  STAP 2 — Open de login-link                               │"
echo "  └────────────────────────────────────────────────────────────┘"
echo
echo "  Klik op de onderstaande link (opent in je browser):"
echo
printf '      \033]8;;%s\033\\►►►  KLIK HIER OM IN TE LOGGEN  ◄◄◄\033]8;;\033\\\n' "${URL}"
echo
echo "  Werkt klikken niet? Sleep dan met je muis over de URL hieronder"
echo "  om hem te selecteren en kopieer (rechtermuisklik → Kopiëren):"
echo
echo "  ${URL}"
echo
echo "  ──────────────────────────────────────────────────────────────"
echo "  STAP 3  Log in en klik op 'Authorize'."
echo "  STAP 4  Kopieer de code die je browser toont."
echo "  STAP 5  Druk hieronder op Enter en plak de code in de terminal."
echo
read -rp "  [Enter] om dit venster te sluiten en de code te plakken... " _
