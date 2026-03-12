# ADR-007 — Pairing Strategy

Status: Frozen

## Decision

Use short-lived invite codes with mutual confirmation.

## Flow

```text
User A creates invite code
→ User B enters invite code
→ Both users see name confirmation
→ Both approve
→ Pair is created
```

## Rules

- one-to-one pair only in v1
- invite code is one-time use
- invite code expires after 5 minutes
- both sides approve
- either side can cancel
- pair survives device changes

## Pair States

- pending
- confirmed
- cancelled
- expired
- ended
