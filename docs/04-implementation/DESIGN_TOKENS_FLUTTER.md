# Design Tokens → Flutter

**Source:** `design/prototype/beaconnect.css`

**Rule:** CSS values are canonical. Convert to Dart equivalents using this guide. Do not invent new values.

---

## Colors

The CSS uses `oklch()` which has no direct Dart equivalent. Use the precomputed hex/argb values below.

```dart
// ═══════════════════════════════════════════
// Beaconnect Color Palette
// Source: design/prototype/beaconnect.css
// ═══════════════════════════════════════════

import 'package:flutter/material.dart';

/// Background surface — warm cream, never pure white
const bcgSurface        = Color(0xFFF8F6F4);

/// Card and sheet surface — slightly warmer than bg
const bcgSurfaceVariant = Color(0xFFF0ECE7);

/// Bottom sheet overlay backdrop
const bcgSurfaceOverlay = Color(0xF0FFFDFB);

/// Primary text — warm near-black
const bcgFg            = Color(0xFF38302C);

/// Secondary/meta text — warm mid-gray
const bcgFgMuted       = Color(0xFF797269);

/// Default border and divider
const bcgOutline        = Color(0xFFDDD9D5);

/// Stronger outline for emphasis
const bcgOutlineStrong  = Color(0xFFB5B0AA);

/// Primary brand action — warm terracotta
/// Use for: I'm Okay button, active nav, primary CTAs
const bcgPrimary        = Color(0xFFB46C53);

/// Primary hover / pressed state
const bcgPrimaryHover   = Color(0xFFA45C42);

/// Text on primary (always light)
const bcgPrimaryFg      = Color(0xFFF9F7F5);

/// Secondary action — sage green
/// Use for: normal/okay status, check-in success
const bcgSecondary      = Color(0xFF79AA89);

/// Secondary hover
const bcgSecondaryHover = Color(0xFF649B79);

/// Success — "Everything looks normal." badge
const bcgSuccess       = Color(0xFF6FA07D);
const bcgSuccessBg     = Color(0xFFF0F6F2);

/// Info — for informational notices
const bcgInfo           = Color(0xFF7A9CCF);
const bcgInfoBg         = Color(0xFFEFF4FC);

/// Caution — something to be aware of, not alarming
const bcgCaution        = Color(0xFFC7A14A);
const bcgCautionBg      = Color(0xFFFBF5E8);

/// Critical — genuinely urgent only (battery critical, connection ended)
const bcgCritical       = Color(0xFFBF4D30);
const bcgCriticalBg     = Color(0xFFFBF0EE);

/// Live sharing accent — used only on the live badge
const bcgLiveAccent     = Color(0xFFB46C53);
const bcgLiveBadgeBg    = Color(0xFFF5EBE8);

/// ═══════════════════════════════════════════
/// Flutter ColorScheme — use this in MaterialApp
/// ═══════════════════════════════════════════

ColorScheme get beaconnectLightScheme => const ColorScheme.light(
  surface:          bcgSurface,
  primary:          bcgPrimary,
  onPrimary:        bcgPrimaryFg,
  secondary:        bcgSecondary,
  onSecondary:      Color(0xFFF9F7F5),
  error:            bcgCritical,
  onError:          Color(0xFFF9F7F5),
  outline:          bcgOutline,
  surfaceContainerHighest: bcgSurfaceVariant,
);
```

### Color usage rules

| Token | When to use | When NOT to use |
|---|---|---|
| `bcgPrimary` | I'm Okay button, active nav pill, primary CTA | decorative borders, badges |
| `bcgSuccess` | Normal status badge, check-in success | anything that could feel alarming |
| `bcgCaution` | Delayed updates, permission missing | urgent states |
| `bcgCritical` | Battery critical, connection ended | normal states, decorative |
| `bcgLiveAccent` | Live badge only | never on non-live states |

**Max 2 accent uses per screen.** If you're using `bcgPrimary` on more than one element, choose the single most important action.

