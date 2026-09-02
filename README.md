# Home Assistant add-on: Infinitude

[![Open your Home Assistant instance and show the add add-on repository dialog with this repository URL pre-filled.](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2Fappleguru%2Fhomeassistant-infinitude-proxy)

A Home Assistant add-on that runs [nebulous/infinitude][upstream], the local
proxy for Carrier and Bryant Infinity Touch thermostats (also sold as ICP,
Heil and Tempstar).

This is not affiliated with the upstream project.

## Why

Most people run Infinitude on Home Assistant OS as a hand-created Docker
container, usually through Portainer — which is what upstream's own install
notes describe. That works, but it has three costs:

- Supervisor marks the system as unsupported, because a third-party container
  is running alongside Home Assistant.
- The container is invisible to Home Assistant backups.
- State lives in the container's writable layer, so recreating the container
  to pick up a new image silently throws your configuration away.

Packaging it as an add-on fixes all three. Supervisor owns the lifecycle,
state lives in `/data`, and backups pick it up.

The Portainer add-on has since been removed from the community repository,
which makes the hand-rolled route harder to set up in the first place.

## Installation

Click the badge above, or add
`https://github.com/appleguru/homeassistant-infinitude-proxy` under **Settings → Add-ons →
Add-on Store → ⋮ → Repositories**, then install **Infinitude**.

Full setup and migration instructions are in [the add-on docs](infinitude/DOCS.md).

## Pair it with

[Infinitude Beyond][beyond] — a HACS custom integration that turns the
Infinitude API into Home Assistant climate entities. The add-on provides the
proxy; the integration provides the entities. You want both.

## Architectures

`aarch64` and `amd64`. Supervisor has deprecated `armhf`, `armv7` and
`i386`, so they are not declared. The upstream image is published as a
multi-arch manifest, so the correct variant is selected automatically.

## License

MIT, the same license as [nebulous/infinitude][upstream].

[upstream]: https://github.com/nebulous/infinitude
[beyond]: https://github.com/MizterB/homeassistant-infinitude-beyond
