/// ---------------------------------------------------------------------------
/// docs/examples/firebase_auth_service.example.dart
/// ---------------------------------------------------------------------------
///
/// Purpose:
/// - Copy/paste example of wiring Firebase Auth to app_scaffolding AuthService.
/// Architecture:
/// - App-layer adapter implementation; keeps framework package provider-agnostic.
/// File Version: 1.0.0
/// Framework : Core App Tech Utilities (Catu) Framework
/// Author: Neil Khatu
/// Copyright (c) 2026 Catu Framework
///

import 'package:app_scaffolding/app_scaffolding.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class FirebaseAuthService implements AuthService {
  FirebaseAuthService({FirebaseAuth? auth})
    : _auth = auth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  @override
  Future<AuthUser?> currentUser() async {
    final user = _auth.currentUser;
    return user == null ? null : _map(user);
  }

  @override
  Future<AuthUser> signIn({
    required String email,
    required String password,
  }) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    return _map(cred.user!);
  }

  @override
  Future<AuthUser> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    if (displayName.trim().isNotEmpty) {
      await cred.user?.updateDisplayName(displayName.trim());
      await cred.user?.reload();
    }
    return _map(_auth.currentUser!);
  }

  @override
  Future<AuthUser> signInWithGoogle() async {
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) throw Exception('Google sign-in cancelled');

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );

    final userCred = await _auth.signInWithCredential(credential);
    return _map(userCred.user!);
  }

  @override
  Future<AuthUser> signInWithApple() async {
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    final oauth = OAuthProvider('apple.com').credential(
      idToken: appleCredential.identityToken,
      accessToken: appleCredential.authorizationCode,
    );

    final userCred = await _auth.signInWithCredential(oauth);
    return _map(userCred.user!);
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
  }

  AuthUser _map(User user) {
    return AuthUser(
      id: user.uid,
      email: user.email ?? '',
      displayName: user.displayName?.trim().isNotEmpty == true
          ? user.displayName!.trim()
          : (user.email?.split('@').first ?? 'User'),
      isAdmin: false,
    );
  }
}
