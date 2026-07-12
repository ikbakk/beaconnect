# Firestore Draft Schema

This is a draft for implementation, not a frozen ADR.

## Collections

```text
users/{userId}
pairs/{pairId}
pairs/{pairId}/members/{userId}
pairs/{pairId}/events/{eventId}
pairs/{pairId}/liveSessions/{sessionId}
pairs/{pairId}/checkInRequests/{requestId}
inviteCodes/{code}
devices/{deviceId}
```

## users/{userId}

```json
{
  "displayName": "Iqbal",
  "createdAt": "serverTimestamp",
  "activePairId": "pair_123"
}
```

## pairs/{pairId}

```json
{
  "status": "confirmed",
  "memberIds": ["userA", "userB"],
  "createdAt": "serverTimestamp",
  "endedAt": null
}
```

## events/{eventId}

```json
{
  "type": "check_in",
  "actorUserId": "userA",
  "createdAt": "serverTimestamp",
  "placeLabel": "Home",
  "messageTemplateId": "around_01"
}
```

## liveSessions/{sessionId}

```json
{
  "actorUserId": "userA",
  "status": "active",
  "reason": "going_home",
  "startedAt": "serverTimestamp",
  "expiresAt": "timestamp",
  "pausedAt": null,
  "endedAt": null
}
```

## checkInRequests/{requestId}

```json
{
  "actorUserId": "userA",
  "actorDisplayName": "Iqbal",
  "targetUserId": "userB",
  "status": "pending",
  "response": null,
  "createdAt": "serverTimestamp",
  "respondedAt": null
}
```

## inviteCodes/{code}

```json
{
  "createdBy": "userA",
  "status": "pending",
  "expiresAt": "timestamp",
  "usedBy": null
}
```

## Notes

Use server timestamps for trust-sensitive ordering.

Append events where possible.

Avoid mutable history.
