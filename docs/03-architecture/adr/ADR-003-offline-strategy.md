# ADR-003 — Offline Strategy

Status: Frozen

## Decision

Beaconnect is offline-tolerant, not fully offline-first.

## Behavior

- Always open.
- Show last known trustworthy state.
- Display freshness honestly.
- Queue safe actions carefully.
- Do not pretend offline actions succeeded.

## Safe to Queue

- check-in
- request check-in
- reaction
- preference changes

## Not Queued

- start live sharing
- end live sharing
- relationship deletion
- permission-dependent actions

## Rule

Never hide stale data.
