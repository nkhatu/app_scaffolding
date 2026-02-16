/// ---------------------------------------------------------------------------
/// lib/src/auth/auth_service.dart
/// ---------------------------------------------------------------------------
///
/// Purpose:
/// - Defines auth service module.
/// Architecture:
/// - Authentication abstraction layer with pluggable providers.
/// File Version: 1.0.0
/// Framework : Core App Tech Utilities (Catu) Framework
/// Author: Neil Khatu
/// Copyright (c) (2017 : 2026) The Khatu Family Trust
///

library;

import 'auth_user.dart';

abstract class AuthService {
  Future<AuthUser?> currentUser();

  Future<AuthUser> signIn({required String email, required String password});

  Future<AuthUser> register({
    required String email,
    required String password,
    required String displayName,
  });

  Future<AuthUser> signInWithGoogle();

  Future<AuthUser> signInWithApple();

  Future<void> signOut();
}
