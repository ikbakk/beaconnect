# CSS → Flutter Reference

**Source:** `design/prototype/beaconnect.css`

Every CSS pattern from the prototype mapped to its Flutter equivalent.

---

## Layout

### Flexbox row

```css
/* CSS */
display: flex;
align-items: center;
justify-content: space-between;
gap: 12px;
```

```dart
// Flutter
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    widgetA,
    widgetB,
  ],
)

// For gap: use SizedBox(width: 12) between items
// or use the gap package: gap: Spacing(12)
```

### Flexbox column

```css
/* CSS */
display: flex;
flex-direction: column;
gap: 16px;
```

```dart
// Flutter
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    widgetA,
    widgetB,
  ],
)
// Space with SizedBox(height: 16)
```

### CSS Grid

```css
/* CSS */
display: grid;
grid-template-columns: 1fr 1fr;
gap: 12px;
```

```dart
// Flutter
GridView.count(
  crossAxisCount: 2,
  mainAxisSpacing: 12,
  crossAxisSpacing: 12,
  shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),
  children: [...],
)
```

### Flex wrap

```css
/* CSS */
flex-wrap: wrap;
gap: 8px;
```

```dart
// Flutter
Wrap(
  spacing: 8,
  runSpacing: 8,
  children: [...],
)
```

### Center

```css
/* CSS */
display: flex;
align-items: center;
justify-content: center;
```

```dart
// Flutter
Center(child: widget)
```

### Absolute positioning

```css
/* CSS */
position: absolute;
top: 0; left: 0;
```

```dart
// Flutter
Positioned(
  top: 0,
  left: 0,
  child: widget,
)
// Parent must be Stack
```

### Inset (padding inside)

```css
/* CSS */
inset: 12px;
```

```dart
// Flutter
Padding(
  padding: const EdgeInsets.all(12),
  child: widget,
)
```

---

## Border radius

```css
/* CSS */
border-radius: 16px;
border-radius: 9999px;  /* full pill */
```

```dart
// Flutter
BorderRadius.circular(16)
BorderRadius.circular(9999)  // treat as full
```

### Named radii from design tokens

```dart
const bcgRadiusSm   = 8.0;
const bcgRadiusMd   = 16.0;
const bcgRadiusLg   = 24.0;
const bcgRadiusFull = 9999.0;

BorderRadius.circular(bcgRadiusMd)  // cards
BorderRadius.circular(bcgRadiusFull) // pills, badges
```

---

## Border

```css
/* CSS */
border: 1px solid var(--bcg-outline);
border-top: none;
```

```dart
// Flutter
BoxDecoration(
  border: Border.all(color: bcgOutline, width: 1),
  borderRadius: BorderRadius.circular(bcgRadiusMd),
)

// Remove one side:
BoxDecoration(
  border: Border(
    left: BorderSide(color: bcgOutline, width: 1),
    right: BorderSide(color: bcgOutline, width: 1),
    bottom: BorderSide(color: bcgOutline, width: 1),
  ),
  borderRadius: BorderRadius.circular(bcgRadiusMd),
)
```

---

## Color

### Solid fill

```css
/* CSS */
background: var(--bcg-surface);
```

```dart
// Flutter
Container(color: bcgSurface)
// or
DecoratedBox(decoration: BoxDecoration(color: bcgSurface))
```

### With border

```css
/* CSS */
background: var(--bcg-surface);
border: 1px solid var(--bcg-outline);
```

```dart
// Flutter
Container(
  decoration: BoxDecoration(
    color: bcgSurface,
    border: Border.all(color: bcgOutline, width: 1),
    borderRadius: BorderRadius.circular(bcgRadiusMd),
  ),
)
```

### `color-mix` replacement

```css
/* CSS — this does NOT exist in Dart */
color-mix(in oklch, var(--bcg-primary) 12%, transparent);
```

```dart
// Flutter — use withOpacity or Color.lerp
bcgPrimary.withOpacity(0.12)
```

> **Note:** `oklch` perceptually uniform color math has no direct Dart equivalent. `withOpacity` is the practical substitute. The visual result is close enough for UI purposes.

### Color on dark surface

```css
/* CSS */
color: color-mix(in oklch, var(--bcg-fg) 6%, transparent);
```

```dart
// Flutter
bcgFg.withOpacity(0.94)
```

---

## Spacing

### Padding

```css
/* CSS */
padding: 16px;
padding: 18px 16px;
padding: 14px 14px 18px;  /* top right bottom left */
```

```dart
// Flutter
Padding(padding: EdgeInsets.all(16))
Padding(padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18))
Padding(padding: EdgeInsets.fromLTRB(14, 14, 14, 18))
```

