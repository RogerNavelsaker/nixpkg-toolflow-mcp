# nixpkg-toolflow-mcp

Thin Nix and Flox packaging repo for the [`toolflow-mcp`](https://github.com/RogerNavelsaker/toolflow-mcp) Bun MCP server.

This repo owns reproducible packaging only:

- pins the upstream `RogerNavelsaker/toolflow-mcp` source
- keeps `bun.lock` and `bun.nix` aligned with the pinned upstream revision
- builds the Bun server with `bun2nix`
- exposes the canonical binary `toolflow`

## Files

- `flake.nix`
- `flake.lock`
- `bun.lock`
- `bun.nix`
- `nix/package-manifest.json`
- `nix/package.nix`
- `scripts/sync-from-upstream.sh`
- `.github/workflows/build.yml`
- `.github/workflows/release.yml`
- `.github/workflows/sync-upstream.yml`

## Direction

The source of truth for this repo is the `toolflow-mcp` GitHub release stream. Syncing a new release means:

- updating the pinned tag and revision
- copying the upstream `bun.lock`
- regenerating `bun.nix`
- pinning the GitHub source archive hash in `nix/package-manifest.json`

Until the upstream repo starts publishing tags, this repo is pinned to the current upstream commit.

