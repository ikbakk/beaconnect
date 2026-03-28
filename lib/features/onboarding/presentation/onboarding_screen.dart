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
        title: 'Start with your name.',
        body:
            'Use the name your partner will recognize right away. Keep it simple and familiar.',
        primaryLabel: 'Continue with Google',
        onPrimary: () async {
          controller.startWork();
          final user = await ref.read(signInWithGoogleUseCaseProvider).call();
          ref.read(currentUserProvider.notifier).state = user;
          await controller.signIn(user);
        },
        secondaryLabel: 'Back',
        onSecondary: controller.back,
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
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(
                    labelText: inputLabel,
                    hintText: 'Enter their code',
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
}