---

## Typography

### Font families

```dart
// Add to pubspec.yaml:
// google_fonts: ^6.2.1
// Then:
import 'package:google_fonts/google_fonts.dart';

// Display / headings — Plus Jakarta Sans
TextStyle get displayFont => GoogleFonts.plusJakartaSans(
  fontWeight: FontWeight.w600,
  letterSpacing: -0.02,
);

// Body text
TextStyle get bodyFont => GoogleFonts.ibmPlexSans(
  fontWeight: FontWeight.w400,
);

// Timestamps, metadata, labels
TextStyle get monoFont => GoogleFonts.ibmPlexMono(
  fontWeight: FontWeight.w400,
  fontSize: 12,
  letterSpacing: 0.02,
);
```

### Type scale

| Role | Size | Weight | Line height | Tracking |
|---|---|---|---|---|
| Partner name (Home) | 28px | 600 | 1.1 | -0.03em |
| Partner status heading | 24px | 600 | 1.18 | -0.02em |
| Section eyebrow | 11px | 500 | 1.4 | 0.06em (mono) |
| Body | 16px | 400 | 1.55 | 0 |
| Meta / timestamp | 13px | 400 | 1.45 | 0.01em |
| Button label | 18px | 600 | 1.2 | 0.01em |
| Nav label | 11px | 500 | 1.3 | 0.04em |

### Three-weight system

Use exactly 3 weights:

- **Read (400)** — body copy, meta text
- **Emphasize (500/550)** — nav labels, section headers, metadata
- **Announce (600)** — Partner Card status, button labels

Never use weight 700. If you're reaching for bold, the hierarchy is wrong.

---

## Spacing (8pt grid)

```dart
const bcgS1  = 4.0;
const bcgS2  = 8.0;
const bcgS3  = 12.0;
const bcgS4  = 16.0;
const bcgS5  = 20.0;
const bcgS6  = 24.0;
const bcgS8  = 32.0;
const bcgS10 = 40.0;
const bcgS12 = 48.0;

// Convenience gaps
const bcgGapXs = bcgS2;   // inside components
const bcgGapSm = bcgS3;   // between related items
const bcgGapMd = bcgS4;   // between sections
const bcgGapLg = bcgS6;   // between major sections
```

**Line length rule:** Body copy max 65 characters. Use `maxWidth: 340` on text columns.

---

## Border radius

```dart
const bcgRadiusSm   = 8.0;   // chips, small controls, update items
const bcgRadiusMd   = 16.0;  // cards, sheets, quick-action buttons
const bcgRadiusLg   = 24.0;  // I'm Okay button, bottom nav pill
const bcgRadiusFull = 9999;  // pills, badges, nav active indicator
```

**Radius usage:**

| Radius | Use |
|---|---|
| `bcgRadiusSm` | Update items, state chips, section eyebrows |
| `bcgRadiusMd` | Partner Card, Quick Action buttons, Trust Section cards |
| `bcgRadiusLg` | I'm Okay primary CTA, bottom sheets, Recent Updates module |
| `bcgRadiusFull` | Nav pill indicator, live badge, pair symbol |

---

## Elevation

**Beaconnect is flat.** No Material shadows except `Elevation.raised`.

```dart
// Flat surfaces — no shadow
// Raised: Partner Card only
BoxDecoration(
  color: bcgSurface,
  borderRadius: BorderRadius.circular(bcgRadiusMd),
  border: Border.all(color: bcgOutline, width: 1),
),

// Overlay: bottom sheets, dialogs
BoxDecoration(
  color: bcgSurface,
  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.06),
      blurRadius: 12,
      offset: const Offset(0, -2),
    ),
  ],
),
```

---

## Motion / transitions

