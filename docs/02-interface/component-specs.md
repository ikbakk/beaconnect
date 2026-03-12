# Component Specs

## Component 001 — Partner Card

Purpose:

> Emotional center of Beaconnect.

Contains:

- partner name
- pair symbol
- current status
- freshness sentence
- primary action area if used in Home context

Rule:

> Partner Card may gain states, but not new sections.

## Component 002 — Check-in Button

Purpose:

> Express presence in one tap.

Label:

```text
I'm Okay
```

Behavior:

- press feedback
- no spinner
- no confetti
- no permanent sent state
- cooldown with toast

## Component 003 — Quick Action Button

Used for:

- Request Check-in
- Start Live

Secondary visual style.

Never competes with I'm Okay.

## Component 004 — Update Item

Human-readable story.

No raw technical event.

## Component 005 — Trust Section

Pattern:

```text
Title
Explanation
Status
Action
```

## Component 006 — Widget Card

4×2 compact Partner Card derivative.

One action maximum.
