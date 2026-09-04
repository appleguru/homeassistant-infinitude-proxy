# Infinitude

Runs [nebulous/infinitude][upstream] as a Home Assistant app.

Infinitude is a local proxy that sits between a Carrier / Bryant Infinity
Touch thermostat (also sold as ICP, Heil and Tempstar) and Carrier's cloud.
The thermostat is pointed at Infinitude as its HTTP proxy; Infinitude reads
and rewrites the traffic, which gives you local control and a local API.

Pair it with the [Infinitude Beyond][beyond] custom integration, installed
through HACS, to get climate entities in Home Assistant.

## Installation

1. Add this repository to **Settings → Apps → Install app → ⋮ →
   Repositories**.
2. Install **Infinitude** and start it.
3. On the thermostat: **Menu → Wireless → Advanced Settings** and set the
   HTTP proxy to `http://<home-assistant-ip>:3000`. The exact path varies by
   firmware.
4. Confirm the Infinitude web UI loads at `http://<home-assistant-ip>:3000`.
5. Add the Infinitude Beyond integration and point it at the same host and
   port.

## Options

| Option | Default | Description |
| --- | --- | --- |
| `port` | `3000` | Port Infinitude listens on. Change it if something else already uses 3000 — Z-Wave JS UI declares 3000 internally, which does not conflict, but other apps might. |
| `mode` | `Production` | Set to `Development` for verbose logging when troubleshooting. |
| `pass_reqs` | `1020` | How many requests to pass through to Carrier's servers before Infinitude starts answering locally. Leave alone unless you know why you are changing it. |
| `app_secret` | generated | Signs session cookies. Left blank, a random secret is generated once and stored in `/data/app_secret`. |
| `serial_tty` | unset | Serial device for direct ABCD-bus access, e.g. `/dev/ttyUSB0`. Optional and untested. |
| `serial_socket` | unset | Network socket for a remote serial bridge. Optional and untested. |

## Networking

The app uses host networking. `port` binds directly on the host.
Make sure it does not collide with anything else.

## State and backups

Runtime state lives in `/data/state` inside the app, which Supervisor
includes in Home Assistant backups. On first start the directory is seeded
from the upstream image.

## Support

Issues with this app belong on this repository. Issues with Infinitude
itself belong [upstream][upstream].

[upstream]: https://github.com/nebulous/infinitude
[beyond]: https://github.com/MizterB/homeassistant-infinitude-beyond
