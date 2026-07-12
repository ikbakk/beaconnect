# Screen Spec — Flutter

**Source:** `design/prototype/beaconnect-app.html` — open in browser and use nav buttons to navigate each screen.

Each Flutter screen must match the HTML prototype exactly.

---

## Global shell

```dart
// ═══════════════════════════════════════════
// Android shell — matches beaconnect-app.html
// ═══════════════════════════════════════════

Container(
  width: 430,
  height: 932,
  decoration: BoxDecoration(
    color: bcgSurface,
    borderRadius: BorderRadius.circular(40),
    border: Border.all(color: const Color(0xFF1f1d1b), width: 5),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.18),
        blurRadius: 40,
        offset: const Offset(0, 16),
      ),
    ],
  ),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(36),
    child: Column(
      children: [
        // Safe area top
        SizedBox(height: MediaQuery.of(context).padding.top + 10),
        // Content area (scrollable)
        Expanded(child: screenContent),
        // Bottom nav
        SizedBox(height: MediaQuery.of(context).padding.bottom),
      ],
    ),
  ),
)
```

---

## Home Screen

**Route:** `/` (index)

**Layout order (top to bottom):**

1. Partner Card — `PartnerCard(state: _, partnerName: 'Sarah')`
2. I'm Okay button — centered, `OkayButton()`
3. Quick Actions row — `Request Check-in` | `Start Live`
4. Recent Updates module — latest 2 `UpdateItem`s + "View all updates →"
5. Map Preview — secondary, muted streets, terracotta dot

**No app bar. No logo. No greeting.**

### Home states

```dart
HomeScreen(
  partnerCardState: PartnerCardState.normal,  // switch for demo
  okayButtonState:   OkayButtonState.idle,
  isLive:           false,                    // toggles map position
  recentUpdates:    List<UpdateEvent>.generate(2, ...),
)
```

### Live mode

When `isLive = true`:
1. Hero map (wide, labeled) appears inside the main scrollable area — top of content
2. Partner Card changes to `PartnerCardState.live`
3. Recent Updates + bottom map hide
4. "Start Live" button becomes "Stop Live"
5. Live timer badge shows "LIVE · Xm"

```dart
AnimatedCrossFade(
  duration: const Duration(milliseconds: 320),
  firstChild:  normalHomeLayout,
  secondChild: liveHomeLayout,
  crossFadeState: isLive
    ? CrossFadeState.showSecond
    : CrossFadeState.showFirst,
)
```

### Partner Card states

All 7 states use the **same layout**. Only copy changes.

| State | Heading | Meta | Action |
|---|---|---|---|
| `normal` | "Everything looks normal." | "Updated 2 minutes ago at Home." | none |
| `live` | "Sharing live." | "Until you stop." | live badge |
| `paused` | "Sharing is currently paused." | "Last update was today at 14:32." | none |
| `noUpdates` | "No new updates yet." | "Last updated 47 minutes ago near Home." | none |
| `permissionMissing` | "Sharing is not fully available yet." | "Background sharing works best when permission is enabled." | none |
| `noPartner` | "Welcome." | "Beaconnect works best when both people choose to share." | "Pair with someone to get started." |
| `connectionEnded` | "This shared connection has ended." | "You can start a new shared connection anytime." | "Start a new connection." |

**Reference:** `design/components/partner-card.md` and `docs/01-experience/screen-states.md`

---

## Updates Screen

**Route:** `/updates`

**Structure:**
```
Lightweight header: "Updates"
↓ grouped timeline ↓
Today
  Morning
    UpdateItem · check-in
    UpdateItem · arrival
  Afternoon
    UpdateItem · reaction
Yesterday
  Evening
    UpdateItem · live ended
↓ gentle ending copy ↓
```

**Timestamps:** Show relative ("2 min ago") grouped under time-of-day labels (Morning / Afternoon / Evening / Late Night).

**Event types to include:**
- Check-in ("Sarah checked in.")
- Live sharing started ("Sarah started sharing live.")
- Live sharing ended ("Sarah stopped sharing.")
- Arrival ("Sarah arrived at Home.")
- Departure ("Sarah left Home.")
- Reaction ("Sarah reacted.")
- Battery critical (only genuine urgency)

**Event types to exclude:**
- Raw GPS updates
- Sync / cache / background events
- "App opened"
- "Widget refreshed"

**Ending copy:**
> "That's everything for today.
> We'll keep you updated when something meaningful happens."

**Interaction:** Tapping an update opens a bottom sheet with exact time, place, reaction text, and "Open in Maps" link.

```dart
// Bottom sheet on tap
showModalBottomSheet(
  context: context,
  builder: (context) => UpdateDetailSheet(event: tappedEvent),
)
```

**Reference:** `docs/02-interface/updates-v1.md`

---

## Settings Hub

**Route:** `/settings`

**Two major sections, equal visual weight:**

```
Settings
─────────────────────────────────
Trust Center ────────────────────
  Mutual sharing and privacy
  → chevron

My Beacon ───────────────────────
  Your personal experience
  → chevron
─────────────────────────────────
About
```

**Rules:**
- If it changes the **relationship or shared trust** → Trust Center
- If it changes only the **user's personal experience** → My Beacon

**No clutter. No diagnostics-first layout. No technical jargon.**

**Reference:** `docs/02-interface/settings-v1.md`

---

## Trust Center

**Route:** `/settings/trust-center`

**Pattern (every section):** Title → Explanation → Status → Action

**Sections:**

