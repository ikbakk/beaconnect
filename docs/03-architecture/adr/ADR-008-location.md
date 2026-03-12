# ADR-008 — Location Strategy

Status: Frozen

## Decision

Use three location modes:

1. Battery Saver
2. Live Sharing
3. Manual Snapshot

## Battery Saver

Default background behavior.

No constant GPS polling.

## Live Sharing

Temporary, intentional, foreground-driven.

Requires duration and connection.

## Manual Snapshot

Used for:

- I'm Okay
- Request Check-in response
- Share Now

## Rule

Never promise perfect background updates.

Always show freshness.
