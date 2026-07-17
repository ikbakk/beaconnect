# Beaconnect

Beaconnect is a reassurance-first companion app that helps two people quietly stay present in each other's lives through intentional, mutual sharing.

> Built for reassurance, not surveillance.

This repository is intentionally documentation-first. The goal is to preserve the product philosophy, experience design, interface contracts, and technical architecture before implementation begins.

## Current Status

| Milestone | Name | Status |
|---|---|---|
| M0 | Product Discovery | Frozen |
| M1 | Experience Design | Frozen |
| M2 | Interface Design | Frozen |
| M3 | Technical Architecture | Frozen |
| M4 | Engineering Execution | Done |
| M5 | Vertical Slice | Done |
| M6 | Internal Alpha | In Progress |

## Scaffold Status

All seven vertical slices are implemented and functional.

- Slice 1 — First Reassurance ✅
- Slice 2 — Real Place Snapshot ✅
- Slice 3 — Widget preview ✅
- Slice 4 — Battery Saver Mode ✅
- Slice 5 — Live Sharing ✅
- Slice 6 — Trust Center + My Beacon ✅
- Slice 7 — Polish ✅

Hardenings completed:

- real Firebase credentials and generated options ✅
- production-grade Firebase transactions and rules ✅
- platform widget plumbing ✅
- release/distribution setup ⚠ in progress

## North Star

> Help people feel connected without making them feel watched.

## Developer Motto

> Never create anxiety to solve anxiety.

## Core Product Rule

> The app is not the main character. The relationship is.

## Repository Layout

```text
docs/
  00-product/
  01-experience/
  02-interface/
  03-architecture/
  04-implementation/
  05-quality/
  06-release/
  templates/

design/
  components/
  screens/
  tokens/
```

## Start Here

Read in this order:

1. `docs/00-product/manifesto.md`
2. `docs/00-product/non-goals.md`
3. `docs/01-experience/design-review-framework.md`
4. `docs/02-interface/design.md`
5. `docs/03-architecture/adr/ADR-000-product-promises.md`
6. `AGENTS.md`

## Implementation Rule

Do not start implementation by adding features. Start with the first vertical slice:

```text
Auth
→ Pairing
→ Home cached shell
→ I'm Okay
→ Notification
```

## Firebase Config

When real Firebase credentials are ready, replace the placeholders with:

- `android/app/google-services.json`
- `lib/firebase_options.dart`

Reference:

- `docs/04-implementation/firebase-credentials.md`

## One-Phone Pairing Test

Use `tools/pairing-companion/` to act as the second partner while testing the real pairing flow with one Android phone. See its README for the local server command and test steps.