### Margin

```css
/* CSS */
margin-bottom: 24px;
```

```dart
// Flutter
// Use SizedBox for spacing between widgets, not Margin
// Margin is for pushing Container edges:
Container(margin: const EdgeInsets.only(bottom: 24), child: widget)

// Better: SizedBox in a Column/Row
Column(children: [
  widget,
  SizedBox(height: 24),
])
```

### Gap shorthand

```css
/* CSS */
gap: 12px;
gap: 8px 16px;  /* row: column-gap row-gap */
```

```dart
// Flutter
// No direct equivalent. Options:

// 1. SizedBox between items (Column/Row)
Column(children: [
  widgetA,
  SizedBox(height: 12),
  widgetB,
])

// 2. gap package
// pubspec.yaml: gap: ^3.0.1
import 'package:gap/gap.dart';
Column(children: [
  widgetA,
  const Gap(12),
  widgetB,
])

// 3. MainAxisSize for Row/Column
// not equivalent but use to control free space
```

---

## Typography

### Font family

```css
/* CSS */
font-family: var(--bcg-font-body);
font-family: var(--bcg-font-display);
```

```dart
// Using google_fonts package:
Text(
  'Text',
  style: GoogleFonts.plusJakartaSans(
    fontWeight: FontWeight.w600,
    fontSize: 18,
    letterSpacing: -0.01,
    color: bcgFg,
  ),
)

Text(
  'Body copy',
  style: GoogleFonts.ibmPlexSans(
    fontWeight: FontWeight.w400,
    fontSize: 16,
    height: 1.55,  // line-height equivalent
    color: bcgFg,
  ),
)
```

### Text style shortcuts

```dart
// Reusable style builders
TextStyle partnerStatus(BuildContext context) => GoogleFonts.plusJakartaSans(
  fontWeight: FontWeight.w600,
  fontSize: 24,
  height: 1.18,
  letterSpacing: -0.02,
  color: bcgFg,
);

TextStyle bodyText(BuildContext context) => GoogleFonts.ibmPlexSans(
  fontWeight: FontWeight.w400,
  fontSize: 16,
  height: 1.55,
  color: bcgFg,
);

TextStyle metaText(BuildContext context) => GoogleFonts.ibmPlexSans(
  fontWeight: FontWeight.w400,
  fontSize: 13,
  height: 1.45,
  letterSpacing: 0.01,
  color: bcgFgMuted,
);

TextStyle eyebrow(BuildContext context) => GoogleFonts.ibmPlexMono(
  fontWeight: FontWeight.w500,
  fontSize: 11,
  height: 1.4,
  letterSpacing: 0.06,
  color: bcgFgMuted,
);
```

### Text overflow

```css
/* CSS */
overflow: hidden;
white-space: nowrap;
text-overflow: ellipsis;
```

```dart
// Flutter
Text(
  'Long text',
  overflow: TextOverflow.ellipsis,
  maxLines: 1,
)
```

---

## Icon

### SVG icon in HTML → Flutter icon widget

```css
/* CSS — inline SVG */
<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
  <path d="..."/>
</svg>
```

```dart
// Flutter — use Icon widget with Material/Cupertino icons or custom icon font
// Match the viewBox 24x24 grid
Icon(
  Icons.home_outlined,  // or Icons.home
  size: 24,
  color: bcgFg,         // currentColor equivalent
)
// Icon stroke weight is handled by the icon set — use outlined variants for inactive, filled for active
```

### Icon button

```css
/* CSS */
<button class="bcg-icon-btn">
  <svg>...</svg>
</button>
```

```dart
// Flutter
IconButton(
  onPressed: () { },
  icon: Icon(Icons.home_outlined),
  iconSize: 24,
  color: bcgFg,
  padding: EdgeInsets.all(8),  // hit target
)
```

---

## Visibility

### Show/hide

```css
/* CSS */
display: none;
display: block;
```

```dart
// Flutter
// Option 1: AnimatedOpacity for smooth transitions
AnimatedOpacity(
  opacity: isVisible ? 1.0 : 0.0,
  duration: bcgTMid,
  child: widget,
)

// Option 2: Offstage for layout-aware toggle
// (widget takes up space even when hidden)
Offstage(
  offstage: !isVisible,
  child: widget,
)

// Option 3: animate_do package
// VisibilityTransition: fade + slide in one widget
```

---

## Animation / transition

### CSS transition

```css
/* CSS */
transition: transform 180ms cubic-bezier(0.23, 1, 0.32, 1),
            background 180ms ease;
```

