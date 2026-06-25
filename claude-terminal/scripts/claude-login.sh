#!/usr/bin/env bash
# ==============================================================================
# claude-login.sh
# Eenvoudige login voor Claude Code: start Claude en toont de login-URL gewoon
# op het scherm. Geen pop-up, geen bestand.
# ==============================================================================
set -uo pipefail

SESSION="claude"

echo
echo "── Claude Code login ─────────────────────────────────────────────"
echo
echo "  Zo dadelijk verschijnt er een login-URL op het scherm."
echo "    1. Open de URL in je browser (klik erop, of selecteer met de"
echo "       muis en kopieer met rechtermuisklik → Kopiëren)."
echo "    2. Log in en klik op 'Authorize'."
echo "    3. Kopieer de code die je browser toont."
echo "    4. Plak die hier terug: rechtermuisklik → Plakken (Ctrl+Shift+V)."
echo
echo "──────────────────────────────────────────────────────────────────"
sleep 2

# Claude starten in een tmux-sessie (blijft draaien als je het tabblad sluit)
exec tmux new-session -A -s "${SESSION}" claude
