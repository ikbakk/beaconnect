# ADR-006 — Authentication Strategy

Status: Frozen

## Decision

Use Firebase Auth.

## Providers

- Email + password
- Google Sign-In

## Rules

- Pairing is account-based, not device-based.
- Display name required.
- No profile photo in v1.
- No anonymous-only accounts in v1.
- No phone auth initially.
- One active pair in v1.
