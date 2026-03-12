# Domain Models Draft

Draft only.

## Entities

### User

- id
- displayName

### Pair

- id
- memberIds
- status
- createdAt
- endedAt

### PartnerState

- partnerId
- displayName
- status
- placeLabel
- updatedAt
- freshness

### CheckIn

- id
- actorUserId
- pairId
- message
- place
- createdAt

### LiveSharingSession

- id
- actorUserId
- pairId
- status
- reason
- startedAt
- expiresAt
- pausedAt
- endedAt

### UpdateEvent

- id
- type
- actorUserId
- pairId
- humanLabel
- place
- createdAt

## Value Objects

- PairId
- UserId
- DeviceId
- Freshness
- PlaceLabel
- CheckInMessage
- LiveDuration
- PairSymbol

## Enums

- PairStatus
- SharingStatus
- LiveSessionStatus
- UpdateEventType
- PermissionStatus
