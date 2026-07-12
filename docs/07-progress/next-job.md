# Next Job

This file tracks what remains after v0.2.x. Items are roughly ordered by priority.

---

## Phase 1 — Cloud Messaging (Notifications)

Cloud Messaging is the last major Firebase service not yet wired.

**What to implement:**
- `FirebaseMessagingService` — request permission, get FCM token, send token to Firestore (`users/{userId}/fcmToken`)
- `NotificationPayload` domain model
- `SendPushNotificationUseCase` — triggered by Firestore write (pair-shared collections)
- Notification tap deep-links back into the app (`beaconnect://...`)
- Handle foreground vs. background notification display
- Update `firestore.rules` to allow writing to `users/{userId}/fcnToken`

**User-facing strings (follow wording guidelines):**
- Partner checked in: "{name} is around."
- Check-in request: "{name} is checking in — are you okay?"
- Live sharing started: "{name} started Live Sharing."
- Permission prompt: allow push notifications

**Docs to update:**
- `docs/03-architecture/adr/ADR-010-notifications.md` (freeze as implemented)
- `docs/04-implementation/firestore-draft-schema.md` (add `users/{userId}/fcmToken`)
- `firestore.rules`

**Commit:** `feat(notifications): send and receive push notifications`

---

## Phase 2 — Cloud Functions

Three Cloud Functions are needed for backend logic that the client cannot perform safely.

### 2a — Invite Code TTL Expiry

Auto-expire invite codes after 5 minutes.

- Firestore function triggered on `inviteCodes/{codeId}`
- On create: schedule a delete 5 minutes later
- Delete: remove the document from Firestore
- Client no longer needs to manually handle expiry

**Commit:** `feat(pairing): auto-expire invite codes after 5 minutes`

### 2b — History Retention (3 days)

Clean up update events older than 3 days.

- Scheduled function (runs daily at 03:00 UTC)
- Query `pairs/{pairId}/events` where `createdAt < now - 3 days`
- Batch delete in chunks of 500
- Log deletion count

**Commit:** `feat(retention): clean up update events older than 3 days`

### 2c — Shared Deletion Mutual Approval

Both partners must approve before pair data is deleted.

- Firestore function triggered on `pairs/{pairId}/deletionRequests/{requestId}`
- On create: set `status: 'pending'`, `firstRequestedAt`
- On update: if both partners have `approved: true`, hard-delete pair + all sub-collections
- If only one approved after 7 days, auto-reject and notify requester

**Commit:** `feat(pairing): require both partners to approve pair deletion`

---

## Phase 3 — Release Readiness

### SHA-1 fingerprints
- Add debug SHA-1 to Firebase Console
- Add release SHA-1 to Firebase Console
- Update `docs/04-implementation/firebase-credentials.md`

### Release signing
- Create `key.properties` (local, not committed)
- Configure Gradle to read keystore for release builds
- Store signing config in CI secrets (do not commit keystore)

### Environment separation
- `lib/core/config/app_config.dart` already has `environment` enum: `debug`, `staging`, `prod`
- Map Firestore instances to environments
- Map Firebase project IDs to environments
- CI workflow gates builds by environment

### CI/CD
- Add staging build on PR merge to `staging` branch
- Add production build on tag `v*` to `main` branch
- App Distribution: configure `staging` and `prod` apps

### Version bump
- Current: `0.2.0+2`
- Next: `0.3.0+1` (or `1.0.0-beta.1` if ready for public beta)

### Debug logs audit
- Search codebase for `print()`, `debugPrint()`, `log()` calls
- Remove or guard with `kDebugMode`
- Ensure no PII or pair data in logs

---

## Phase 4 — Offline Hardening

### Queued check-in (offline)
- `CheckInRepository` already has local fallback
- Add outbound queue: when offline, write to local queue
- On reconnect, flush queue via `FirebaseCheckInRepository`
- Show "Will send when connected" instead of "Sent"

### Stale freshness display
- `PlaceSnapshot.freshness` is already computed in domain
- Home screen and widget should show "Last updated {relative time}" when stale
- Threshold: > 30 minutes without update → show "A while ago" style message

### App recovery after process kill
- `bootstrap.dart` already restores local session from `SharedPreferences`
- Verify onboarding flow restores correctly when app is killed mid-pairing
- Add test for cold-start → onboarding → pairing → home

### Widget shows cached state
- `home_widget` plugin persists last written data
- Android provider already reads `HomeWidgetPlugin.getData()`
- Verify widget survives app kill and shows last known state

---

## Phase 5 — Testing

### Golden / screenshot tests
- Partner Card
- Home screen (all variants: no partner, pending, active, delayed)
- Widget
- Trust Center
- Onboarding flow (each step)

### Unit tests
- `ConfirmPairingUseCase`
- `FirebaseLiveSharingRepository`
- `FirebaseRequestCheckInRepository`

### Integration tests
- Pairing → mutual approval → home flow
- Check-in → notification on partner device

---

## Phase 6 — Manual QA (device required)

Run on a real Android device or emulator.

- [ ] App opens offline with cached state
- [ ] Home shows no spinner after first sync
- [ ] Check-in shows no spinner until confirmed
- [ ] Offline check-in queues safely
- [ ] Live Sharing cannot start offline
- [ ] Invite code expires after 5 minutes
- [ ] Both users must approve pair
- [ ] No technical jargon or raw error messages in UI
- [ ] Delayed state is calm (no panic wording)
- [ ] Trust Center explains before action
- [ ] Widget shows cached state after app kill
- [ ] Background behavior does not drain battery aggressively
- [ ] Foreground service only used during Live Sharing

---

## Phase 7 — Portfolio / Polish

- Screenshots (all screens in dark + light)
- Case study (product, users, design decisions)
- Architecture diagrams (system overview, data flow)
- Demo video (60s walkthrough)
- `SECURITY.md` (responsible disclosure)
- Public repo cleanup (remove debug artifacts, test stubs)

---

## Deprecated Docs to Remove

When starting Phase 7, remove these fully-superseded docs:

```
docs/04-implementation/domain-models-draft.md    ← implemented in real code
docs/04-implementation/repository-structure.md   ← diverged from actual structure
docs/04-implementation/state-management-patterns.md ← patterns in AGENTS.md + code
docs/04-implementation/vertical-slices.md        ← all slices done
docs/06-release/changelog-template.md           ← real CHANGELOG.md at repo root
docs/templates/                                  ← not actively used
```
