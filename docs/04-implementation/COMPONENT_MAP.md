# Component Map — HTML → Flutter

**Source:** `design/prototype/beaconnect-app.html` and `design/prototype/beaconnect.css`

Each HTML/CSS component and its Flutter widget equivalent.

---

## Global scaffold

| HTML | Flutter |
|---|---|
| `.bcg-frame` | `Container` with fixed 430×932 frame, `BorderRadius.circular(40)` |
| `.bcg-status-bar` | `SafeArea` + `MediaQuery.of(context).padding.top` |
| `.bcg-content` | `SingleChildScrollView` + `Padding` |
| `.bcg-content.has-nav` | Same + `MediaQuery.of(context).padding.bottom` for nav clearance |
| `.bcg-nav` | `Container` at bottom with `SafeArea` padding |

---

## Partner Card

**CSS:** `.partner-card` → flat card, 1px border, 26px radius, 18px padding

**States (all 7):** `normal`, `live`, `paused`, `no-updates`, `permission-missing`, `no-partner`, `connection-ended`

**Structure:**
```
Name + Pair Symbol (row)
Status sentence (heading)
Freshness sentence (meta)
```

**Flutter:**
```dart
class PartnerCard extends StatelessWidget {
  final PartnerCardState state;  // enum of 7 states
  final String partnerName;
  final PairSymbol pairSymbol;

  // renders correct copy + badge per state
}
```

**Do:**
- Same layout for all states — only copy changes
- Pair symbol is always shown (except `no-partner` state)
- Partner name uses `displayFont` at 28px / -0.03em
- Status uses `displayFont` at 24px / -0.02em
- Freshness uses `monoFont` at 13px

**Don't:**
- Add battery indicators
- Add technical status text
- Change layout between states
- Show partner name when `no-partner` state

**States reference:** `design/components/partner-card.md` and `docs/01-experience/screen-states.md`

---

## I'm Okay Button

**CSS:** `.primary-cta` → `bcgPrimary` fill, 26px radius, 18px padding, 18px/600

**States:** idle → pressed → sending → success → cooldown

**Visual:** `AnimatedScale(0.985)` on press + ripple → "Sarah now knows you're around." toast

**Flutter:**
```dart
class OkayButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final OkayButtonState state;  // idle | sending | success | cooldown

  String get label => switch (state) {
    OkState.idle     => "I'm Okay",
    OkState.sending  => "Sending…",
    OkState.success  => "Done",
    OkState.cooldown => "You recently checked in.",
  };
}
```

**Press interaction (120ms):**
```dart
GestureDetector(
  onTapDown:  (_) => setState(() => _isPressed = true),
  onTapUp:    (_) => _handleTap(),
  onTapCancel: ()  => setState(() => _isPressed = false),
  child: AnimatedScale(
    scale: _isPressed ? 0.985 : 1.0,
    duration: const Duration(milliseconds: 120),
    curve: Curves.easeOut,
    child: Container(
      decoration: BoxDecoration(
        color: bcgPrimary,
        borderRadius: BorderRadius.circular(bcgRadiusLg + 2),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      child: Text(label, style: okayButtonTextStyle),
    ),
  ),
)
```

**Do:**
- One tap, no multi-step confirmation
- Haptic feedback on success
- Cooldown toast without error styling
- Return to idle state after cooldown

**Don't:**
- Show confetti or checkmark animation
- Keep "sending" state longer than needed
- Show sent state permanently
- Add streaks or counters

---

## Quick Action Buttons

**CSS:** `.quick-btn` → outlined, `bcgRadiusMd` (16px), 14px text

**Two buttons:** "Request Check-in" and "Start Live"

**Flutter:**
```dart
Row(
  children: [
    Expanded(
      child: QuickActionButton(
        label: 'Request Check-in',
        icon: Icons.chat_bubble_outline,
        onTap: () => showToast('Sarah can see this request.'),
      ),
    ),
    const SizedBox(width: 12),
    Expanded(
      child: QuickActionButton(
        label: isLive ? 'Stop Live' : 'Start Live',
        icon: isLive ? Icons.stop : Icons.radar,
        onTap: toggleLive,
        // Secondary style — outlined, not filled
      ),
    ),
  ],
)
```

