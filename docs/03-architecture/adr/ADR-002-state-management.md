# ADR-002 — State Management Strategy

Status: Frozen

## Decision

Use Riverpod for state management and dependency injection.

## Rules

- Controllers manage presentation state.
- Use cases contain business application logic.
- Domain contains business rules.
- Repositories abstract data access.
- UI never calls Firebase directly.
- Widgets do not contain business logic.

## Rejected

- Bloc
- Cubit
- Provider
- Redux
- ChangeNotifier MVVM
- multiple state management libraries
