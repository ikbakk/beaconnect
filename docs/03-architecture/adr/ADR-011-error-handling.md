# ADR-011 — Error Handling Strategy

Status: Frozen

## Decision

Errors belong to engineers. Recovery belongs to users.

## Categories

1. Silent recovery
2. Actionable
3. Blocking
4. Internal

## Rule

Never expose implementation details.

User sees what Beaconnect is doing next.

## Principle

Users should remember that Beaconnect recovered, not that it failed.