**"Start Live" behavior:**
- Tapping calls `toggleLive()`
- Partner Card transitions to `live` state
- Hero map appears at top of screen (320ms `AnimatedCrossFade`)
- Recent updates + bottom map hide
- Button label changes to "Stop Live"
- Timer shows elapsed time ("LIVE · 2m")

---

## Recent Updates Module

**CSS:** `.module` → surface, 22px radius, 16px padding; `.updates-list` inside

**Shows latest 2 items + "View all updates →" link**

**Flutter:**
```dart
class UpdatesModule extends StatelessWidget {
  final List<UpdateEvent> events;  // max 2

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('RECENT', style: eyebrow(context)),
            TextButton(
              onPressed: () => navigateTo('/updates'),
              child: Text('View all updates →', style: metaText(context)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...events.map((e) => UpdateItem(event: e)),
      ],
    );
  }
}
```

---

## Update Item

**CSS:** `.update-item` → grid 28px icon + text column

**Icon:** 28px rounded square, muted background, single glyph

**Flutter:**
```dart
class UpdateItem extends StatelessWidget {
  final UpdateEvent event;

  IconData get icon => switch (event.type) {
    UpdateType.checkIn    => Icons.check_circle_outline,
    UpdateType.liveStart  => Icons.radar,
    UpdateType.liveEnd    => Icons.radar,
    UpdateType.arrival    => Icons.place_outlined,
    UpdateType.departure  => Icons.logout,
    UpdateType.reaction   => Icons.favorite_border,
    UpdateType.critical   => Icons.battery_alert,
  };
}
```

**Copy:** Human-readable, never technical. Example: "Sarah arrived at Home." not "Location update: home geofence exit."

**Full update event types:** See `docs/01-experience/screen-states.md` — exclude raw GPS, sync, cache, app opened, background task.

---

## Map Preview

**CSS:** `.map-preview` → secondary, muted warm-gray streets, terracotta dot

**Always shows a neighborhood silhouette — never an empty state**

**Hero map (shown during live):**
- Full width inside `home-hero`
- Label: "Sarah's approximate area"
- Dot: terracotta with 18% radial glow
- Badge: "LIVE · 0m" with one-time pulse

**Flutter:**
```dart
// Normal map:
MapPreview(
  dotColor: bcgPrimary,
  label: "Sarah's approximate area",
  onTap: () => expandMap(),  // secondary — not dominant
)

// Hero map (live mode):
AnimatedCrossFade(
  duration: const Duration(milliseconds: 320),
  firstChild: MapPreview(),
  secondChild: HeroMap(
    label: "Sarah's approximate area",
    dotColor: bcgPrimary,
    elapsed: liveDuration,
  ),
  crossFadeState: isLive
    ? CrossFadeState.showSecond
    : CrossFadeState.showFirst,
)
```

**Rules:**
- Map is always present (no empty state)
- Secondary in normal mode, hero in live mode
- No GPS accuracy indicator
- No "last updated" timestamp on the map itself
- Tap expands to full Maps app — no inline map detail screen

---

## Bottom Nav

**CSS:** `.bcg-nav` → pill nav, 64px height, no top border

**Items:** Home, Updates, Settings

**Active style:** Filled icon + `bcgPrimary.withOpacity(0.14)` pill background + label in `bcgPrimary`

**Inactive style:** Outlined icon + `0.5` opacity + label in `bcgFgMuted`

**Flutter:**
```dart
class BottomNav extends StatelessWidget {
  final int selectedIndex;
  final void Function(int) onTap;

  static const items = [
    NavItem(icon: Icons.home_outlined,  activeIcon: Icons.home,             label: 'Home'),
    NavItem(icon: Icons.update_outlined,  activeIcon: Icons.update,            label: 'Updates'),
    NavItem(icon: Icons.settings_outlined, activeIcon: Icons.settings,       label: 'Settings'),
  ];
}
```

**Active pill animation (220ms, `easeInOut`):**
```dart
AnimatedContainer(
  duration: const Duration(milliseconds: 220),
  curve: Curves.easeInOut,
  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  decoration: BoxDecoration(
    color: isActive ? bcgPrimary.withOpacity(0.14) : Colors.transparent,
    borderRadius: BorderRadius.circular(bcgRadiusFull),
  ),
)
```

