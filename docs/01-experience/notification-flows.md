# Notification Flows

## Principle

A Beaconnect notification should feel like hearing from someone, not from an application.

## Notify For

- check-ins
- live sharing started
- live sharing paused
- live sharing resumed
- live sharing ended
- request check-in
- pairing accepted
- sharing paused/resumed
- history deletion approved
- critical battery threshold if enabled

## Do Not Notify For

- every GPS update
- every movement
- cache refresh
- sync completed
- widget refresh
- app opened
- background task finished
- marketing
- feature announcements

## Request Check-in

```text
Sarah requested a check-in.

[I'm Okay] [Later]
```

Avoid:

```text
Sarah is tracking you.
Sarah needs your location.
```

## Check-in Received

```text
Sarah checked in to let you know they are around.
```

## Grouping

Events within 1–5 minutes may be grouped into one story.

Example:

```text
You both checked in around the same time.
```

## Quiet Hours

Respect:

- Android notification settings
- Beaconnect Quiet Hours

Only trust-critical events may bypass according to user preference.
