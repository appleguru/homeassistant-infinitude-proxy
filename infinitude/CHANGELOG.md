# Changelog

## 1.0.0

- Initial release.
- Wraps the upstream multi-arch `nebulous/infinitude` image.
- Configuration comes from add-on options instead of environment variables.
- Runtime state is persisted to `/data/state`, so it survives restarts and
  updates and is captured by Home Assistant backups.
- Listen port and log mode are configurable; the app secret is generated
  once and persisted if not supplied.