```dart
// ═══════════════════════════════════════════
// Duration
// ═══════════════════════════════════════════
const bcgTFast = Duration(milliseconds: 120);  // button press feedback
const bcgTMid  = Duration(milliseconds: 220);  // state transitions, nav
const bcgTSlow = Duration(milliseconds: 320);  // context expand/collapse

// ═══════════════════════════════════════════
// Easing — use these exactly
// ═══════════════════════════════════════════

/// Standard out — enter, expand, show
const bcgEaseOut = Cubic(0.22, 1.0, 0.36, 1.0);

/// Standard in-out — toggle, crossfade
const bcgEaseInOut = Cubic(0.4, 0.0, 0.2, 1.0);

/// Decisive exit — dismiss, collapse (asymmetric)
/// 140ms exit vs 200ms enter — feels decisive because user already chose
const bcgEaseOutShort = Cubic(0.23, 1.0, 0.32, 1.0);
```

### Common animations

```dart
// Button press — 120ms scale down
AnimatedScale(
  scale: isPressed ? 0.985 : 1.0,
  duration: bcgTFast,
  curve: Curves.easeOut,
  child: Text('I\'m Okay'),
),

// Nav pill slide — 220ms
AnimatedContainer(
  duration: bcgTMid,
  curve: bcgEaseInOut,
  decoration: BoxDecoration(
    color: isActive ? bcgPrimary.withOpacity(0.12) : Colors.transparent,
    borderRadius: BorderRadius.circular(bcgRadiusFull),
  ),
),

// Live map expand — 320ms
AnimatedCrossFade(
  duration: bcgTSlow,
  firstChild: normalMap,
  secondChild: heroMap,
  crossFadeState: isLive ? CrossFadeState.showSecond : CrossFadeState.showFirst,
),

// State card change — 220ms fade
AnimatedSwitcher(
  duration: bcgTMid,
  child: PartnerCard(key: ValueKey(state), state: state),
),
```

### What NOT to animate

- No bounce, elastic, or overshoot
- No confetti
- No repeated pulsing (except the live badge — one-time pulse on activation only)
- No decorative background motion
- No loading spinners — show last known state instead
- Logo never animates on core screens

---

## App bar / navigation bar height

```dart
const bcgNavHeight     = 64.0;  // bottom nav
const bcgStatusBarHeight = 24.0; // Android status bar area
```

---

## Component token shortcuts

```dart
// ── Partner Card ────────────────────────────
const partnerCardPadding = EdgeInsets.all(bcgS4 + 2);  // 18px
const partnerCardRadius  = bcgRadiusMd + 10;           // 26px
const partnerCardBorder  = Border.fromBorderSide(BorderSide(color: bcgOutline, width: 1));

// ── I'm Okay Button ────────────────────────
const okayButtonPadding  = EdgeInsets.symmetric(horizontal: bcgS4, vertical: bcgS4 + 2); // 18px 18px
const okayButtonRadius   = bcgRadiusLg + 2;  // 26px (slightly larger than card)
const okayButtonFontSize = 18.0;
const okayButtonWeight  = FontWeight.w600;

// ── Quick Action ────────────────────────────
const quickActionPadding = EdgeInsets.symmetric(horizontal: bcgS3, vertical: bcgS3 + 2); // 14px 16px
const quickActionRadius  = bcgRadiusMd;  // 16px

// ── Nav item ───────────────────────────────
const navItemPadding     = EdgeInsets.symmetric(horizontal: bcgS3, vertical: bcgS2); // 12px 8px
const navPillPadVertical = 6.0;  // top/bottom padding inside the pill
const navPillPadHorizontal = 12.0;
const navLabelFontSize    = 11.0;
const navIconSize         = 24.0;
const navActiveIconOpacity = 1.0;
const navInactiveIconOpacity = 0.5;

// ── Section eyebrow ─────────────────────────
const eyebrowFontSize    = 11.0;
const eyebrowLetterSpace = 0.06;
const eyebrowWeight     = FontWeight.w500;
const eyebrowFontFamily = monoFont;  // IBM Plex Mono

// ── Update item ────────────────────────────
const updateIconSize    = 28.0;
const updateIconRadius  = bcgRadiusSm;  // 8px
```
