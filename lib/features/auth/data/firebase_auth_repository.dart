import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';

import '../domain/app_user.dart';
import '../domain/auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository({
    firebase_auth.FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  }) : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
       _googleSignIn = googleSignIn ?? GoogleSignIn.instance;

  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

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
  Future<AppUser> signInWithGoogle() async {
    await _googleSignIn.initialize();
    final googleUser = await _googleSignIn.authenticate();
    final authentication = googleUser.authentication;

    final credential = firebase_auth.GoogleAuthProvider.credential(
      idToken: authentication.idToken,
    );

    final signedIn = await _firebaseAuth.signInWithCredential(credential);
    final user = signedIn.user;
    if (user == null) {
      throw StateError('Something did not go as expected.');
    }

    return AppUser(
      id: user.uid,
      displayName: user.displayName ?? googleUser.displayName ?? 'You',
    );
  }
}
