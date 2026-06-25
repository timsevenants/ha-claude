#!/usr/bin/with-contenv bashio
# ==============================================================================
# Claude Terminal - startscript
# Start een ttyd web-terminal met de Claude Code CLI erin.
# Login en config worden in /data bewaard, zodat ze herstarts en updates
# overleven (/data is het persistente volume van de add-on).
# ==============================================================================
set -e

# ------------------------------------------------------------------------------
# Persistente opslag (alles onder /data -> overleeft herstart en update)
# HOME=/data zorgt dat ~/.claude (login + user-memory) persistent is.
# ------------------------------------------------------------------------------
export HOME="/data"
export XDG_CONFIG_HOME="/data/.config"
export XDG_DATA_HOME="/data/.local/share"
export XDG_CACHE_HOME="/data/.cache"
mkdir -p "${HOME}/.claude" "${XDG_CONFIG_HOME}" "${XDG_DATA_HOME}" "${XDG_CACHE_HOME}"

# ------------------------------------------------------------------------------
# Auth-migratie: oude login-locaties overzetten naar /data/.claude
# (handig bij overstap van een oudere add-on-versie)
# ------------------------------------------------------------------------------
for legacy in /config/claude-config /config/.claude /root/.claude; do
  if [ -f "${legacy}/.credentials.json" ] && [ ! -f "${HOME}/.claude/.credentials.json" ]; then
    bashio::log.info "Bestaande login gevonden in ${legacy}, migreren naar ${HOME}/.claude ..."
    cp -a "${legacy}/." "${HOME}/.claude/" 2>/dev/null || true
  fi
done

# ------------------------------------------------------------------------------
# Optionele extra pakketten (worden bij elke start opnieuw gezet)
# ------------------------------------------------------------------------------
if bashio::config.has_value 'persistent_apk_packages'; then
  for pkg in $(bashio::config 'persistent_apk_packages'); do
    bashio::log.info "apk: ${pkg} installeren..."
    apk add --no-cache "${pkg}" || bashio::log.warning "Kon apk-pakket niet installeren: ${pkg}"
  done
fi

if bashio::config.has_value 'persistent_pip_packages'; then
  for pkg in $(bashio::config 'persistent_pip_packages'); do
    bashio::log.info "pip: ${pkg} installeren..."
    pip install --break-system-packages "${pkg}" || bashio::log.warning "Kon pip-pakket niet installeren: ${pkg}"
  done
fi

# ------------------------------------------------------------------------------
# Home Assistant smart context: CLAUDE.md met instantie-info genereren
# ------------------------------------------------------------------------------
if bashio::config.true 'ha_smart_context'; then
  bashio::log.info "HA smart context genereren..."
  ha-context || bashio::log.warning "Contextgeneratie mislukt (ga door zonder)."
fi

# ------------------------------------------------------------------------------
# Home Assistant MCP-server (ha-mcp) registreren bij Claude
# ------------------------------------------------------------------------------
if bashio::config.true 'enable_ha_mcp'; then
  bashio::log.info "HA MCP-server (ha-mcp) registreren..."
  setup-ha-mcp || bashio::log.warning "MCP-registratie mislukt (ga door zonder)."
fi

# ------------------------------------------------------------------------------
# Bepaal wat de terminal start
#  - auto_launch_claude: direct Claude in een persistente tmux-sessie
#  - anders: het sessiemenu (session-picker)
# ------------------------------------------------------------------------------
cd /config

if bashio::config.true 'auto_launch_claude'; then
  LAUNCH_CMD='welcome; tmux new-session -A -s claude claude; echo; echo "Sessie beeindigd - typ \"session-picker\" of \"claude-login\"."; exec bash'
else
  LAUNCH_CMD='exec session-picker'
fi

bashio::log.info "Claude Terminal start op poort 7681..."
bashio::log.info "Eerste keer: typ 'claude-login' in de terminal om in te loggen."

# ------------------------------------------------------------------------------
# Start de web-terminal
#  - clickableLinks: maakt de login-URL aanklikbaar (geen kopiëren nodig)
#  - thema + lettergrootte voor leesbaarheid
#  - disableLeaveAlert: geen 'weet je het zeker' bij wegnavigeren
# ------------------------------------------------------------------------------
exec ttyd \
  --port 7681 \
  --interface 0.0.0.0 \
  --writable \
  --ping-interval 30 \
  --client-option fontSize=14 \
  --client-option 'theme={"background":"#1e1e2e","foreground":"#cdd6f4"}' \
  --client-option disableLeaveAlert=true \
  bash -lc "${LAUNCH_CMD}"
