# Home Assistant app: Infinitude

[![Open your Home Assistant instance and show the add app repository dialog with this repository URL pre-filled.](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2Fappleguru%2Fhomeassistant-infinitude-proxy)

A Home Assistant app that runs [nebulous/infinitude][upstream], the local
proxy for Carrier and Bryant Infinity Touch thermostats (also sold as ICP,
Heil and Tempstar).

This is not affiliated with the upstream project.

## Installation

Click the badge above, or add
`https://github.com/appleguru/homeassistant-infinitude-proxy` under **Settings → Apps →
App store → ⋮ → Repositories**, then install **Infinitude**.

Full setup and migration instructions are in [the app docs](infinitude/DOCS.md).

## Pair it with

[Infinitude Beyond][beyond], a HACS custom integration that turns the
Infinitude API into Home Assistant climate entities. This app provides the
proxy; the integration provides the entities. You want both.

## Upstream tracking

We track [nebulous/infinitude][upstream] and do releases to stay up to date
with the upstream project.

[upstream]: https://github.com/nebulous/infinitude
[beyond]: https://github.com/MizterB/homeassistant-infinitude-beyond
