# App Shell v1.0

Status: Frozen

## Purpose

The App Shell exists to make navigation disappear.

Users should think:

> Sarah.

Not:

> Where is Home?

## Navigation

Exactly three destinations:

```text
Home
Updates
Settings
```

No:

- Map tab
- Live tab
- Profile tab
- Account tab

Those are states or sections, not destinations.

## Home

No app bar.

No logo.

No greeting.

The Partner Card begins the experience.

## Updates and Settings

May use lightweight headers.

## Bottom Navigation

- Always visible.
- Never hides on scroll.
- Labels always visible.
- No badge counts.
- Inactive icons outlined.
- Active icons filled.

## Background

Flat Material surface.

No gradients.

No texture.

No decorative background.

## Loading

First launch may use skeletons.

After first sync:

- show last known state,
- refresh quietly,
- no full-screen spinner.

## Offline

Prefer:

```text
Showing your most recent updates.
We'll refresh when you're connected again.
```

Avoid:

```text
No internet.
```

## Dialogs

Rare.

Prefer:

- bottom sheets
- inline cards
- toasts

## App Shell Rules

1. Relationship is visual anchor.
2. Navigation is never the visual anchor.
3. Motion explains change.
4. Background stays quiet.
5. One screen means one primary action.
6. Never navigate unexpectedly.
7. Never interrupt unless necessary.
