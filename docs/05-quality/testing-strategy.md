# Testing Strategy

## Test Priorities

1. Domain rules
2. Use cases
3. Repository mapping
4. Controller states
5. Widget/component behavior
6. Integration flows

## Must Test

- check-in cooldown
- queued check-in offline
- no false sent state
- pair code expiry
- mutual approval
- local cache display
- stale freshness display
- live sharing duration
- live sharing pause timer continues
- history retention cleanup

## Golden Tests

Recommended for:

- Partner Card states
- Home normal
- Home delayed
- Widget 4×2
- Trust Center section

## Avoid

Do not test implementation details that make refactoring painful.
