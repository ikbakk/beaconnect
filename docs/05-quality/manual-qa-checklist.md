# Manual QA Checklist

## Core

- [ ] App opens offline with cached state
- [ ] Home shows no spinner after first sync
- [ ] Check-in does not show sent until confirmed
- [ ] Offline check-in queues safely
- [ ] Live Sharing cannot start offline
- [ ] Invite code expires after 5 minutes
- [ ] Both users must approve pair

## UX

- [ ] No technical jargon appears
- [ ] No raw error messages
- [ ] Delayed state is calm
- [ ] Trust Center explains before action
- [ ] Widget is 4×2 and non-dashboard

## Android

- [ ] App recovers after process kill
- [ ] Widget shows cached state
- [ ] Background behavior does not drain battery aggressively
- [ ] Foreground service only used for Live Sharing