**Labels always visible.** Active icon is filled; inactive is outlined.

---

## Onboarding Screens

**CSS:** `#onboarding-*` → centered layout, full-screen with progress dots

**6 screens:** Welcome → Account → Pairing → Permissions → Connected → Success

**Flutter (GoRouter):**
```dart
GoRoute(
  path: '/onboarding',
  builder: (context, state) => OnboardingFlow(
    screens: const [
      WelcomeScreen(),
      AccountScreen(),
      PairingScreen(),
      PermissionsScreen(),
      ConnectedScreen(),
      SuccessScreen(),
    ],
  ),
)
```

**Key screens:**

### Pairing (screen 3)
Copy must include:
- "Beaconnect only works when both people agree."
- "Connections are always mutual and can be ended at any time."

### Permissions (screen 4)
Pattern per permission: Why → Status → Recommendation → Action

### Connected (screen 5)
Shows "I'm Okay" button — primary action is active here

### Success (screen 6)
- "Sarah now knows you're around."
- "You're ready to quietly stay connected."
- No confetti, no loud celebration

**Rules:**
- No progress bar
- Dots only
- No "Get Started" until end
- No logo after screen 1

---

## Widget (4×2)

**CSS:** `.widget` → compact `bcgSurface`, `bcgRadiusMd`, 16px padding

**Layout hierarchy:**
```
Partner name (bold)
Status sentence
Freshness (mono)
[ I'm Okay ]  ← one action only
```

**Flutter:**
```dart
class BeaconnectWidget extends StatelessWidget {
  // 4×2 HomeScreenWidget
  // Single PendingIntent: launch app to Home
  // "I'm Okay" deep-link: /home?action=okay
}

class BeaconnectWidget4x2 extends StatelessWidget {
  final String partnerName;
  final String status;
  final String freshness;
  final VoidCallback? onOkayTap;
}
```

**Rules:**
- Reassurance glance, not a miniature app
- One action maximum
- No map
- No timeline
- No decorative animation
- No partner photo

**"I'm Okay" press interaction:** 120ms scale(0.985) → subtle ripple → haptic → return to rest

---

## Bottom Sheet

**CSS:** `.bottom-sheet` → slides up, `bcgRadiusLg` (24px) top corners, overlay backdrop

**Flutter:**
```dart
showModalBottomSheet(
  context: context,
  backgroundColor: bcgSurface,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
  ),
  builder: (context) => SheetContent(),
)
```

**Used for:**
- Update item detail (exact time, place, reaction, "Open in Maps" link)
- Trust section expansion
- Permission explanation

---

## Trust Section

**Pattern (every section):** Title → Explanation → Status → Action

**CSS:** `.trust-section` → surface card, `bcgRadiusMd`, 16px padding

**Flutter:**
```dart
class TrustSection extends StatelessWidget {
  final String title;
  final String explanation;
  final Widget status;        // e.g. "Connected" badge
  final Widget? action;       // e.g. "Manage Sharing" button

  // Pattern: Explain → Status → Action
  // Each section answers: "Can I trust this?"
}
```

**Sections:**
1. Our Connection
2. Sharing
3. Privacy
4. History
5. Permissions
6. How Beaconnect Works (handbook Q&A)

---

## My Beacon Settings

**Pattern:** Preference → Current choice → Customize

**Sections:**
1. Check-in Messages
2. Pair Symbol
3. Widget
4. Quiet Hours
5. Appearance
6. Accessibility

**Flutter:** Standard `ListTile` with `trailing: Icon(Icons.chevron_right)` for sections with sub-pages

---

## Toast / Snackbar

**CSS:** `.toast` → fixed bottom-center, surface overlay background, 12px radius, 220ms slide-up

**Flutter:**
```dart
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text('Sarah now knows you're around.'),
    backgroundColor: bcgSurfaceOverlay,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    duration: const Duration(seconds: 3),
    margin: const EdgeInsets.only(bottom: 80, left: 20, right: 20),
  ),
)
```

**Tone:** Human wording, never technical. Examples from prototype:
- "Sarah now knows you're around."
- "Sarah can see this request."
- "Sharing is currently paused."
- "Check-in requested."
