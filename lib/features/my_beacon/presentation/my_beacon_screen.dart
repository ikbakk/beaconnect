import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../design/colors/bcg_colors.dart';
import '../../../design/spacing/bcg_spacing.dart';
import '../../../design/spacing/bcg_radius.dart';
import '../domain/my_beacon_preferences.dart';

/// My Beacon screen - matches design/prototype/beaconnect-app.html
class MyBeaconScreen extends ConsumerStatefulWidget {
  const MyBeaconScreen({super.key});

  @override
  ConsumerState<MyBeaconScreen> createState() => _MyBeaconScreenState();
}

class _MyBeaconScreenState extends ConsumerState<MyBeaconScreen> {
  final _messageController = TextEditingController();
  String _pairSymbol = '★';

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prefs = ref.watch(myBeaconPreferencesProvider);

    return Scaffold(
      backgroundColor: BcgColors.surface,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(
                BcgSpacing.s5,
                BcgSpacing.s3 + 4,
                BcgSpacing.s5,
                BcgSpacing.s4,
              ),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: BcgColors.outline, width: 0.5),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.arrow_back, size: 16, color: BcgColors.fgMuted),
                        const SizedBox(width: 4),
                        Text(
                          'Settings',
                          style: TextStyle(
                            fontSize: 13,
                            color: BcgColors.fgMuted,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: BcgSpacing.s2),
                  Text(
                    'My Beacon',
                    style: TextStyle(
                      fontFamily: 'IBM Plex Mono',
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: BcgColors.fgMuted,
                      letterSpacing: 0.08,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Personalize your experience',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.03,
                      color: BcgColors.fg,
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: prefs.when(
                data: (preferences) {
                  // Initialize controllers with saved values
                  if (_messageController.text.isEmpty) {
                    _messageController.text = preferences.checkInMessage;
                    _pairSymbol = preferences.pairSymbol;
                  }

                  return ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      // Check-in Messages
                      _BeaconModule(
                        label: 'Check-in Messages',
                        description: 'Personalize the short message used when you check in.',
                        currentLabel: 'Currently using:',
                        chips: [_Chip(label: '"${_messageController.text}"')],
                        child: TextField(
                          controller: _messageController,
                          decoration: _inputDecoration(
                            label: 'Check-in message',
                            hint: 'I\'m Okay',
                          ),
                        ),
                        actionLabel: 'Save with changes →',
                        onAction: _savePreferences,
                      ),

                      // Pair Symbol
                      _BeaconModule(
                        label: 'Pair Symbol',
                        description: 'Choose the symbol shown next to your partner\'s name.',
                        currentLabel: 'Current:',
                        chips: [_Chip(label: _pairSymbol)],
                        child: Wrap(
                          spacing: BcgSpacing.s2,
                          children: ['★', '✦', '♥'].map((symbol) {
                            return _SelectableSymbolChip(
                              symbol: symbol,
                              isSelected: _pairSymbol == symbol,
                              onTap: () => setState(() => _pairSymbol = symbol),
                            );
                          }).toList(),
                        ),
                        actionLabel: 'Save with changes →',
                        onAction: _savePreferences,
                      ),

                      // Home Screen Widget
                      _BeaconModule(
                        label: 'Home Screen Widget',
                        description: 'Add a quick reassurance glance to your Android home screen.',
                        chips: [],
                        trailing: _Badge(label: 'Active', variant: 'success'),
                        actionLabel: 'Configure →',
                        onAction: () => context.go('/home/widget'),
                      ),

                      // Quiet Hours
                      _BeaconModule(
                        label: 'Quiet Hours',
                        description: 'Pause notifications during set hours so Beaconnect stays calm at night.',
                        currentLabel: null,
                        chips: [],
                        trailing: _Badge(label: '10:00 PM – 7:00 AM', variant: 'warn'),
                        actionLabel: 'Edit →',
                        onAction: () => _showCalmToast('Quiet hours editor is not ready yet.'),
                      ),

                      // Appearance
                      _BeaconModule(
                        label: 'Appearance',
                        description: 'Choose how Beaconnect looks on your screen.',
                        currentLabel: 'Current:',
                        chips: [_Chip(label: 'System default')],
                        actionLabel: 'Change →',
                        onAction: () => _showCalmToast('Appearance follows your system setting for now.'),
                      ),

                      // Accessibility
                      _BeaconModule(
                        label: 'Accessibility',
                        description: 'Adjust text size, motion, and screen reader settings.',
                        chips: [],
                        actionLabel: 'Open →',
                        onAction: () => _showCalmToast('Accessibility uses your device settings for now.'),
                      ),

                      // Save button
                      Padding(
                        padding: const EdgeInsets.all(BcgSpacing.s5),
                        child: _PrimaryButton(
                          label: 'Save Changes',
                          onPressed: _savePreferences,
                        ),
                      ),
                    ],
                  );
                },
                error: (_, __) => _ErrorState(
                  onRetry: () => ref.invalidate(myBeaconPreferencesProvider),
                ),
                loading: () => const Center(
                  child: Text('Loading your choices…'),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({required String label, String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: const TextStyle(color: BcgColors.fgMuted),
      hintStyle: const TextStyle(color: BcgColors.fgMuted),
      filled: true,
      fillColor: BcgColors.surface,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: BcgSpacing.s4,
        vertical: BcgSpacing.s3 + 2,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BcgRadius.borderMd,
        borderSide: const BorderSide(color: BcgColors.outline, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BcgRadius.borderMd,
        borderSide: const BorderSide(color: BcgColors.primary, width: 1.5),
      ),
    );
  }

  Future<void> _savePreferences() async {
    await ref.read(saveMyBeaconPreferencesUseCaseProvider).call(
      MyBeaconPreferences(
        pairSymbol: _pairSymbol,
        checkInMessage: _messageController.text.trim().isEmpty
            ? 'I\'m Okay'
            : _messageController.text.trim(),
      ),
    );
    ref.invalidate(myBeaconPreferencesProvider);
    ref.invalidate(homeSnapshotProvider);
    _showCalmToast('Your choices were updated.');
  }

  void _showCalmToast(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class _BeaconModule extends StatelessWidget {
  const _BeaconModule({
    required this.label,
    required this.description,
    this.currentLabel,
    required this.chips,
    this.trailing,
    this.child,
    required this.actionLabel,
    required this.onAction,
  });

  final String label;
  final String description;
  final String? currentLabel;
  final List<Widget> chips;
  final Widget? trailing;
  final Widget? child;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(BcgSpacing.s4),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: BcgColors.outline, width: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: BcgColors.fg,
            ),
          ),

          const SizedBox(height: 4),

          // Description
          Text(
            description,
            style: TextStyle(
              fontSize: 13,
              color: BcgColors.fgMuted,
            ),
          ),

          // Current value / chips
          if (chips.isNotEmpty) ...[
            const SizedBox(height: BcgSpacing.s3),
            Wrap(
              spacing: BcgSpacing.s2,
              runSpacing: BcgSpacing.s2,
              children: [
                if (currentLabel != null)
                  Text(
                    currentLabel!,
                    style: TextStyle(
                      fontSize: 13,
                      color: BcgColors.fgMuted,
                    ),
                  ),
                ...chips,
              ],
            ),
          ],

          if (child != null) ...[
            const SizedBox(height: BcgSpacing.s3),
            child!,
          ],

          // Trailing widget (e.g., badge)
          if (trailing != null && chips.isEmpty) ...[
            const SizedBox(height: BcgSpacing.s3),
            trailing!,
          ],

          // Action
          const SizedBox(height: BcgSpacing.s3),
          GestureDetector(
            onTap: onAction,
            child: Text(
              actionLabel,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: BcgColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectableSymbolChip extends StatelessWidget {
  const _SelectableSymbolChip({
    required this.symbol,
    required this.isSelected,
    required this.onTap,
  });

  final String symbol;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? BcgColors.primary : BcgColors.surfaceVariant,
          borderRadius: BcgRadius.borderMd,
          border: Border.all(
            color: isSelected ? BcgColors.primary : BcgColors.outline,
          ),
        ),
        child: Text(
          symbol,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isSelected ? BcgColors.primaryFg : BcgColors.fg,
          ),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: BcgColors.surfaceVariant,
        borderRadius: BorderRadius.circular(BcgRadius.sm),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'IBM Plex Mono',
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: BcgColors.fg,
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.variant});

  final String label;
  final String variant; // 'success', 'warn'

  @override
  Widget build(BuildContext context) {
    final bgColor = variant == 'success' ? BcgColors.successBg : BcgColors.cautionBg;
    final textColor = variant == 'success' ? BcgColors.success : BcgColors.caution;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'IBM Plex Mono',
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatefulWidget {
  const _PrimaryButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  State<_PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<_PrimaryButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        transform: Matrix4.identity()..scale(_isPressed ? 0.97 : 1.0),
        transformAlignment: Alignment.center,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: BcgSpacing.s6,
            vertical: BcgSpacing.s5 - 2,
          ),
          decoration: BoxDecoration(
            color: _isPressed ? BcgColors.primaryHover : BcgColors.primary,
            borderRadius: BcgRadius.borderLg,
          ),
          child: Text(
            widget.label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'IBM Plex Sans',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.01,
              color: BcgColors.primaryFg,
            ),
          ),
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Something did not go as expected.',
            style: TextStyle(
              fontSize: 16,
              color: BcgColors.fg,
            ),
          ),
          const SizedBox(height: BcgSpacing.s4),
          OutlinedButton(
            onPressed: onRetry,
            child: const Text('Try again'),
          ),
        ],
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({
    required this.currentRoute,
    required this.onHome,
    required this.onUpdates,
    required this.onSettings,
  });

  final String currentRoute;
  final VoidCallback onHome;
  final VoidCallback onUpdates;
  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: BcgSpacing.navH,
      decoration: BoxDecoration(
        color: BcgColors.surfaceOverlay,
        border: const Border(
          top: BorderSide(color: BcgColors.outline, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          _NavButton(
            label: 'Home',
            icon: Icons.home_rounded,
            isActive: currentRoute == '/',
            onTap: onHome,
          ),
          _NavButton(
            label: 'Updates',
            icon: Icons.notifications_outlined,
            isActive: currentRoute == '/updates',
            onTap: onUpdates,
          ),
          _NavButton(
            label: 'Settings',
            icon: Icons.settings_outlined,
            isActive: currentRoute == '/settings',
            onTap: onSettings,
          ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (isActive)
              Positioned(
                left: 12,
                right: 12,
                top: 6,
                bottom: 6,
                child: Container(
                  decoration: BoxDecoration(
                    color: BcgColors.primary.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                ),
              ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 24,
                  color: isActive ? BcgColors.primary : BcgColors.fgMuted,
                ),
                const SizedBox(height: 3),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                    color: isActive ? BcgColors.primary : BcgColors.fgMuted,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
