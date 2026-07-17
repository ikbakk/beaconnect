# ADR-010 — Notification Strategy

Status: Implemented

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

## Implementation

- Firebase Cloud Messaging is initialized after Firebase startup for the signed-in user.
- The current token is stored at `users/{userId}/fcmToken` with `fcmTokenUpdatedAt`.
- Foreground messages are exposed as domain payloads for calm in-app presentation.
- Background and notification-tap delivery use Firebase Messaging handlers.
