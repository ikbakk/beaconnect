# Roadmap

## Milestones

| Milestone | Name | Status |
|---|---|---|
| M0 | Finding Beaconnect / Product Discovery | Frozen |
| M1 | Experience Design | Frozen |
| M2 | Interface Design | Frozen |
| M3 | Technical Architecture | Frozen |
| M4 | Engineering Execution | Done |
| M5 | Vertical Slice | Done |
| M6 | Internal Alpha | Frozen (Done) |
| M7 | Closed Beta | Next |
| M8 | Portfolio Release | Planned |
| M9 | Public Open Source | Planned |

## M4 Engineering Execution

Build foundation:

- Flutter project ✅
- Firebase project ✅
- CI checks ✅
- design system skeleton ✅
- Riverpod setup ✅
- feature-first folder structure ✅

## M5 Vertical Slice

First working slice:

```text
Auth ✅
→ Pairing ✅
→ Home ✅
→ I'm Okay ✅
→ Partner notification ✅
→ Updates entry ✅
```

Extended through slices 2–7 in local-first and Firebase-backed form.

## M6 Internal Alpha

Add:

- real location snapshots ✅
- battery saver update mode ✅
- widget ✅
- trust center ✅
- local cache ✅
- onboarding ✅
- Crashlytics integration ✅
- Android home-screen widget ✅
- accessibility pass (Semantics + reduced motion) ✅
- Firestore rules hardened ✅
- mutual approval pairing ✅
- real check-in from Android widget ✅

**Frozen.** Next: see `docs/07-progress/next-job.md`.

## M7 Closed Beta

Add:

- live sharing ✅ (mostly — pair-shared sync done, notification on start not yet)
- polish ✅ (recovery, empty states, a11y)
- app distribution (Firebase App Distribution to be configured)
- Cloud Messaging (push notifications)
- Cloud Functions (invite expiry TTL, history retention, shared deletion)
- release signing (debug + release SHA-1, keystore)
- offline hardening (queued check-in, stale freshness display)
- feedback flow

## M8 Portfolio Release

Prepare:

- README ✅
- screenshots
- case study
- architecture diagrams
- demo video
- public repo cleanup

## M9 Public Open Source

Add:

- contribution guide
- issue templates
- security policy
- changelog
- release documentation
