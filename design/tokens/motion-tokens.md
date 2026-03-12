# Motion Tokens

## Philosophy

Meaningful motion only.

## Duration Guidance

Exact values may be adjusted in implementation.

- Fast feedback: 120–180 ms
- Small state transition: 200–250 ms
- Context expansion: 250–350 ms
- Navigation: platform default

## Easing

Use Material-standard easing.

Avoid:

- bounce
- elastic overshoot
- repeated pulse
- decorative loops

## Rule

Never animate the whole screen when one element changed.
