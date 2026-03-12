# ADR-010 — Notification Strategy

Status: Frozen

## Decision

Notifications are reserved for meaningful relationship events.

## Notify For

- check-in
- live sharing started/paused/resumed/ended
- request check-in
- trust events
- critical battery threshold if enabled

## Do Not Notify For

- every location update
- every movement
- cache refresh
- sync completed
- widget refresh
- marketing

## Principle

A Beaconnect notification should feel like hearing from someone, not from an application.
