/// SPDX-License-Identifier: Apache-2.0
/// Copyright (c) 2026 The Khatu Family Trust
/// ---------------------------------------------------------------------------
/// lib/src/auth/in_memory_auth_service.dart
/// ---------------------------------------------------------------------------
///
/// Purpose:
/// - Defines in memory auth service module.
/// Architecture:
/// - Authentication abstraction layer with pluggable providers.
/// File Version: 1.1.0
/// Framework : Core App Tech Utilities (Catu) Framework
/// Author: Neil Khatu
///

library;

import 'auth_service.dart';
import 'auth_user.dart';

class InMemoryAuthService implements AuthService {
  InMemoryAuthService({
    required Map<String, String> users,
    String adminEmail = '',
    this.enableSocialSignIn = true,
    this.allowImplicitAccountCreation = false,
  }) : _users = Map<String, String>.from(users),
       _adminEmail = adminEmail.trim().toLowerCase();

  final Map<String, String> _users;
  final String _adminEmail;
  final bool enableSocialSignIn;
  final bool allowImplicitAccountCreation;
  AuthUser? _activeUser;

  @override
  Future<AuthUser?> currentUser() async => _activeUser;

  @override
  Future<AuthUser> signIn({
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    final normalizedPassword = password.trim();

    if (normalizedEmail.isEmpty) {
      throw const AuthException('User ID is required.');
    }
    if (normalizedPassword.isEmpty) {
      throw const AuthException('Password is required.');
    }

    final storedPassword = _users[normalizedEmail];
    if (storedPassword == null) {
      if (!allowImplicitAccountCreation) {
        throw const AuthException('Account does not exist.');
      }
      _users[normalizedEmail] = normalizedPassword;
    } else if (storedPassword != normalizedPassword) {
      throw const AuthException('Invalid credentials.');
    }

    final user = AuthUser(
      id: normalizedEmail,
      email: normalizedEmail,
      displayName: normalizedEmail.split('@').first,
      isAdmin: normalizedEmail == _adminEmail,
    );
    _activeUser = user;
    return user;
  }

  @override
  Future<AuthUser> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    if (_users.containsKey(normalizedEmail)) {
      throw const AuthException('Account already exists.');
    }

    _users[normalizedEmail] = password;
    final user = AuthUser(
      id: normalizedEmail,
      email: normalizedEmail,
      displayName: displayName.trim().isEmpty
          ? normalizedEmail.split('@').first
          : displayName.trim(),
      isAdmin: normalizedEmail == _adminEmail,
    );
    _activeUser = user;
    return user;
  }

  @override
  Future<AuthUser> signInWithGoogle() async {
    if (!enableSocialSignIn) {
      throw const AuthException('Google sign-in is not enabled.');
    }
    final user = AuthUser(
      id: 'google_demo_user',
      email: 'google.user@demo.local',
      displayName: 'Google User',
      isAdmin: false,
    );
    _activeUser = user;
    return user;
  }

  @override
  Future<AuthUser> signInWithApple() async {
    if (!enableSocialSignIn) {
      throw const AuthException('Apple sign-in is not enabled.');
    }
    final user = AuthUser(
      id: 'apple_demo_user',
      email: 'apple.user@demo.local',
      displayName: 'Apple User',
      isAdmin: false,
    );
    _activeUser = user;
    return user;
  }

  @override
  Future<void> signOut() async {
    _activeUser = null;
  }
}

class AuthException implements Exception {
  const AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}
