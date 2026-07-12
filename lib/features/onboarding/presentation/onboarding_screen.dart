import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../design/colors/bcg_colors.dart';
import '../../../design/spacing/bcg_spacing.dart';
import '../../../design/spacing/bcg_radius.dart';
import '../../auth/domain/auth_failure.dart';
import '../application/onboarding_controller.dart';
import '../domain/onboarding_step.dart';
import '../../pairing/domain/pairing_failure.dart';

/// Onboarding screen - matches design/prototype/beaconnect-app.html
/// 6-step onboarding with pill navigation dots
class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingControllerProvider);
    final controller = ref.read(onboardingControllerProvider.notifier);

    return Scaffold(
      backgroundColor: BcgColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Content area
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  BcgSpacing.s8,
                  BcgSpacing.s12,
                  BcgSpacing.s8,
                  BcgSpacing.s8,
                ),
                child: _buildContent(context, ref, state, controller),
              ),
            ),

            // Bottom actions with dots
            Padding(
              padding: const EdgeInsets.fromLTRB(
                BcgSpacing.s6,
                BcgSpacing.s4,
                BcgSpacing.s6,
                BcgSpacing.s8,
              ),
              child: Column(
                children: [
                  // Dots
                  _OnboardingDots(
                    currentIndex: state.step.index,
                    total: OnboardingStep.values.length,
                  ),
                  const SizedBox(height: BcgSpacing.s4),

                  // Primary button
                  _PrimaryButton(
                    label: _getPrimaryLabel(state.step),
                    isLoading: state.isWorking,
                    onPressed: () => _handlePrimary(context, ref, state, controller),
                  ),

                  // Secondary button (if needed)
                  if (_showSecondary(state.step)) ...[
                    const SizedBox(height: BcgSpacing.s3),
                    _SecondaryButton(
                      label: _getSecondaryLabel(state.step),
                      onPressed: () => _handleSecondary(context, ref, state, controller),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    OnboardingState state,
    OnboardingController controller,
  ) {
    switch (state.step) {
      case OnboardingStep.welcome:
        return _OnboardingContent(
          eyebrow: 'Beaconnect',
          headline: 'Built for reassurance,\nnot surveillance.',
          body: 'Beaconnect helps two people quietly stay connected through mutual sharing and simple check-ins.',
          note: 'No tracking. No feeds. Just reassurance that the people you care about are okay.',
          noteWarning: false,
        );

      case OnboardingStep.account:
        return _OnboardingContent(
          eyebrow: 'Your account',
          headline: state.isSignUp
              ? 'Create your account.'
              : 'Sign in to your account.',
          body: state.isSignUp
              ? 'Use your email and password to create your Beaconnect account.'
              : 'Use the email and password you already chose for Beaconnect.',
          inputLabel: 'Email',
          inputHint: 'name@example.com',
          inputValue: state.email,
          onInputChanged: controller.updateEmail,
          keyboardType: TextInputType.emailAddress,
          secondaryInputLabel: 'Password',
          secondaryInputHint: 'At least 6 characters',
          secondaryInputValue: state.password,
          onSecondaryInputChanged: controller.updatePassword,
          obscureSecondaryInput: true,
          tertiaryInputLabel: state.isSignUp ? 'Confirm password' : null,
          tertiaryInputHint: 'Repeat your password',
          tertiaryInputValue: state.isSignUp ? state.confirmPassword : null,
          onTertiaryInputChanged: state.isSignUp ? controller.updateConfirmPassword : null,
          obscureTertiaryInput: true,
          tertiaryActionLabel: state.isSignUp
              ? 'Already have an account? Sign in'
              : 'Need an account? Sign up',
          onTertiaryAction: state.isSignUp
              ? controller.showSignIn
              : controller.showSignUp,
          authMessage: state.authMessage,
        );

      case OnboardingStep.pairing:
        return _OnboardingContent(
          eyebrow: 'Pairing',
          headline: 'Beaconnect only works when both people agree.',
          body: 'Connections are always mutual and can be ended at any time by either person.',
          note: 'Sarah will need to install Beaconnect and enter the same code to connect with you.',
          noteWarning: true,
          inputLabel: 'Partner code',
          inputHint: 'Enter their code',
          inputValue: state.enteredInviteCode,
          onInputChanged: controller.updateInviteCode,
          textCapitalization: TextCapitalization.characters,
          detail: 'Your code: ${state.inviteCode}\nExpires in ${state.expiresInMinutes} minutes.',
          authMessage: state.authMessage,
        );

      case OnboardingStep.permissions:
        return _OnboardingContent(
          eyebrow: 'Permissions',
          headline: 'Location access',
          body: 'Beaconnect uses your location to share with Sarah — only when you choose to, and only visible to her.',
          child: _PermissionCard(
            whyTitle: 'Why does Beaconnect need this?',
            description: 'So Sarah can see where you are when you choose to share — not all the time, only during live sharing sessions.',
            statusLabel: 'Enabled',
            isEnabled: true,
          ),
        );

      case OnboardingStep.connected:
        return _OnboardingContent(
          eyebrow: 'Connected',
          headline: 'You\'re connected with Sarah.',
          body: 'Try your first check-in. Sarah will see it right away.',
          checks: ['Sarah is ready to receive your check-in.'],
        );

      case OnboardingStep.success:
        return _OnboardingContent(
          eyebrow: 'Success',
          headline: 'Sarah now knows you\'re around.',
          body: 'You\'re ready to quietly stay connected. Beaconnect stays out of your way — it only speaks up when something meaningful happens.',
          icon: Icons.check_circle,
          iconColor: BcgColors.success,
          iconBg: BcgColors.successBg,
        );
    }
  }

  String _getPrimaryLabel(OnboardingStep step) {
    return switch (step) {
      OnboardingStep.welcome => 'Get Started',
      OnboardingStep.account => 'Continue',
      OnboardingStep.pairing => 'Generate Code',
      OnboardingStep.permissions => 'Continue',
      OnboardingStep.connected => 'I\'m Okay',
      OnboardingStep.success => 'Open Home',
    };
  }

  bool _showSecondary(OnboardingStep step) {
    return step == OnboardingStep.pairing;
  }

  String _getSecondaryLabel(OnboardingStep step) {
    return switch (step) {
      OnboardingStep.pairing => 'Skip for now',
      _ => 'Back',
    };
  }

  Future<void> _handlePrimary(
    BuildContext context,
    WidgetRef ref,
    OnboardingState state,
    OnboardingController controller,
  ) async {
    switch (state.step) {
      case OnboardingStep.welcome:
        controller.next();
        break;

      case OnboardingStep.account:
        if (state.email.isEmpty) {
          controller.showAuthMessage('Add your email to continue.');
          return;
        }
        if (state.password.length < 6) {
          controller.showAuthMessage('Choose a password with at least 6 characters.');
          return;
        }
        if (state.isSignUp && state.password != state.confirmPassword) {
          controller.showAuthMessage('Make sure both passwords match.');
          return;
        }
        controller.startWork();
        try {
          final user = state.isSignUp
              ? await ref.read(signUpWithEmailUseCaseProvider).call(
                    email: state.email,
                    password: state.password,
                  )
              : await ref.read(signInWithEmailUseCaseProvider).call(
                    email: state.email,
                    password: state.password,
                  );
          ref.read(currentUserProvider.notifier).state = user;
          final prepared = await ref.read(createInviteCodeUseCaseProvider).call(
                currentUser: user,
              );
          ref.read(currentPairProvider.notifier).state = prepared;
          await controller.signIn(user);
          await controller.preparePairing(prepared);
        } on AuthFailure catch (error) {
          controller.showAuthMessage(error.message);
        } catch (_) {
          controller.showAuthMessage('We could not sign you in just yet. Please try again in a moment.');
        }
        break;

      case OnboardingStep.pairing:
        controller.startWork();
        try {
          final inviteCode = state.enteredInviteCode;
          if (inviteCode.isEmpty) {
            controller.showAuthMessage('Enter your partner\'s code, or pair later for now.');
            return;
          }
          final user = state.currentUser;
          if (user == null) return;
          final approved = await ref.read(approvePairingUseCaseProvider).call(
                currentUser: user,
                inviteCode: inviteCode,
              );
          ref.read(currentPairProvider.notifier).state = approved;
          await controller.approvePairing(approved);
        } on PairingFailure catch (error) {
          controller.showAuthMessage(error.message);
        } catch (_) {
          controller.showAuthMessage('Something did not go as expected. Please try again.');
        }
        break;

      case OnboardingStep.permissions:
        controller.startWork();
        await ref.read(enablePermissionEducationUseCaseProvider).call();
        ref.invalidate(permissionStatusProvider);
        await Future<void>.delayed(const Duration(milliseconds: 150));
        controller.next();
        controller.stopWork();
        break;

      case OnboardingStep.connected:
        controller.startWork();
        try {
          final user = state.currentUser;
          if (user == null) {
            controller.showAuthMessage('Something did not go as expected.');
            return;
          }
          final confirmed = await ref.read(confirmPairingUseCaseProvider).call(
                currentUser: user,
              );
          await controller.confirmPairing(confirmed);
        } on PairingFailure catch (error) {
          controller.showAuthMessage(error.message);
        } catch (_) {
          controller.showAuthMessage('Something did not go as expected.');
        }
        break;

      case OnboardingStep.success:
        ref.read(onboardingCompletedProvider.notifier).state = true;
        await ref.read(sharedPreferencesProvider).setBool(
              onboardingCompletePreferenceKey,
              true,
            );
        if (context.mounted) {
          context.go('/');
        }
        break;
    }
  }

  Future<void> _handleSecondary(
    BuildContext context,
    WidgetRef ref,
    OnboardingState state,
    OnboardingController controller,
  ) async {
    if (state.step == OnboardingStep.pairing) {
      controller.startWork();
      await ref.read(skipPairingUseCaseProvider).call();
      ref.read(currentPairProvider.notifier).state = null;
      ref.read(onboardingCompletedProvider.notifier).state = true;
      await ref.read(sharedPreferencesProvider).setBool(
            onboardingCompletePreferenceKey,
            true,
          );
      await controller.skipPairing();
      if (context.mounted) {
        context.go('/');
      }
    } else {
      controller.back();
    }
  }
}

/// Onboarding content widget
class _OnboardingContent extends StatelessWidget {
  const _OnboardingContent({
    this.eyebrow = '',
    this.headline = '',
    this.body = '',
    this.note,
    this.noteWarning = false,
    this.icon,
    this.iconColor,
    this.iconBg,
    this.checks,
    this.inputLabel,
    this.inputHint,
    this.inputValue,
    this.onInputChanged,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.secondaryInputLabel,
    this.secondaryInputHint,
    this.secondaryInputValue,
    this.onSecondaryInputChanged,
    this.obscureSecondaryInput = false,
    this.tertiaryInputLabel,
    this.tertiaryInputHint,
    this.tertiaryInputValue,
    this.onTertiaryInputChanged,
    this.obscureTertiaryInput = false,
    this.tertiaryActionLabel,
    this.onTertiaryAction,
    this.authMessage,
    this.detail,
    this.child,
  });

  final String eyebrow;
  final String headline;
  final String body;
  final String? note;
  final bool noteWarning;
  final IconData? icon;
  final Color? iconColor;
  final Color? iconBg;
  final List<String>? checks;
  final String? inputLabel;
  final String? inputHint;
  final String? inputValue;
  final ValueChanged<String>? onInputChanged;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final String? secondaryInputLabel;
  final String? secondaryInputHint;
  final String? secondaryInputValue;
  final ValueChanged<String>? onSecondaryInputChanged;
  final bool obscureSecondaryInput;
  final String? tertiaryInputLabel;
  final String? tertiaryInputHint;
  final String? tertiaryInputValue;
  final ValueChanged<String>? onTertiaryInputChanged;
  final bool obscureTertiaryInput;
  final String? tertiaryActionLabel;
  final VoidCallback? onTertiaryAction;
  final String? authMessage;
  final String? detail;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Optional icon
        if (icon != null) ...[
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: iconBg ?? BcgColors.primary,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Icon(
              icon,
              size: 36,
              color: iconColor ?? BcgColors.primaryFg,
            ),
          ),
          const SizedBox(height: BcgSpacing.s6),
        ],

        // Eyebrow
        Text(
          eyebrow,
          style: TextStyle(
            fontFamily: 'IBM Plex Mono',
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: BcgColors.primary,
            letterSpacing: 0.1,
          ),
        ),
        const SizedBox(height: BcgSpacing.s4),

        // Headline
        Text(
          headline,
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 28,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.03,
            height: 1.2,
            color: BcgColors.fg,
          ),
        ),
        const SizedBox(height: BcgSpacing.s4),

        // Body
        Text(
          body,
          style: TextStyle(
            fontSize: 15,
            height: 1.65,
            color: BcgColors.fgMuted,
          ),
        ),

        // Inputs
        if (inputLabel != null) ...[
          const SizedBox(height: BcgSpacing.s5),
          _PrototypeTextField(
            label: inputLabel!,
            hint: inputHint,
            value: inputValue ?? '',
            onChanged: onInputChanged,
            keyboardType: keyboardType,
            textCapitalization: textCapitalization,
          ),
        ],
        if (secondaryInputLabel != null) ...[
          const SizedBox(height: BcgSpacing.s4),
          _PrototypeTextField(
            label: secondaryInputLabel!,
            hint: secondaryInputHint,
            value: secondaryInputValue ?? '',
            onChanged: onSecondaryInputChanged,
            obscureText: obscureSecondaryInput,
          ),
        ],
        if (tertiaryInputLabel != null) ...[
          const SizedBox(height: BcgSpacing.s4),
          _PrototypeTextField(
            label: tertiaryInputLabel!,
            hint: tertiaryInputHint,
            value: tertiaryInputValue ?? '',
            onChanged: onTertiaryInputChanged,
            obscureText: obscureTertiaryInput,
          ),
        ],
        if (tertiaryActionLabel != null && onTertiaryAction != null) ...[
          const SizedBox(height: BcgSpacing.s2),
          GestureDetector(
            onTap: onTertiaryAction,
            child: Text(
              tertiaryActionLabel!,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: BcgColors.primary,
              ),
            ),
          ),
        ],

        // Note
        if (note != null) ...[
          const SizedBox(height: BcgSpacing.s8),
          Container(
            padding: const EdgeInsets.all(BcgSpacing.s4),
            decoration: BoxDecoration(
              color: noteWarning ? BcgColors.cautionBg : BcgColors.surfaceVariant,
              borderRadius: BcgRadius.borderMd,
              border: noteWarning
                  ? const Border(left: BorderSide(color: BcgColors.caution, width: 3))
                  : null,
            ),
            child: Text(
              note!,
              style: TextStyle(
                fontSize: 13,
                height: 1.55,
                color: BcgColors.fgMuted,
              ),
            ),
          ),
        ],

        // Checks
        if (checks != null && checks!.isNotEmpty) ...[
          const SizedBox(height: BcgSpacing.s4),
          ...checks!.map((check) => Padding(
                padding: const EdgeInsets.only(bottom: BcgSpacing.s3),
                child: Row(
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
                        check,
                        style: TextStyle(
                          fontSize: 14,
                          color: BcgColors.fg,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],

        // Child widget (for permission card etc.)
        if (child != null) ...[
          const SizedBox(height: BcgSpacing.s8),
          child!,
        ],

        // Detail
        if (detail != null) ...[
          const SizedBox(height: BcgSpacing.s8),
          Container(
            padding: const EdgeInsets.all(BcgSpacing.s4),
            decoration: BoxDecoration(
              color: BcgColors.surfaceVariant,
              borderRadius: BcgRadius.borderMd,
            ),
            child: Text(
              detail!,
              style: TextStyle(
                fontFamily: 'IBM Plex Mono',
                fontSize: 12,
                color: BcgColors.fgMuted,
              ),
            ),
          ),
        ],

        // Auth message
        if (authMessage != null) ...[
          const SizedBox(height: BcgSpacing.s4),
          Text(
            authMessage!,
            style: TextStyle(
              fontSize: 13,
              color: BcgColors.critical,
            ),
          ),
        ],
      ],
    );
  }
}

class _PrototypeTextField extends StatelessWidget {
  const _PrototypeTextField({
    required this.label,
    required this.value,
    this.hint,
    this.onChanged,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.obscureText = false,
  });

  final String label;
  final String value;
  final String? hint;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: value,
      onChanged: onChanged,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      obscureText: obscureText,
      autocorrect: false,
      enableSuggestions: !obscureText,
      style: const TextStyle(
        fontSize: 15,
        color: BcgColors.fg,
      ),
      decoration: InputDecoration(
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
      ),
    );
  }
}

