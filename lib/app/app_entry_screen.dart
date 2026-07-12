import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'providers.dart';
import '../design/colors/bcg_colors.dart';
import '../features/onboarding/presentation/onboarding_screen.dart';

class AppEntryScreen extends ConsumerWidget {
  const AppEntryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(appSessionProvider);

    if (!session.hasCompletedOnboarding) {
      return const OnboardingScreen();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        context.go('/home');
      }
    });

    return const ColoredBox(
      color: BcgColors.surface,
      child: Center(child: SizedBox.shrink()),
    );
  }
}
