# Claude Terminal

Een web-terminal in Home Assistant met de [Claude Code](https://github.com/anthropics/claude-code) CLI vooraf geïnstalleerd. Je login en configuratie blijven bewaard tussen herstarts en updates.

## Installeren

1. Ga naar **Instellingen → Add-ons → Add-on Store**.
2. Klik rechtsboven op het **drie-puntjes-menu → Repositories**.
3. Voeg de URL van deze repo toe (`https://github.com/timsevenants/ha-claude`) en klik **Toevoegen**.
4. Installeer de **Claude Terminal** add-on en start hem.
5. Open de add-on (via de sidebar of **Open Web UI**).

## Eerste keer inloggen

Typ in de terminal `claude` en volg de inloglink om in te loggen met je Anthropic-account (OAuth). De login wordt bewaard in `/data`, dus je hoeft dit maar één keer te doen.

## Opties

| Optie | Standaard | Uitleg |
|-------|-----------|--------|
| `auto_launch_claude` | `true` | Start Claude direct bij openen. Op `false` krijg je eerst een shell. |
| `persistent_apk_packages` | `[]` | Extra Alpine-pakketten die bij elke start opnieuw geïnstalleerd worden. |
| `persistent_pip_packages` | `[]` | Extra Python-pakketten die bij elke start opnieuw geïnstalleerd worden. |

## Toegang

De add-on koppelt de HA-config (`/config`) als lees/schrijf, zodat je YAML kunt bewerken. Via `hassio_api` en `homeassistant_api` kan Claude ook met je HA-instantie praten.

> ⚠️ Deze add-on geeft Claude verregaande toegang tot je configuratie en API. Gebruik met beleid.