1. **Our Connection**
   - "You and Sarah are connected."
   - Status: connected / not connected
   - Action: "Manage Connection" → unpair option

2. **Sharing**
   - "Sarah can see your presence when you share."
   - Status: sharing / paused
   - Action: "Manage Sharing"

3. **Privacy**
   - What is shared, who sees it, how long it stays
   - 3-day detail window + monthly summaries
   - Status: summary of current sharing scope
   - Action: "Review Privacy"

4. **History**
   - "Your last 3 days are available in detail."
   - "Monthly summaries are kept for 6 months."
   - Status: history window summary
   - Action: "Manage History"

5. **Permissions**
   - Plain human language — no Android permission constants
   - Background location: "Keeps your location available without keeping the app open."
   - Notifications: "Lets Sarah know when something meaningful happens."
   - Battery optimization: "Helps sharing work reliably in the background."
   - Action: "Review Permissions"

6. **How Beaconnect Works**
   - Handbook-style Q&A
   - Topics: delayed updates, temporary live sharing, consent, privacy
   - Pattern: question → human answer → optional action

**Tone:** Informative, reassuring, transparent. Never alarming.

**Reference:** `docs/02-interface/trust-center-v1.md`

---

## My Beacon

**Route:** `/settings/my-beacon`

**Pattern (every section):** Preference → Current choice → Customize

**Sections:**

1. **Check-in Messages**
   - "Personalize the short messages used when you check in."
   - Current: "Random from 6 messages"
   - → Customize → custom message pool

2. **Pair Symbol**
   - Current: ⭐ (editable)
   - → Customize → symbol picker

3. **Widget**
   - "Your home screen widget is enabled."
   - → Customize → widget setup

4. **Quiet Hours**
   - "Sharing pauses during quiet hours."
   - Current: "10pm – 7am"
   - → Customize → start/end time

5. **Appearance**
   - System / Light / Dark (future)
   - Default: System

6. **Accessibility**
   - Text size (default / large / larger)
   - Reduce motion (future)

**Rules:**
- No relationship controls
- No privacy policy details
- No history deletion
- No diagnostics

**Reference:** `docs/02-interface/my-beacon-v1.md`

---

## Onboarding (6 screens)

**Route:** `/onboarding` → GoRouter with page controller

| Screen | Route |
|---|---|
| 1. Welcome | `/onboarding/1` |
| 2. Account | `/onboarding/2` |
| 3. Pairing | `/onboarding/3` |
| 4. Permissions | `/onboarding/4` |
| 5. Connected | `/onboarding/5` |
| 6. Success | `/onboarding/6` |

### Screen 1 — Welcome

> "Built for reassurance, not surveillance."
> "Beaconnect helps two people quietly stay connected through mutual sharing and simple check-ins."
>
> [Get Started]

### Screen 2 — Account

Explain account creation. Standard email/password or Google Sign-In.

### Screen 3 — Pairing

**Critical — consent emphasis:**

> "Beaconnect only works when both people agree."
> "Connections are always mutual and can be ended at any time."

Visual: two shapes gently mirroring each other — partnership and choice, not a chain.

### Screen 4 — Permissions

Pattern per permission:

```
Why it's helpful
↓
Current status
↓
Recommendation
↓
Action button
```

Permissions: Location (Background) | Notifications | Battery Optimization

### Screen 5 — Connected

> "You're connected."
> "Try your first check-in."
>
> [I'm Okay]

This is the first time the primary action button is live.

### Screen 6 — Success

> "Sarah now knows you're around."
> "You're ready to quietly stay connected."

**No confetti. No loud celebration. Quiet confidence.**

**Rules:**
- No progress bar — dots only
- No "Get Started" until screen 6
- No logo after screen 1
- No tutorial carousel or feature checklist
- No mascot

---

## Widget (4×2 Android)

**Not a Flutter screen — an Android HomeScreenWidget (glance).**

```dart
// Android Glance widget
@Composable
fun BeaconnectWidget4x2() {
  // 4×2: partner name, status, freshness, "I'm Okay" button
  // Single PendingIntent: launch app
  // "I'm Okay" deep link: /home?action=okay
}
```

**Layout:**
```
Sarah ⭐
Everything looks normal.
Updated 2 min ago at Home.
[ I'm Okay ]
```

**Rules:**
- Reassurance glance, not a miniature app
- One action maximum
- No map
- No timeline
- No decorative animation
- No partner photo

**Reference:** `docs/02-interface/widget-v1.md`

---

## Responsive behavior

The prototype targets 430×932 (Android). For responsive scaling:

```dart
// Scale factor based on design width (430px)
final scale = MediaQuery.of(context).size.width / 430;

return Transform.scale(
  scale: scale.clamp(0.5, 1.5),
  child: SizedBox(width: 430, height: 932, child: app),
)
```

Do not reflow the layout — the fixed frame is intentional.

---

## Navigation

```dart
GoRouter(
  routes: [
    ShellRoute(
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(path: '/',                builder: (_, __) => HomeScreen()),
        GoRoute(path: '/updates',          builder: (_, __) => UpdatesScreen()),
        GoRoute(path: '/settings',         builder: (_, __) => SettingsScreen()),
        GoRoute(path: '/settings/trust-center', builder: (_, __) => TrustCenterScreen()),
        GoRoute(path: '/settings/my-beacon',    builder: (_, __) => MyBeaconScreen()),
      ],
    ),
    GoRoute(path: '/onboarding', ...),  // outside shell
  ],
)
```