```dart
// Flutter — AnimatedContainer for layout + visual changes
AnimatedContainer(
  duration: const Duration(milliseconds: 180),
  curve: Curves.easeOut,
  transform: Matrix4.identity()..scale(isPressed ? 0.985 : 1.0),
  decoration: BoxDecoration(
    color: isActive ? bcgPrimary : bcgSurface,
    borderRadius: BorderRadius.circular(bcgRadiusLg),
  ),
)

// For color-only: AnimatedContainer works
// For crossfade: AnimatedCrossFade
AnimatedCrossFade(
  duration: const Duration(milliseconds: 320),
  firstChild: normalWidget,
  secondChild: liveWidget,
  crossFadeState: isLive
    ? CrossFadeState.showSecond
    : CrossFadeState.showFirst,
)
```

### CSS keyframe

```css
/* CSS */
@keyframes ripple {
  0%   { transform: scale(0.4); opacity: 1; }
  100% { transform: scale(2.8); opacity: 0; }
}
```

```dart
// Flutter — use AnimatedBuilder + Tween
// Better: use the built-in InkWell ripple
InkWell(
  onTap: () { },
  child: Text('I\'m Okay'),
  borderRadius: BorderRadius.circular(bcgRadiusLg),
)

// For a custom ripple (e.g. button press):
// Use a custom AnimationController + AnimatedBuilder
// Match the CSS timing: Duration(milliseconds: 580) + Curves.easeOut
```

### CSS `@keyframes pulse`

```css
/* CSS */
@keyframes pulse {
  0%, 100% { opacity: 1; }
  50%       { opacity: 0.5; }
}
```

```dart
// Flutter — RepeatingTimer or AnimationController
// WARNING: AnimatedBuilder loops are expensive
// Only use for the live badge — one-time pulse on activation
// Do NOT use for decorative pulsing anywhere else
class _LiveBadgeState extends State<LiveBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1600),
      vsync: this,
    )..repeat(reverse: true);
    _opacity = Tween<double>(begin: 1.0, end: 0.45).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: Container(
        decoration: BoxDecoration(
          color: bcgLiveBadgeBg,
          borderRadius: BorderRadius.circular(bcgRadiusFull),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Text('LIVE', style: eyebrow(context)),
      ),
    );
  }
}
```

---

## Media query / responsive

```css
/* CSS */
@media (max-width: 920px) { ... }
```

```dart
// Flutter — LayoutBuilder
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth <= 920) {
      return mobileLayout;
    } else {
      return desktopLayout;
    }
  },
)

// For breakpoint constants:
const bcgBreakpointTablet = 600.0;
const bcgBreakpointDesktop = 920.0;
```

---

## Overflow scroll

```css
/* CSS */
overflow-y: auto;
```

```dart
// Flutter
SingleChildScrollView(
  child: Column(children: [...]),
)

// For a fixed-height scrollable area:
SizedBox(
  height: 200,
  child: ListView.builder(
    itemCount: items.length,
    itemBuilder: (context, index) => UpdateItemWidget(items[index]),
  ),
)
```

---

## Nav pill indicator (active tab)

```css
/* CSS */
.bcg-nav__item::before {
  content: '';
  position: absolute;
  top: 6px; bottom: 6px;
  left: 12px; right: 12px;
  background: color-mix(in oklch, var(--bcg-primary) 14%, transparent);
  border-radius: 999px;
  opacity: 0;
  transition: opacity 220ms ease;
}
.bcg-nav__item.is-active::before { opacity: 1; }
```

```dart
// Flutter — AnimatedContainer wraps the pill
// NavItem widget:
Widget build(BuildContext context) {
  final isActive = index == selectedIndex;

  return GestureDetector(
    onTap: () => onTap(index),
    behavior: HitTestBehavior.opaque,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive
          ? bcgPrimary.withOpacity(0.14)
          : Colors.transparent,
        borderRadius: BorderRadius.circular(bcgRadiusFull),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isActive ? _iconFilled : _iconOutlined,
            size: 24,
            color: isActive ? bcgPrimary : bcgFgMuted,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              color: isActive ? bcgPrimary : bcgFgMuted,
            ),
          ),
        ],
      ),
    ),
  );
}
```

---

## Safe area

```css
/* CSS — handled by viewport meta and padding vars */
padding-top: env(safe-area-inset-top);
padding-bottom: env(safe-area-inset-bottom);
```

```dart
// Flutter — SafeArea widget
SafeArea(
  child: Column(
    children: [
      // content here
    ],
  ),
)

// For bottom nav, combine with MediaQuery.of(context).padding:
MediaQuery.of(context).padding.bottom  // bottom inset
MediaQuery.of(context).padding.top     // top inset
```
