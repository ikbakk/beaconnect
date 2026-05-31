import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../application/onboarding_controller.dart';
import '../domain/onboarding_step.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingControllerProvider);
    final controller = ref.read(onboardingControllerProvider.notifier);
    final theme = Theme.of(context);

    final content = switch (state.step) {
      OnboardingStep.welcome => _OnboardingContent(
        eyebrow: 'Welcome',
        title: 'A quieter way to stay close.',
        body:
            'Beaconnect helps two people quietly stay present in each other\'s lives through intentional, mutual sharing.',
        primaryLabel: 'Get started',
        onPrimary: controller.next,
      ),
      OnboardingStep.account => _OnboardingContent(
        eyebrow: 'Your account',
        title: 'Use your email and password.',
        body:
            'Choose a private sign-in you can remember easily. Beaconnect will use the name from your email unless you change it later.',
        primaryLabel: 'Continue',
        onPrimary: () async {
          if (state.email.isEmpty) {
            controller.showAuthMessage('Add your email to continue.');
            return;
          }
          if (state.password.length < 6) {
            controller.showAuthMessage(
              'Choose a password with at least 6 characters.',
            );
            return;
          }
          if (state.password != state.confirmPassword) {
            controller.showAuthMessage('Make sure both passwords match.');
            return;
          }
          controller.startWork();
          try {
            final user = await ref
                .read(signInWithEmailUseCaseProvider)
                .call(email: state.email, password: state.password);
            ref.read(currentUserProvider.notifier).state = user;
            await controller.signIn(user);
          } catch (_) {
            controller.showAuthMessage(
              'Something did not go as expected. Please check your email and password and try again.',
            );
          }
        },
        secondaryLabel: 'Back',
        onSecondary: controller.back,
        inputLabel: 'Email',
        inputValue: state.email,
        onChanged: controller.updateEmail,
        secondaryInputLabel: 'Password',
        secondaryInputValue: state.password,
        onSecondaryChanged: controller.updatePassword,
        obscureSecondaryInput: true,
        tertiaryInputLabel: 'Confirm password',
        tertiaryInputValue: state.confirmPassword,
        onTertiaryChanged: controller.updateConfirmPassword,
        obscureTertiaryInput: true,
      ),
      OnboardingStep.pairing => _OnboardingContent(
        eyebrow: 'Pairing',
        title: 'Connections are always mutual.',
        body:
            'Create a one-time code for your partner, or enter a code they shared with you.',
        detail:
            'Your code: ${state.inviteCode}\nExpires in ${state.expiresInMinutes} minutes.',
        primaryLabel: 'Continue',
        inputLabel: 'Partner code',
        inputValue: state.enteredInviteCode,
        onChanged: controller.updateInviteCode,
        onPrimary: () async {
          final user = state.currentUser;
          if (user == null) {
            return;
          }
          controller.startWork();
          String? inviteCode = state.enteredInviteCode;
          if (inviteCode.isEmpty) {
            final prepared = await ref
                .read(createInviteCodeUseCaseProvider)
                .call(currentUser: user);
            inviteCode = prepared.inviteCode;
            await controller.preparePairing(prepared);
          }
          final approved = await ref
              .read(approvePairingUseCaseProvider)
              .call(currentUser: user, inviteCode: inviteCode);
          ref.read(currentPairProvider.notifier).state = approved;
          await controller.approvePairing(approved);
        },
        secondaryLabel: 'Pair later',
        onSecondary: () async {
          controller.startWork();
          await ref.read(skipPairingUseCaseProvider).call();
          ref.read(currentPairProvider.notifier).state = null;
          ref.read(onboardingCompletedProvider.notifier).state = true;
          await ref
              .read(sharedPreferencesProvider)
              .setBool(onboardingCompletePreferenceKey, true);
          await controller.skipPairing();
          if (context.mounted) {
            context.go('/home');
          }
        },
      ),
      OnboardingStep.permissions => _OnboardingContent(
        eyebrow: 'Sharing works best when…',
        title: 'Explain before asking.',
        body:
            'Your current place helps Beaconnect show calm, meaningful updates. Notifications make check-ins easier to notice.',
        detail:
            'You stay in control. Beaconnect only works when both people choose to share.',
        primaryLabel: 'Continue',
        onPrimary: () async {
          controller.startWork();
          await ref.read(enablePermissionEducationUseCaseProvider).call();
          ref.invalidate(permissionStatusProvider);
          await Future<void>.delayed(const Duration(milliseconds: 150));
          controller.next();
          controller.stopWork();
        },
        secondaryLabel: 'Back',
        onSecondary: controller.back,
      ),
      OnboardingStep.connected => _OnboardingContent(
        eyebrow: 'Connected',
        title: 'You both approve before anything starts.',
        body:
            '${state.partnerDisplayName} will confirm names before Beaconnect begins sharing updates.',
        primaryLabel: 'Looks good',
        onPrimary: controller.next,
        secondaryLabel: 'Back',
        onSecondary: controller.back,
      ),
      OnboardingStep.success => _OnboardingContent(
        eyebrow: 'Success',
        title: 'Someone you care about now knows you\'re around.',
        body:
            'That is the first success Beaconnect is designed for. Everything else stays secondary.',
        primaryLabel: 'Continue to home',
        onPrimary: () async {
          ref.read(onboardingCompletedProvider.notifier).state = true;
          await ref
              .read(sharedPreferencesProvider)
              .setBool(onboardingCompletePreferenceKey, true);
          if (context.mounted) {
            context.go('/home');
          }
        },
        secondaryLabel: 'Back',
        onSecondary: controller.back,
      ),
    };

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(content.eyebrow, style: theme.textTheme.bodyMedium),
              const SizedBox(height: 16),
              Text(content.title, style: theme.textTheme.headlineMedium),
              const SizedBox(height: 16),
              Text(content.body, style: theme.textTheme.bodyLarge),
              if (content.detail case final detail?) ...[
                const SizedBox(height: 24),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(detail, style: theme.textTheme.titleMedium),
                  ),
                ),
              ],
              if (state.authMessage case final authMessage?) ...[
                const SizedBox(height: 16),
                Text(authMessage, style: theme.textTheme.bodyMedium),
              ],
              if (content.inputLabel case final inputLabel?) ...[
                const SizedBox(height: 16),
                TextField(
                  onChanged: content.onChanged,
                  controller: TextEditingController.fromValue(
                    TextEditingValue(
                      text: content.inputValue ?? '',
                      selection: TextSelection.collapsed(
                        offset: (content.inputValue ?? '').length,
                      ),
                    ),
                  ),
                  keyboardType: state.step == OnboardingStep.account
                      ? TextInputType.emailAddress
                      : TextInputType.text,
                  autocorrect: false,
                  enableSuggestions: state.step != OnboardingStep.account,
                  textCapitalization: state.step == OnboardingStep.account
                      ? TextCapitalization.none
                      : TextCapitalization.characters,
                  decoration: InputDecoration(
                    labelText: inputLabel,
                    hintText: state.step == OnboardingStep.account
                        ? 'name@example.com'
                        : 'Enter their code',
                    border: const OutlineInputBorder(),
                  ),
                ),
              ],
              if (content.secondaryInputLabel case final secondaryInputLabel?) ...[
                const SizedBox(height: 16),
                TextField(
                  onChanged: content.onSecondaryChanged,
                  controller: TextEditingController.fromValue(
                    TextEditingValue(
                      text: content.secondaryInputValue ?? '',
                      selection: TextSelection.collapsed(
                        offset: (content.secondaryInputValue ?? '').length,
                      ),
                    ),
                  ),
                  obscureText: content.obscureSecondaryInput,
                  autocorrect: false,
                  enableSuggestions: false,
                  decoration: InputDecoration(
                    labelText: secondaryInputLabel,
                    hintText: 'At least 6 characters',
                    border: const OutlineInputBorder(),
                  ),
                ),
              ],
              if (content.tertiaryInputLabel case final tertiaryInputLabel?) ...[
                const SizedBox(height: 16),
                TextField(
                  onChanged: content.onTertiaryChanged,
                  controller: TextEditingController.fromValue(
                    TextEditingValue(
                      text: content.tertiaryInputValue ?? '',
                      selection: TextSelection.collapsed(
                        offset: (content.tertiaryInputValue ?? '').length,
                      ),
                    ),
                  ),
                  obscureText: content.obscureTertiaryInput,
                  autocorrect: false,
                  enableSuggestions: false,
                  decoration: InputDecoration(
                    labelText: tertiaryInputLabel,
                    hintText: 'Repeat your password',
                    border: const OutlineInputBorder(),
                  ),
                ),
              ],
              const Spacer(),
              if (state.step == OnboardingStep.pairing) ...[
                Text(
                  'Either side can cancel at any time.',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
              ],
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: state.isWorking ? null : content.onPrimary,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Text(content.primaryLabel),
                ),
              ),
              if (content.secondaryLabel case final secondaryLabel?) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: state.isWorking ? null : content.onSecondary,
                    child: Text(secondaryLabel),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingContent {
  const _OnboardingContent({
    required this.eyebrow,
    required this.title,
    required this.body,
    required this.primaryLabel,
    required this.onPrimary,
    this.detail,
    this.secondaryLabel,
    this.onSecondary,
    this.inputLabel,
    this.inputValue,
    this.onChanged,
    this.secondaryInputLabel,
    this.secondaryInputValue,
    this.onSecondaryChanged,
    this.obscureSecondaryInput = false,
    this.tertiaryInputLabel,
    this.tertiaryInputValue,
    this.onTertiaryChanged,
    this.obscureTertiaryInput = false,
  });

  final String eyebrow;
  final String title;
  final String body;
  final String? detail;
  final String primaryLabel;
  final VoidCallback onPrimary;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;
  final String? inputLabel;
  final String? inputValue;
  final ValueChanged<String>? onChanged;
  final String? secondaryInputLabel;
  final String? secondaryInputValue;
  final ValueChanged<String>? onSecondaryChanged;
  final bool obscureSecondaryInput;
  final String? tertiaryInputLabel;
  final String? tertiaryInputValue;
  final ValueChanged<String>? onTertiaryChanged;
  final bool obscureTertiaryInput;
}
