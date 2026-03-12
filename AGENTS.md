# AGENTS.md

This file guides AI coding agents and contributors working on Beaconnect.

## Prime Directive

> Protect Beaconnect's identity.

Do not optimize for feature count. Optimize for coherence, calmness, privacy, and reliability.

## Before Changing Anything

Ask:

1. Does this increase reassurance?
2. Could this accidentally increase anxiety?
3. Would I want this feature if my partner used it on me?
4. Is the simplest version enough?
5. Does this still feel like Beaconnect?
6. Does this make the relationship more important than the app?
7. Does this introduce technical wording into user-facing UI?
8. Does this require a document update?

## Calm Test

Every screen, notification, and feature must pass:

- Does this reduce anxiety?
- Could this unintentionally create anxiety?
- Does it respect mutual consent?
- Is the wording neutral and non-judgmental?
- Does it avoid assuming human intent?
- Can the user understand why this happened?
- Would this still feel appropriate if it happened 20 times a day?
- Is this the simplest version of the feature?
- Does this still feel like "Built for reassurance, not surveillance"?

## Gravity Test

Every screen has a center of gravity.

For Beaconnect, attention should orbit around:

- Partner
- Relationship
- Reassurance

Not:

- App logo
- Map
- Button
- Navigation
- Technical diagnostics

## Engineering Rules

- Use feature-first Clean Architecture.
- Use Riverpod for state management and dependency injection.
- Domain layer must not import Flutter, Firebase, or Android APIs.
- UI never calls Firebase directly.
- Data layer never owns product wording.
- No duplicate business logic.
- No duplicate UI components.
- No `helpers/`, `utils/`, `managers/`, or `services/` dumping grounds without an ADR.

## User-Facing Language

Avoid:
- GPS
- Sync
- Cache
- Background service
- API
- Permission denied
- Failed
- Offline

Prefer:
- Current place
- Updated
- Showing your most recent update
- Sharing works best when...
- Something did not go as expected
- No new updates yet

## Frozen Decisions

Frozen artifacts may only change if:

- User research reveals a real usability issue.
- Accessibility requirements demand change.
- Android platform behavior materially changes.
- The artifact contradicts a higher-level Beaconnect principle.

Personal preference is not enough.
