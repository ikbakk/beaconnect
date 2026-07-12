# Flutter Bridge Guide

**Status:** Active

**Source of truth:** `design/prototype/beaconnect-app.html` and `design/prototype/beaconnect.css`

---

## The rule

> The HTML prototype is always right. Flutter must follow.

When the prototype and this documentation disagree, the prototype wins. When the prototype and existing Flutter code disagree, open an issue first — do not silently choose.

---

## Workflow

### Step 1 — Look at the prototype first

Open `design/prototype/beaconnect-app.html` in a browser. Every visual question has an answer there.

### Step 2 — Find the token value

`beaconnect.css` has exact values for every token. Convert using `DESIGN_TOKENS_FLUTTER.md`.

### Step 3 — Find the component spec

`design/components/` and `docs/02-interface/` have screen-level specs. Flutter widgets must match these structures.

### Step 4 — Implement in Flutter

Use `COMPONENT_MAP.md` to find the equivalent Flutter Widget. Use `SCREEN_SPEC.md` for routing and state wiring.

### Step 5 — Don't skip the prototype

Do not implement directly from memory or from old docs. Always open the HTML first.

---

## What the prototype has that docs don't

- Exact pixel spacing between elements
- Exact border-radius values per component
- Exact color hex/oklch values (not just roles)
- Exact motion durations and easing curves
- Working pill-nav behavior
- Live-state map-to-top layout
- All 7 Partner Card states rendered and switchable
- Android and iOS device frames
- Identity directions with logo concepts

---

## Directory structure this enables

```
design/
  prototype/
    beaconnect.css                    ← tokens source
    beaconnect-app.html               ← Android prototype
    beaconnect-app-ios.html          ← iOS prototype
    beaconnect-identity-directions.html
    beaconnect-home-motion-board.html
  tokens/
    design-tokens.md                  ← updated from CSS
    color-roles.md                   ← updated from CSS
    motion-tokens.md                 ← updated from CSS
  components/
    partner-card.md
    check-in-button.md
    ...
docs/
  04-implementation/
    FLUTTER_BRIDGE.md                ← you are here
    DESIGN_TOKENS_FLUTTER.md
    CSS_TO_FLUTTER.md
    COMPONENT_MAP.md
    STATE_MANAGEMENT.md
    SCREEN_SPEC.md
    ASSET_GUIDE.md
```

---

## When to update the prototype

- Any visual change goes into the HTML first
- Any new state or copy change goes into the HTML
- The prototype is the single source of truth for anything visual

When you update the prototype, commit it alongside the Flutter change in the same PR.

---

## Reporting drift

If Flutter shipped something the prototype doesn't show, that's a bug in Flutter — not a reason to update the prototype.

If the prototype shows something Flutter genuinely cannot do (platform limitation), document it in the Flutter code with a `// PLATFORM_LIMITATION:` comment and link to the issue.
