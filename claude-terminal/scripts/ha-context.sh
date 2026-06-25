#!/usr/bin/env bash
# ==============================================================================
# ha-context.sh
# Genereert een overzicht van deze Home Assistant-instantie als CLAUDE.md,
# zodat Claude meteen weet welke entiteiten, add-ons en versies er draaien.
# Schrijft naar de user-memory van Claude ($HOME/.claude/CLAUDE.md), zodat het
# automatisch geladen wordt en NIET botst met een eigen /config/CLAUDE.md.
# ==============================================================================
set -euo pipefail

OUT="${1:-${HOME}/.claude/CLAUDE.md}"
TOKEN="${SUPERVISOR_TOKEN:-}"
API="http://supervisor"

mkdir -p "$(dirname "${OUT}")"

if [ -z "${TOKEN}" ]; then
  echo "ha-context: geen SUPERVISOR_TOKEN, sla contextgeneratie over." >&2
  exit 0
fi

_get() {
  # _get <pad> -> JSON op stdout (stil bij fouten)
  curl -fsSL -H "Authorization: Bearer ${TOKEN}" -H "Content-Type: application/json" \
    "${API}/$1" 2>/dev/null || echo '{}'
}

core_info="$(_get core/info)"
ha_config="$(_get core/api/config)"
states="$(_get core/api/states)"
addons="$(_get addons)"

ha_version="$(echo "${core_info}" | jq -r '.data.version // "onbekend"')"
machine="$(echo "${core_info}" | jq -r '.data.machine // "onbekend"')"
tz="$(echo "${ha_config}" | jq -r '.time_zone // "onbekend"')"
location="$(echo "${ha_config}" | jq -r '.location_name // "onbekend"')"

{
  echo "# Home Assistant context"
  echo
  echo "> Automatisch gegenereerd door de Claude Terminal add-on. Niet handmatig bewerken;"
  echo "> dit bestand wordt bij elke start van de add-on opnieuw aangemaakt."
  echo
  echo "## Systeem"
  echo "- HA-versie: ${ha_version}"
  echo "- Machine: ${machine}"
  echo "- Locatie: ${location}"
  echo "- Tijdzone: ${tz}"
  echo "- Configuratiemap: \`/config\` (lees/schrijf vanuit deze terminal)"
  echo

  echo "## Entiteiten per domein"
  if echo "${states}" | jq -e 'type == "array"' >/dev/null 2>&1; then
    echo "| Domein | Aantal |"
    echo "|--------|--------|"
    echo "${states}" \
      | jq -r '.[].entity_id | split(".")[0]' \
      | sort | uniq -c | sort -rn \
      | awk '{printf "| %s | %s |\n", $2, $1}'
    total="$(echo "${states}" | jq -r 'length')"
    echo
    echo "Totaal: ${total} entiteiten."
  else
    echo "_Kon entiteiten niet ophalen._"
  fi
  echo

  echo "## Geïnstalleerde add-ons"
  if echo "${addons}" | jq -e '.data.addons | type == "array"' >/dev/null 2>&1; then
    echo "${addons}" \
      | jq -r '.data.addons[] | "- \(.name) (\(.version)) — \(.state)"'
  else
    echo "_Kon add-onlijst niet ophalen._"
  fi
  echo

  echo "## HA-API gebruiken vanuit deze terminal"
  echo '```bash'
  echo '# Alle states ophalen'
  echo 'curl -s -H "Authorization: Bearer $SUPERVISOR_TOKEN" http://supervisor/core/api/states | jq'
  echo
  echo '# Een service aanroepen (bv. licht aanzetten)'
  echo "curl -s -X POST -H \"Authorization: Bearer \$SUPERVISOR_TOKEN\" \\"
  echo "  -H 'Content-Type: application/json' -d '{\"entity_id\":\"light.woonkamer\"}' \\"
  echo '  http://supervisor/core/api/services/light/turn_on'
  echo '```'
  echo
  echo "_Tip: gebruik bij voorkeur de \`home-assistant\` MCP-tools (ha-mcp) als die is ingeschakeld._"
} > "${OUT}"

echo "ha-context: context geschreven naar ${OUT}"