/// Permission card widget
class _PermissionCard extends StatelessWidget {
  const _PermissionCard({
    required this.whyTitle,
    required this.description,
    required this.statusLabel,
    required this.isEnabled,
  });

  final String whyTitle;
  final String description;
  final String statusLabel;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(BcgSpacing.s5),
      decoration: BoxDecoration(
        color: BcgColors.surfaceVariant,
        borderRadius: BcgRadius.borderMd,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            whyTitle,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: BcgColors.fg,
            ),
          ),
          const SizedBox(height: BcgSpacing.s2),
          Text(
            description,
            style: TextStyle(
              fontSize: 13,
              color: BcgColors.fgMuted,
            ),
          ),
          const SizedBox(height: BcgSpacing.s3),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isEnabled ? BcgColors.successBg : BcgColors.cautionBg,
              borderRadius: BorderRadius.circular(9999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isEnabled ? Icons.check_circle : Icons.warning,
                  size: 12,
                  color: isEnabled ? BcgColors.success : BcgColors.caution,
                ),
                const SizedBox(width: 6),
                Text(
                  statusLabel,
                  style: TextStyle(
                    fontFamily: 'IBM Plex Mono',
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isEnabled ? BcgColors.success : BcgColors.caution,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Onboarding dots indicator
class _OnboardingDots extends StatelessWidget {
  const _OnboardingDots({required this.currentIndex, required this.total});

  final int currentIndex;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (index) {
        final isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isActive ? 20 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: isActive ? BcgColors.primary : BcgColors.outlineStrong,
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}

/// Primary button
class _PrimaryButton extends StatefulWidget {
  const _PrimaryButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback onPressed;
  final bool isLoading;

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
      onTap: widget.isLoading ? null : widget.onPressed,
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
          child: widget.isLoading
              ? Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(BcgColors.primaryFg),
                    ),
                  ),
                )
              : Text(
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

/// Secondary ghost button
class _SecondaryButton extends StatelessWidget {
  const _SecondaryButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: BcgSpacing.s3),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'IBM Plex Sans',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: BcgColors.fgMuted,
          ),
        ),
      ),
    );
  }
}
