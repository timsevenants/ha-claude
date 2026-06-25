#!/usr/bin/env bash
# ==============================================================================
# setup-ha-mcp.sh
# Registreert de Home Assistant MCP-server (ha-mcp) bij Claude Code, zodat Claude
# direct states kan opvragen en services kan aanroepen. Draait via uvx.
# Wordt aangeroepen vanuit run.sh op basis van de optie enable_ha_mcp.
# ==============================================================================
set -uo pipefail

HA_MCP_VERSION="3.5.1"
TOKEN="${SUPERVISOR_TOKEN:-}"

if [ -z "${TOKEN}" ]; then
  echo "ha-mcp: geen SUPERVISOR_TOKEN beschikbaar, overslaan." >&2
  exit 0
fi

if ! command -v uvx >/dev/null 2>&1; then
  echo "ha-mcp: 'uvx' niet gevonden, overslaan." >&2
  exit 0
fi

# Bestaande registratie opruimen, zodat we altijd schoon (her)registreren.
claude mcp remove home-assistant >/dev/null 2>&1 || true

if claude mcp add home-assistant \
  --env "HOMEASSISTANT_URL=http://supervisor/core" \
  --env "HOMEASSISTANT_TOKEN=${TOKEN}" \
  -- uvx --index-strategy unsafe-best-match "ha-mcp@${HA_MCP_VERSION}"; then
  echo "ha-mcp: MCP-server 'home-assistant' geregistreerd (ha-mcp@${HA_MCP_VERSION})."
else
  echo "ha-mcp: automatische registratie mislukt. Handmatig:" >&2
  echo "  claude mcp add home-assistant \\" >&2
  echo "    --env HOMEASSISTANT_URL=http://supervisor/core \\" >&2
  echo "    --env HOMEASSISTANT_TOKEN=\$SUPERVISOR_TOKEN \\" >&2
  echo "    -- uvx --index-strategy unsafe-best-match ha-mcp@${HA_MCP_VERSION}" >&2
fi
