# Changelog

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
