# Firebase Rules Notes

Current repository scaffold includes `firestore.rules` as a starting point.

Intent:

- users only read/write their own user document
- pairs are visible only to pair members
- events are visible only to pair members
- live sharing records are visible only to pair members
- invite codes are created by the user who made them
- invite code updates are limited to the creator or the user consuming the code

Before production use, verify rules against the final Firestore document shapes and transaction flow.
