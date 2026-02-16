/// ---------------------------------------------------------------------------
/// lib/src/app_state/app_state.dart
/// ---------------------------------------------------------------------------
///
/// Purpose:
/// - Defines app state module.
/// Architecture:
/// - Shared state layer for session and app lifecycle.
/// File Version: 1.0.0
/// Framework : Core App Tech Utilities (Catu) Framework
/// Author: Neil Khatu
/// Copyright (c) (2017 : 2026) The Khatu Family Trust
///

library;

import 'package:flutter/foundation.dart';

import '../analytics/crash_analytics_service.dart';
import '../auth/auth_service.dart';
import '../auth/auth_user.dart';

class AppState extends ChangeNotifier {
  AppState({
    required AuthService authService,
    required CrashAnalyticsService analytics,
  }) : _authService = authService,
       _analytics = analytics;

  final AuthService _authService;
  final CrashAnalyticsService _analytics;

  bool _bootstrapping = true;
  AuthUser? _user;
  String? _signInError;

  bool get isBootstrapping => _bootstrapping;
  bool get isSignedIn => _user != null;
  AuthUser? get user => _user;
  bool get isAdmin => _user?.isAdmin == true;
  String? get signInError => _signInError;

  Future<void> bootstrap() async {
    try {
      _bootstrapping = true;
      notifyListeners();
      _user = await _authService.currentUser();
      _signInError = null;
    } catch (error, stackTrace) {
      _analytics.recordError(error, stackTrace, reason: 'bootstrap_failure');
      _signInError = 'Failed to load session.';
    } finally {
      _bootstrapping = false;
      notifyListeners();
    }
  }

  Future<bool> signIn({required String email, required String password}) async {
    try {
      final signedIn = await _authService.signIn(
        email: email,
        password: password,
      );
      _applySignIn(signedIn);
      _analytics.logEvent('sign_in_success');
      return true;
    } catch (error, stackTrace) {
      _signInError = error.toString();
      _analytics.logWarning('sign_in_failed: $_signInError');
      _analytics.recordError(error, stackTrace, reason: 'sign_in_failed');
      notifyListeners();
      return false;
    }
  }

  Future<bool> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final signedIn = await _authService.register(
        email: email.trim(),
        password: password,
        displayName: displayName,
      );
      _applySignIn(signedIn);
      _analytics.logEvent('register_success');
      return true;
    } catch (error, stackTrace) {
      _signInError = error.toString();
      _analytics.logWarning('register_failed: $_signInError');
      _analytics.recordError(error, stackTrace, reason: 'register_failed');
      notifyListeners();
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
      final signedIn = await _authService.signInWithGoogle();
      _applySignIn(signedIn);
      _analytics.logEvent('google_sign_in_success');
      return true;
    } catch (error, stackTrace) {
      _signInError = error.toString();
      _analytics.logWarning('google_sign_in_failed: $_signInError');
      _analytics.recordError(
        error,
        stackTrace,
        reason: 'google_sign_in_failed',
      );
      notifyListeners();
      return false;
    }
  }

  Future<bool> signInWithApple() async {
    try {
      final signedIn = await _authService.signInWithApple();
      _applySignIn(signedIn);
      _analytics.logEvent('apple_sign_in_success');
      return true;
    } catch (error, stackTrace) {
      _signInError = error.toString();
      _analytics.logWarning('apple_sign_in_failed: $_signInError');
      _analytics.recordError(error, stackTrace, reason: 'apple_sign_in_failed');
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    try {
      await _authService.signOut();
      _analytics.logEvent('sign_out');
    } finally {
      _user = null;
      _signInError = null;
      notifyListeners();
    }
  }

  void _applySignIn(AuthUser user) {
    _user = user;
    _signInError = null;
    notifyListeners();
  }
}
