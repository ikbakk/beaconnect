import 'package:flutter/material.dart';
import '../colors/bcg_colors.dart';
import '../spacing/bcg_spacing.dart';
import '../spacing/bcg_radius.dart';
import '../typography/bcg_typography.dart';
import 'bcg_buttons.dart';

/// Onboarding page data
class BcgOnboardingPageData {
  const BcgOnboardingPageData({
    required this.eyebrow,
    required this.headline,
    required this.body,
    this.note,
    this.noteWarning = false,
    this.icon,
    this.checks,
  });

  final String eyebrow;
  final String headline;
  final String body;
  final String? note;
  final bool noteWarning;
  final IconData? icon;
  final List<String>? checks;
}

/// Onboarding screen with dot indicators
class BcgOnboardingScreen extends StatelessWidget {
  const BcgOnboardingScreen({
    super.key,
    required this.pages,
    required this.currentIndex,
    required this.onNext,
    required this.onSkip,
    this.primaryActionLabel,
    this.secondaryActionLabel,
    this.onPrimaryAction,
  });

  final List<BcgOnboardingPageData> pages;
  final int currentIndex;
  final VoidCallback onNext;
  final VoidCallback onSkip;
  final String? primaryActionLabel;
  final String? secondaryActionLabel;
  final VoidCallback? onPrimaryAction;

  bool get isLastPage => currentIndex >= pages.length - 1;

  @override
  Widget build(BuildContext context) {
    final page = pages[currentIndex];

    return Container(
      color: BcgColors.surface,
      child: Column(
        children: [
          // Top section with content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                BcgSpacing.s8,
                BcgSpacing.s12,
                BcgSpacing.s8,
                BcgSpacing.s8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Optional icon
                  if (page.icon != null) ...[
                    _OnboardingIcon(icon: page.icon!),
                    const SizedBox(height: BcgSpacing.s6),
                  ],

                  // Eyebrow
                  Text(
                    page.eyebrow,
                    style: BcgTypography.eyebrow,
                  ),
                  const SizedBox(height: BcgSpacing.s4),

                  // Headline
                  Text(
                    page.headline,
                    style: BcgTypography.displayLarge,
                  ),
                  const SizedBox(height: BcgSpacing.s4),

                  // Body
                  Text(
                    page.body,
                    style: BcgTypography.bodySmall.copyWith(
                      color: BcgColors.fgMuted,
                      height: 1.65,
                    ),
                  ),
                  const SizedBox(height: BcgSpacing.s6),

                  // Note
                  if (page.note != null)
                    _OnboardingNote(
                      text: page.note!,
                      isWarning: page.noteWarning,
                    ),

                  // Checks
                  if (page.checks != null && page.checks!.isNotEmpty) ...[
                    const SizedBox(height: BcgSpacing.s4),
                    ...page.checks!.map((check) => Padding(
                          padding:
                              const EdgeInsets.only(bottom: BcgSpacing.s3),
                          child: _OnboardingCheck(text: check),
                        )),
                  ],
                ],
              ),
            ),
          ),

          // Bottom actions
          Padding(
            padding: const EdgeInsets.fromLTRB(
              BcgSpacing.s6,
              BcgSpacing.s4,
              BcgSpacing.s6,
              BcgSpacing.s8,
            ),
            child: Column(
              children: [
                // Dot indicators
                _OnboardingDots(
                  count: pages.length,
                  currentIndex: currentIndex,
                ),
                const SizedBox(height: BcgSpacing.s4),

                // Primary button
                BcgButton(
                  label: primaryActionLabel ??
                      (isLastPage ? 'Done' : 'Continue'),
                  onPressed: onPrimaryAction ?? onNext,
                ),

                // Secondary button (skip)
                if (!isLastPage && secondaryActionLabel != null) ...[
                  const SizedBox(height: BcgSpacing.s3),
                  BcgButton(
                    label: secondaryActionLabel!,
                    onPressed: onSkip,
                    variant: BcgButtonVariant.ghost,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingIcon extends StatelessWidget {
  const _OnboardingIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: BcgColors.primary,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Icon(
        icon,
        size: 36,
        color: BcgColors.primaryFg,
      ),
    );
  }
}

class _OnboardingNote extends StatelessWidget {
  const _OnboardingNote({
    required this.text,
    this.isWarning = false,
  });

  final String text;
  final bool isWarning;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(BcgSpacing.s4),
      decoration: BoxDecoration(
        color:
            isWarning ? BcgColors.cautionBg : BcgColors.surfaceVariant,
        borderRadius: BcgRadius.borderMd,
        border: isWarning
            ? const Border(
                left: BorderSide(
                  color: BcgColors.caution,
                  width: 3,
                ),
              )
            : null,
      ),
      child: Text(
        text,
        style: BcgTypography.labelSmall,
      ),
    );
  }
}

class _OnboardingCheck extends StatelessWidget {
  const _OnboardingCheck({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: BcgColors.successBg,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check,
            size: 12,
            color: BcgColors.success,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: BcgTypography.bodySmall,
          ),
        ),
      ],
    );
  }
}

class _OnboardingDots extends StatelessWidget {
  const _OnboardingDots({
    required this.count,
    required this.currentIndex,
  });

  final int count;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isActive ? 20 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: isActive ? BcgColors.primary : BcgColors.outlineStrong,
            borderRadius: BorderRadius.circular(isActive ? 3 : 3),
          ),
        );
      }),
    );
  }
}
