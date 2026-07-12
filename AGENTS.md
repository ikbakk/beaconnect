# AGENTS.md

This file guides AI coding agents and contributors working on Beaconnect.

## Prime Directive

> Protect Beaconnect's identity.

Do not optimize for feature count. Optimize for coherence, calmness, privacy, and reliability.

## Before Changing Anything

Ask:

1. Does this increase reassurance?
2. Could this accidentally increase anxiety?
3. Would I want this feature if my partner used it on me?
4. Is the simplest version enough?
5. Does this still feel like Beaconnect?
6. Does this make the relationship more important than the app?
7. Does this introduce technical wording into user-facing UI?
8. Does this require a document update?

## Calm Test

Every screen, notification, and feature must pass:

- Does this reduce anxiety?
- Could this unintentionally create anxiety?
- Does it respect mutual consent?
- Is the wording neutral and non-judgmental?
- Does it avoid assuming human intent?
- Can the user understand why this happened?
- Would this still feel appropriate if it happened 20 times a day?
- Is this the simplest version of the feature?
- Does this still feel like "Built for reassurance, not surveillance"?

## Gravity Test

Every screen has a center of gravity.

For Beaconnect, attention should orbit around:

- Partner
- Relationship
- Reassurance

Not:

- App logo
- Map
- Button
- Navigation
- Technical diagnostics

## Engineering Rules

- Use feature-first Clean Architecture.
- Use Riverpod for state management and dependency injection.
- Domain layer must not import Flutter, Firebase, or Android APIs.
- UI never calls Firebase directly.
- Data layer never owns product wording.
- No duplicate business logic.
- No duplicate UI components.
- No `helpers/`, `utils/`, `managers/`, or `services/` dumping grounds without an ADR.

## User-Facing Language

Avoid:
- GPS
- Sync
- Cache
- Background service
- API
- Permission denied
- Failed
- Offline

Prefer:
- Current place
- Updated
- Showing your most recent update
- Sharing works best when...
- Something did not go as expected
- No new updates yet

## Working with the HTML Prototype

The canonical visual source of truth lives in `design/prototype/`:

```
design/prototype/
  beaconnect-app.html          ← Android UI: all screens, states, interactions
  beaconnect-app-ios.html     ← iOS companion
  beaconnect.css               ← design tokens: colors, spacing, typography, motion
  beaconnect-identity-directions.html  ← logo / wordmark / brand routes
  beaconnect-home-motion-board.html    ← motion behaviors + image direction
  README.md                    ← how to use the prototype
```

### The rule

> The HTML prototype is always right. Flutter must follow.

When the prototype and any documentation disagree, the prototype wins. When the prototype and Flutter code disagree, open an issue first — do not silently choose.

### How to use it

1. **Open `beaconnect-app.html`** in a browser before writing any Flutter UI code
2. Navigate with the nav buttons to see every screen
3. Check different Partner Card states with the "State" buttons
4. On Home: tap "Start Live" to see the live-map-to-top behavior
5. Reference `beaconnect.css` for exact token values (colors, spacing, radius, durations)

### Finding token values

```
design/prototype/beaconnect.css         ← exact CSS values
docs/04-implementation/
  DESIGN_TOKENS_FLUTTER.md              ← CSS → Dart constant conversion
  CSS_TO_FLUTTER.md                    ← CSS pattern → Flutter widget reference
  COMPONENT_MAP.md                     ← HTML component → Flutter widget
  SCREEN_SPEC.md                       ← screen structure, routing, states
  STATE_MANAGEMENT.md                   ← Riverpod provider shapes for all states
```

### When you change the prototype

Any visual or copy change goes into the HTML first, then ported to Flutter:

1. Edit `design/prototype/beaconnect-app.html` (or `beaconnect.css`)
2. Test in browser
3. Port to Flutter using the conversion guides
4. Commit both changes in the same PR

### When Flutter ships something the prototype doesn't show

That's a Flutter bug — not a reason to update the prototype. Update Flutter instead.

### When the prototype shows something Flutter cannot do

Add a `// PLATFORM LIMITATION:` comment in the Flutter code with a link to the issue. Do not silently omit the feature.

### Prohibited shortcuts

- Do not implement UI directly from memory or from old docs without opening the HTML first
- Do not add new CSS classes without adding them to `beaconnect.css`
- Do not add new screens without adding them to `beaconnect-app.html`
- Do not add new states without demonstrating them in the HTML

## Frozen Decisions

Frozen artifacts may only change if:

- User research reveals a real usability issue.
- Accessibility requirements demand change.
- Android platform behavior materially changes.
- The artifact contradicts a higher-level Beaconnect principle.

Personal preference is not enough.
