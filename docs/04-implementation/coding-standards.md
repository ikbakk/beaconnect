# Coding Standards

## General

- Prefer small files.
- Prefer explicit names.
- Avoid generic helpers.
- Do not duplicate logic.
- Do not duplicate copy.
- Do not put business logic in widgets.

## Naming

Use product language:

- check_in
- live_sharing
- trust_center
- my_beacon
- updates

Avoid generic names:

- manager
- helper
- util
- service

unless justified by ADR.

## Layers

Presentation:

- widgets
- controllers
- UI state

Application:

- use cases
- orchestration

Domain:

- entities
- value objects
- repository interfaces
- rules

Data:

- DTOs
- repository implementations
- local and remote data sources

## Imports

Domain must not import:

- Flutter
- Firebase
- Android APIs
- Riverpod

## Comments

Comment why, not what.

## Copy

User-facing copy should come from wording resources, not scattered strings.
