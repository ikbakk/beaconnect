# State Management Patterns

Use Riverpod.

## Controller Pattern

A controller owns presentation state.

Example:

```text
CheckInController
```

States:

- idle
- sending
- success
- cooldown
- error

## Use Case Pattern

Use case handles application action.

Example:

```text
SendCheckInUseCase
```

Responsibilities:

- validate cooldown
- create check-in intent
- call repository
- return result

## Repository Pattern

Domain repository interface:

```text
CheckInRepository
```

Data implementation:

```text
FirebaseCheckInRepository
```

## Rule

Riverpod wires dependencies.

Riverpod does not replace the domain/application layers.
