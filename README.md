<div align="center">

  <h1>
    <br />
    ripple-zag
    <br />
    <br />
  </h1>
  <sup>
    Ripple/TSRX adapter for Zag JS state machines
  </sup>
  <br />
  <br />
  <pre>bun add github:ethan-huo/ripple-zag#v0.2.0</pre>
  <br />
</div>

## Install

```bash
bun add github:ethan-huo/ripple-zag#v0.2.0
```

Each release tag is a package snapshot whose repository root is installable as
`ripple-zag`. Use the latest `vX.Y.Z` tag from GitHub when adding the dependency.
This package is not published to npm.

## Usage

```ts
import { useMachine, normalizeProps } from "ripple-zag"
```

`useMachine` binds a `@zag-js/*` machine to Ripple's reactivity;
`normalizeProps` maps Zag's prop objects onto Ripple/TSRX attributes.

## Peer dependencies

- `ripple >= 0.3.0`

## Demo

Component demos live in the [`ripple-explore`](https://github.com/ethan-huo/ripple-explore)
showcase.

## Provenance

Hard fork of [`anubra266/zag-ripple`](https://github.com/anubra266/zag-ripple)
(MIT, © Abraham Aremu). Renamed to `ripple-zag` and maintained independently for
our own Ripple/TSRX projects; it no longer tracks upstream.

## Releasing

See [PUBLISHING.md](./PUBLISHING.md). Bump `package.json#version`, push to
`main`, and CI tags `v${version}`.
