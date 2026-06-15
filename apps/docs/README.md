# swift-common docs

[Docusaurus](https://docusaurus.io/) site for [`swift-common`](https://github.com/rtorcato/swift-common) (the `MatrixSwiftBaseCore` / `MatrixSwiftBaseUI` SwiftPM library). Modelled on [`browser-common/apps/docs`](https://github.com/rtorcato/browser-common/tree/main/apps/docs). Deployed to GitHub Pages at `https://rtorcato.github.io/swift-common/` via [`.github/workflows/docs.yml`](../../.github/workflows/docs.yml).

## Develop

```bash
# from repo root
pnpm install
pnpm docs:dev   # or: pnpm --filter @rtorcato/swift-common-docs dev
```

Open <http://localhost:3000/swift-common/>.

## Build locally

```bash
pnpm docs:build
pnpm docs:serve
```

## Structure

```
apps/docs/
├── docs/
│   ├── index.md                # landing page (Core/UI split, install)
│   ├── guides/
│   │   ├── installation.md     # SPM snippet, Xcode add-package
│   │   ├── conventions.md      # target placement, file naming, platform guards
│   │   └── platforms.md        # iOS/macOS/tvOS/watchOS matrix + CI status
│   ├── api/
│   │   ├── core.md             # MatrixSwiftBaseCore overview with code samples
│   │   └── ui.md               # MatrixSwiftBaseUI overview with code samples
│   └── changelog.md            # synced from root CHANGELOG.md (gitignored)
├── src/css/custom.css          # Infima theme overrides (Swift orange)
├── static/img/logo.svg
├── docusaurus.config.ts        # site config, search plugin
├── sidebars.ts                 # Start here / API Reference / Releases
├── tsconfig.json
└── package.json                # @rtorcato/swift-common-docs
```

## Differences from `browser-common`'s docs setup

`browser-common` uses `docusaurus-plugin-typedoc` to auto-generate API pages from TypeScript source. That plugin doesn't apply here — Swift's API reference comes from **DocC** (tracked in issue [#10](https://github.com/rtorcato/swift-common/issues/10)).

The plan is:

1. Docusaurus hosts the **narrative** docs: landing, install, guides, conventions, per-target API overviews with code samples, changelog.
2. DocC hosts the **API reference**: full type signatures, generated from Swift source under `Sources/MatrixSwiftBaseCore/Documentation.docc/` and `Sources/MatrixSwiftBaseUI/Documentation.docc/`.
3. Both publish to the same GitHub Pages domain at different sub-paths (`/` for Docusaurus, `/api/` for DocC) so a single "Docs" link works for everything.

## Deployment

`.github/workflows/docs.yml` builds and publishes on every push to `main` that changes `apps/docs/**`, `scripts/sync-changelog.mjs`, `CHANGELOG.md`, the workflow itself, `pnpm-workspace.yaml`, or root `package.json`.

**First-time setup:** in repo Settings → Pages → Build and deployment → Source, select **GitHub Actions**.

## Changelog sync

`docs/changelog.md` is gitignored and regenerated on every dev/build by `scripts/sync-changelog.mjs` (wired as `predev` / `prebuild` / `prestart` in this package's `package.json`). Until release automation lands ([#6](https://github.com/rtorcato/swift-common/issues/6)), the synced file shows a "no releases recorded yet" placeholder.
