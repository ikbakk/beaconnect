# ADR-004 — Local Storage Strategy

Status: Frozen

## Decision

Use Drift for structured local cache.

Use lightweight preferences store for simple local settings.

## Local Storage Contains

- latest partner state
- latest self state
- recent updates, 3 days max
- pending safe actions
- user preferences
- onboarding status
- cached pair relationship

## Rules

- Remote confirms shared state.
- Local keeps the app understandable offline.
- Cached data always displays freshness.
- 3-day detailed history cleanup runs automatically.
