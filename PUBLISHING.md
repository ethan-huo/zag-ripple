# Publishing

This package is distributed from GitHub version tags. `main` is the source
branch and does not track generated `dist/`. Release tags are consumable
snapshots that include `dist/` built from the source at that version.

## Version Contract

`package.json#version` is the source of truth for release tags.

When `package.json` changes on `main`, `.github/workflows/release.yml`:

1. Reads `package.json#version`.
2. Resolves the release tag as `v${version}`.
3. Refuses non-semver versions.
4. Refuses versions not greater than the latest `vX.Y.Z` tag.
5. Runs tests.
6. Builds `dist/`.
7. Creates an annotated tag from a release-only tree.

The release tag contains only: `package.json` (without `scripts`/`devDependencies`),
`README.md`, `LICENSE`, `CHANGELOG.md`, `dist/`, and `src/`. Repository-only
files (`.github/`, configs, tests) are excluded.

If the tag already exists, the workflow exits without creating a new tag.

## Releasing

1. Update `package.json#version`.
2. Update `CHANGELOG.md`.
3. Commit and push to `main`.
4. Let CI create the matching tag.

Consumers depend on a version tag, not `main`:

```bash
bun add github:ethan-huo/ripple-zag#v0.2.0
```
