#!/usr/bin/env bash
# Begeleide login voor Claude Code in de web-terminal.
set -e

echo
echo "── Claude Code login ─────────────────────────────────────────────"
echo
echo "Er verschijnt zo een login-URL. Werkwijze:"
echo "  1. KLIK op de URL (of selecteer + rechtermuisklik → Kopiëren) en open hem."
echo "  2. Log in / autoriseer in je browser."
echo "  3. Kopieer de code die je browser toont."
echo "  4. PLAK die hier met rechtermuisklik → Plakken (of Ctrl+Shift+V)."
echo
echo "Lukt plakken niet? Open Home Assistant via een HTTPS-adres en probeer opnieuw."
echo "──────────────────────────────────────────────────────────────────"
echo

# Start de interactieve login van Claude Code.
exec claude
