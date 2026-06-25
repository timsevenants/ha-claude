# Claude Terminal

Een web-terminal in Home Assistant met de [Claude Code](https://github.com/anthropics/claude-code) CLI vooraf geïnstalleerd. Je login en configuratie blijven bewaard tussen herstarts en updates.

## Installeren

1. Ga naar **Instellingen → Add-ons → Add-on Store**.
2. Klik rechtsboven op het **drie-puntjes-menu → Repositories**.
3. Voeg de URL van deze repo toe (`https://github.com/timsevenants/ha-claude`) en klik **Toevoegen**.
4. Installeer de **Claude Terminal** add-on en start hem.
5. Open de add-on (via de sidebar of **Open Web UI**).

## Eerste keer inloggen

Bij de eerste start krijg je automatisch een **stap-voor-stap wizard** op het scherm:

1. Claude toont een login-link (paar seconden wachten).
2. Er verschijnt een **venster met een klikbare link** — klik erop om je browser te openen.
3. Log in bij je Anthropic-account en klik op **Authorize**.
4. Kopieer de **code** die je browser toont.
5. Sluit het venster (Enter) en **plak de code** terug in de terminal (rechtermuisklik → Plakken, of Ctrl+Shift+V).

De login wordt bewaard in `/data`, dus je hoeft dit maar één keer te doen. Opnieuw inloggen kan altijd met het commando `claude-login`.

## Opties

| Optie | Standaard | Uitleg |
|-------|-----------|--------|
| `auto_launch_claude` | `true` | Start Claude direct bij openen. Op `false` krijg je het sessiemenu. |
| `ha_smart_context` | `true` | Genereert een `CLAUDE.md` met info over je HA-instantie (versie, entiteiten, add-ons) zodat Claude context heeft. |
| `enable_ha_mcp` | `true` | Registreert de `ha-mcp` MCP-server, zodat Claude direct states kan opvragen en services kan aanroepen. |
| `persistent_apk_packages` | `[]` | Extra Alpine-pakketten die bij elke start opnieuw geïnstalleerd worden. |
| `persistent_pip_packages` | `[]` | Extra Python-pakketten die bij elke start opnieuw geïnstalleerd worden. |

## Handige commando's in de terminal

- `claude-login` — begeleide login
- `session-picker` — menu om sessies te starten/hervatten
- `ha-context` — de HA-context opnieuw genereren
- `welcome` — de welkomstbanner met copy-paste-tips opnieuw tonen

## Toegang

De add-on koppelt de HA-config (`/config`) als lees/schrijf, zodat je YAML kunt bewerken. Via `hassio_api` en `homeassistant_api` kan Claude ook met je HA-instantie praten.

> ⚠️ Deze add-on geeft Claude verregaande toegang tot je configuratie en API. Gebruik met beleid.
