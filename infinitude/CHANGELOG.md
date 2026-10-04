# Changelog

## 2026.9.0

Upstream release notes: https://github.com/nebulous/infinitude/releases/tag/2026.9.0

First CalVer release. Version is visible in the boot log, at `/api/version`, and on the web UI's About page; Docker images are tagged with the version alongside `latest`.

#### Changes

- **Timed holds are bus-writable.** A 3B03 write with change flags `0x82`, the zone's `zones_holding` bit clear, and minutes in `hold_duration` arms a real timed hold (verified live against an Infinity Touch). Durations are quantized to the thermostat's 15-minute grid and clamped to [15, 1425] minutes. `/api/hold` now propagates timed holds over RS485 like permanent and cancel.
- **Decoded 3B03 byte 37** as the per-zone timed-hold bitmask (`zones_timed`), replacing an opaque byte in the parser.
- **Fixed the 3B02 mode nibble values:** 4 is heatpump-only, 5 is off (previously 4 was mislabeled off, and mode 5 failed to parse). Corrected against infinitive and InfinitESP.
- **CalVer versioning and automated releases** (this machinery).

## 1.1.2

- Updated the pinned upstream image to `sha256:df0b5b2f37a357e81679359edbc99600543b8e4bc88776e5767692e2d0d0c9e7`.
- Upstream changes ([ad655f8...38994dd](https://github.com/nebulous/infinitude/compare/ad655f8...38994dd)):
  - implement versioning scheme & minor test tweaks (nebulous/infinitude#233) (38994dd)

## 1.1.1

- Pinned the upstream `nebulous/infinitude` image to
  `sha256:66f64d156c6f4537369d6ea587cf4440cf9607b0e7b8296468febf96bafebe00`,
  so rebuilds are reproducible instead of following the `latest` tag.

## 1.1.0

- Renamed add-on terminology to app, matching Home Assistant 2026.2.
- Added an app icon.
- `infinitude.json` now lives in `/data` and app options are merged over it,
  so settings written by Infinitude itself survive restarts and are captured
  by Home Assistant backups.
- Startup fails loudly if the options helper or the state seed fails, instead
  of continuing with a broken configuration.
- The app secret file is created with `0600` permissions atomically.
- Removed the `ports` mapping, which had no effect under host networking and
  could disagree with the configured `port`.

## 1.0.0

- Initial release.
- Wraps the upstream multi-arch `nebulous/infinitude` image.
- Configuration comes from app options instead of environment variables.
- Runtime state is persisted to `/data/state`, so it survives restarts and
  updates and is captured by Home Assistant backups.
- Listen port and log mode are configurable; the app secret is generated
  once and persisted if not supplied.
