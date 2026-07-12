# HTML Prototype

**This directory is the canonical visual source of truth for Beaconnect.**

The Flutter app must match this prototype, not the other way around. When in doubt, open these files in a browser first.

## Files

| File | Purpose |
|---|---|
| `beaconnect.css` | Design tokens: colors, spacing, typography, radius, shadows, motion |
| `beaconnect-app.html` | Android app prototype: all 7 screens, pill nav, live-map behavior |
| `beaconnect-app-ios.html` | iOS app prototype: same screens in iPhone frame |
| `beaconnect-identity-directions.html` | 3 brand identity routes: wordmark, symbol, lockup, palette |
| `beaconnect-home-motion-board.html` | Home screen image direction + motion behavior spec |

## How to use

1. Open `beaconnect-app.html` in a browser
2. Use the nav buttons to navigate between screens
3. The pill nav is the active design (not a bar)
4. Home → tap "Start Live" to see the live map-to-top behavior
5. Check different states via the "State" buttons at the bottom of each screen
6. Reference `beaconnect.css` for exact token values

## Color system

The prototype uses CSS custom properties (not hardcoded hex):

```
--bcg-bg          Background surface
--bcg-surface     Card/sheet surface
--bcg-fg          Primary text
--bcg-muted       Secondary/meta text
--bcg-border      Dividers and outlines
--bcg-accent      Primary brand action (warm terracotta)
--bcg-success     Success / normal state (sage green)
--bcg-critical    Critical / urgent (amber)
--bcg-live        Live sharing accent
```

## How it differs from prior docs

The prototype is newer and overrides the following older files when they conflict:

- `design/tokens/design-tokens.md` — tokens now have exact pixel values from CSS
- `design/tokens/color-roles.md` — colors now have exact hex/oklch values
- `design/tokens/motion-tokens.md` — durations now have exact ms values
- `design/components/partner-card.md` — Live state copy updated
- `docs/02-interface/home-v1.md` — pill nav, live-map behavior, hero map
- `docs/01-experience/screen-states.md` — Permission Missing and No Partner copy updated
- `docs/01-experience/interaction-language.md` — `toggleLive` behavior added

Report conflicts by opening an issue. Do not silently choose one over the other.

## Keeping Flutter in sync

When you make visual changes in Flutter:

1. Update the HTML prototype first (`beaconnect-app.html`)
2. Test in browser
3. Then port to Flutter using `DESIGN_TOKENS_FLUTTER.md`
4. Do not skip step 1-2

See `../../docs/04-implementation/FLUTTER_BRIDGE.md` for the full workflow.
