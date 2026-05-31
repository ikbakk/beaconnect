import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/domain/app_user.dart';
import '../../pairing/domain/pair_record.dart';
import '../domain/onboarding_step.dart';

final onboardingControllerProvider =
    StateNotifierProvider<OnboardingController, OnboardingState>(
      (ref) => OnboardingController(),
    );

@immutable
class OnboardingState {
  const OnboardingState({
    required this.step,
    required this.currentUser,
    required this.currentPair,
    required this.isWorking,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.authMessage,
    required this.enteredInviteCode,
  });

  final OnboardingStep step;
  final AppUser? currentUser;
  final PairRecord? currentPair;
  final bool isWorking;
  final String email;
  final String password;
  final String confirmPassword;
  final String? authMessage;
  final String enteredInviteCode;

  String get inviteCode => currentPair?.inviteCode ?? '—';
  String get partnerDisplayName => currentPair?.partnerDisplayName ?? 'your partner';
  int get expiresInMinutes => currentPair?.expiresInMinutes ?? 5;

  OnboardingState copyWith({
    OnboardingStep? step,
    AppUser? currentUser,
    PairRecord? currentPair,
    bool? isWorking,
    String? email,
    String? password,
    String? confirmPassword,
    String? authMessage,
    String? enteredInviteCode,
    bool clearUser = false,
    bool clearPair = false,
    bool clearAuthMessage = false,
  }) {
    return OnboardingState(
      step: step ?? this.step,
      currentUser: clearUser ? null : currentUser ?? this.currentUser,
      currentPair: clearPair ? null : currentPair ?? this.currentPair,
      isWorking: isWorking ?? this.isWorking,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      authMessage: clearAuthMessage ? null : authMessage ?? this.authMessage,
      enteredInviteCode: enteredInviteCode ?? this.enteredInviteCode,
    );
  }
}

class OnboardingController extends StateNotifier<OnboardingState> {
  OnboardingController()
    : super(
        const OnboardingState(
          step: OnboardingStep.welcome,
          currentUser: null,
          currentPair: null,
          isWorking: false,
          email: '',
          password: '',
          confirmPassword: '',
          authMessage: null,
          enteredInviteCode: '',
        ),
      );

  static const _steps = OnboardingStep.values;

  void next() {
    final index = _steps.indexOf(state.step);
    if (index < _steps.length - 1) {
      state = state.copyWith(step: _steps[index + 1]);
    }
  }

  void back() {
    final index = _steps.indexOf(state.step);
    if (index > 0) {
      state = state.copyWith(step: _steps[index - 1]);
    }
  }

  Future<void> signIn(AppUser user) async {
    state = state.copyWith(
      currentUser: user,
      isWorking: false,
      step: OnboardingStep.pairing,
      clearAuthMessage: true,
    );
  }

  Future<void> preparePairing(PairRecord pair) async {
    state = state.copyWith(
      currentPair: pair,
      isWorking: false,
    );
  }

  Future<void> approvePairing(PairRecord pair) async {
    state = state.copyWith(
      currentPair: pair,
      isWorking: false,
      step: OnboardingStep.permissions,
    );
  }

  Future<void> skipPairing() async {
    state = state.copyWith(
      isWorking: false,
      step: OnboardingStep.success,
      clearPair: true,
    );
  }

  void updateEmail(String value) {
    state = state.copyWith(email: value.trim(), clearAuthMessage: true);
  }

  void updatePassword(String value) {
    state = state.copyWith(password: value, clearAuthMessage: true);
  }

  void updateConfirmPassword(String value) {
    state = state.copyWith(confirmPassword: value, clearAuthMessage: true);
  }

  void updateInviteCode(String value) {
    state = state.copyWith(enteredInviteCode: value.trim());
  }

  void startWork() {
    state = state.copyWith(isWorking: true, clearAuthMessage: true);
  }

  void stopWork() {
    state = state.copyWith(isWorking: false);
  }

  void showAuthMessage(String message) {
    state = state.copyWith(isWorking: false, authMessage: message);
  }
}
