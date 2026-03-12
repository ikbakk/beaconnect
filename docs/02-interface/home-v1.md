# Home v1.0

Status: Frozen

## Purpose

Home reassures the user about their partner's current state in under three seconds.

## Questions Answered

1. How are they?
2. Is this information recent?
3. Do I need to do anything?
4. What happened recently?

## Layout

```text
Partner Card
↓
I'm Okay
↓
Quick Actions
↓
Recent Updates
↓
Map Preview
```

## Partner Card

Contains only:

```text
Sarah ⭐

Everything looks normal.

Updated 2 minutes ago at Home.
```

No:

- battery unless critical
- GPS
- online indicator
- weather
- technical status

## Primary Action

```text
I'm Okay
```

- centered
- not full width
- gently prominent
- one tap

## Quick Actions

Exactly two:

```text
Request Check-in
Start Live
```

Equal weight.

Secondary style.

## Recent Updates

Show latest two.

Then:

```text
View all updates →
```

## Map Preview

- secondary
- no map first
- tap to expand
- no empty map

## Motion

Only:

1. Partner state changes.
2. Button press.
3. Map expand.
4. Update refresh.
5. Live transition.

## Loading

Show last known state first.

No spinner.

## Accessibility

- text does not truncate at larger font sizes
- Partner Card can grow vertically
- Map moves lower
- content scrolls

## Frozen Policy

Home changes require user testing, accessibility need, platform change, or contradiction with higher principles.
