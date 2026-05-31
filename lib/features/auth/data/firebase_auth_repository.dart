import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../domain/app_user.dart';
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
    final credential = await _signInOrCreate(
      email: normalizedEmail,
      password: password,
    );
    final user = credential.user;
    if (user == null) {
      throw StateError('Something did not go as expected.');
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

  Future<firebase_auth.UserCredential> _signInOrCreate({
    required String email,
    required String password,
  }) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on firebase_auth.FirebaseAuthException catch (error) {
      if (error.code != 'user-not-found' && error.code != 'invalid-credential') {
        rethrow;
      }

      return _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    }
  }

  String _displayNameFromEmail(String email) {
    final namePart = email.split('@').first;
    if (namePart.isEmpty) {
      return 'You';
    }

    return namePart[0].toUpperCase() + namePart.substring(1);
  }
}
