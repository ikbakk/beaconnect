# ADR-001 — Repository & Module Structure

Status: Frozen

## Decision

Use feature-first Clean Architecture.

## Structure

```text
lib/
├── app/
├── core/
├── design/
├── features/
└── l10n/
```

## Feature Structure

```text
feature/
├── presentation/
├── application/
├── domain/
└── data/
```

## Rules

- Domain is platform-independent.
- Design system is first-class.
- Infrastructure lives in core.
- No duplicate business logic.
- No duplicate UI components.
- Optimize for developer navigation.

## Find in 30 Seconds Rule

A developer should find where to implement a change within 30 seconds.
