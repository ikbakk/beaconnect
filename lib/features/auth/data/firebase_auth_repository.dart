import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../domain/app_user.dart';
import '../domain/auth_failure.dart';
import '../domain/auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository({
    firebase_auth.FirebaseAuth? firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance;

  final firebase_auth.FirebaseAuth _firebaseAuth;

  @override
  Future<AppUser?> getCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      return null;
    }

    return AppUser(
      id: user.uid,
      displayName: user.displayName ?? 'You',
    );
  }

  @override
  Future<AppUser> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();

    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: normalizedEmail,
        password: password,
      );
      return _userFromCredential(credential, normalizedEmail);
    } on firebase_auth.FirebaseAuthException catch (error) {
      throw _mapAuthError(error);
    }
  }

  @override
  Future<AppUser> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();

    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: normalizedEmail,
        password: password,
      );
      return _userFromCredential(credential, normalizedEmail);
    } on firebase_auth.FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {
        try {
          final credential = await _firebaseAuth.signInWithEmailAndPassword(
            email: normalizedEmail,
            password: password,
          );
          return _userFromCredential(credential, normalizedEmail);
        } on firebase_auth.FirebaseAuthException catch (signInError) {
          throw _mapAuthError(signInError);
        }
      }

      throw _mapAuthError(error);
    }
  }

  Future<AppUser> _userFromCredential(
    firebase_auth.UserCredential credential,
    String normalizedEmail,
  ) async {
    final user = credential.user;
    if (user == null) {
      throw const AuthFailure(
        'We could not finish signing you in just yet. Please try again.',
      );
    }

    final displayName = user.displayName ?? _displayNameFromEmail(normalizedEmail);
    if ((user.displayName ?? '').isEmpty) {
      await user.updateDisplayName(displayName);
    }

    return AppUser(
      id: user.uid,
      displayName: displayName,
    );
  }

  AuthFailure _mapAuthError(firebase_auth.FirebaseAuthException error) {
    return switch (error.code) {
      'invalid-email' => const AuthFailure(
        'That email does not look right yet. Please check it and try again.',
      ),
      'email-already-in-use' => const AuthFailure(
        'That email is already connected to Beaconnect. Try signing in with the same password you used before.',
      ),
      'wrong-password' || 'invalid-credential' => const AuthFailure(
        'That email and password do not match yet. Please try again.',
      ),
      'too-many-requests' => const AuthFailure(
        'There were too many attempts just now. Please wait a moment and try again.',
      ),
      'network-request-failed' => const AuthFailure(
        'Beaconnect could not reach the internet just now. Please try again in a moment.',
      ),
      'operation-not-allowed' => const AuthFailure(
        'Email sign-in is not ready yet for this project.',
      ),
      'weak-password' => const AuthFailure(
        'Choose a password with at least 6 characters.',
      ),
      _ => const AuthFailure(
        'We could not sign you in just yet. Please try again in a moment.',
      ),
    };
  }

  String _displayNameFromEmail(String email) {
    final namePart = email.split('@').first;
    if (namePart.isEmpty) {
      return 'You';
    }

    return namePart[0].toUpperCase() + namePart.substring(1);
  }
}
