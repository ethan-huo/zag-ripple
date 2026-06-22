# AGENTS.md - Guidelines for AI Coding Agents

This repository is `ripple-zag`, a Ripple/TSRX adapter for Zag JS state
machines. It is a single source-distributed package; the showcase site lives in
the separate `ripple-explore` repo.

## Project Layout

- `src/` - Runtime adapter code (`useMachine`, `normalizeProps`, mount helpers,
  small utilities).
- `tests/` - Vitest + TSRX regression tests for the adapter.

## Commands

Use Bun as the package manager.

```bash
bun install        # install dependencies
bun run build      # build dist/ via tsup
bun run test       # build + vitest (browser conditions)
bun run typecheck  # tsc --noEmit
```

## Release Model

Not published to npm. Releases are GitHub snapshot tags. `.github/workflows/release.yml`
reads `package.json#version`, tests, builds, then creates an annotated `vX.Y.Z`
tag whose root is the installable package snapshot (`package.json`, `dist`,
`src`, README, LICENSE, CHANGELOG). Consumers install:

```json
{ "dependencies": { "ripple-zag": "github:ethan-huo/ripple-zag#v0.2.0" } }
```

Only bump `package.json#version` when a new release tag should be created. See
[PUBLISHING.md](./PUBLISHING.md).

## Coding Notes

- Keep adapter changes small and source-backed. `@zag-js/*`, `ripple`, and TSRX
  are moving targets; check local installed package code or upstream docs before
  changing integration behavior.
- `useMachine` accepts plain props and top-level tracked props. Do not call
  function props while unwrapping user props; Zag callbacks and stores commonly
  contain functions that must be passed through.
- Avoid writing tracked state during a derived `track(() => ...)` computation.
  If a Zag callback fires during connect and must update local state, defer the
  write and guard against loops.
- Comments should explain why an adapter boundary exists, not restate the code.

## Documentation Entrypoints

The Ripple + TSRX integration story shifts often; reading from memory produces
stale guidance. Fetch these via `ctx read <url>` before changing `useMachine`,
`normalizeProps`, or build wiring:

- TSRX LLM docs: https://tsrx.dev/llms.txt
- TSRX rethink blog: https://tsrx.dev/blog/rethinking-tsrx
- Ripple LLM docs: https://www.ripple-ts.com/llms.txt
- Zag JS LLM docs: https://zagjs.com/llms.txt

## Provenance

Hard fork of `anubra266/zag-ripple` (MIT, © Abraham Aremu), renamed and
maintained independently. It no longer tracks upstream.
