# ADR-009 — Background Execution Strategy

Status: Frozen

## Decision

Beaconnect cooperates with Android.

It never fights Android.

## Execution Modes

- foreground
- background
- stopped

## Rules

- Do not keep app alive 24/7.
- Do not use hidden foreground services.
- Do not use keepalive loops.
- Do not fight Doze.
- Recover automatically after process death.
- Communicate freshness honestly.

## Principle

Reliability comes from designing with Android, not against Android.
