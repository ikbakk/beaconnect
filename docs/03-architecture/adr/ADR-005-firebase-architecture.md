# ADR-005 — Firebase Architecture

Status: Frozen

## Decision

Use Firebase as v1 backend.

## Services

- Firebase Auth
- Firestore
- Firebase Cloud Messaging
- Firebase Crashlytics
- Firebase App Distribution
- Firebase Remote Config

## Not Initially Used

- Cloud Functions
- Firebase Storage
- Firebase Analytics

## Firestore Role

Remote source of truth for:

- pair relationship
- latest shared state
- check-ins
- live sharing sessions
- updates/events
- trust-related changes

## Rule

No Firebase calls from UI.
