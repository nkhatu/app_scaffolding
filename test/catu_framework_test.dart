/// SPDX-License-Identifier: Apache-2.0
/// Copyright (c) 2026 The Khatu Family Trust
/// ---------------------------------------------------------------------------
/// test/catu_framework_test.dart
/// ---------------------------------------------------------------------------
///
/// Purpose:
/// - Validates core app state behaviors for sign-in/sign-out flow.
/// Architecture:
/// - Layered Flutter architecture with explicit UI/state/service boundaries.
/// File Version: 1.0.0
/// Framework : Core App Tech Utilities (Catu) Framework
/// Author: Neil Khatu
///

library;

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';

import 'package:catu_framework/catu_framework.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('app state signs in and signs out', () async {
    final auth = InMemoryAuthService(users: const {'demo@kart.app': 'demo123'});
    final analytics = InMemoryCrashAnalyticsService();
    final appState = AppState(authService: auth, analytics: analytics);

    await appState.bootstrap();
    expect(appState.isSignedIn, isFalse);

    final signedIn = await appState.signIn(
      email: 'demo@kart.app',
      password: 'demo123',
    );
    expect(signedIn, isTrue);
    expect(appState.isSignedIn, isTrue);
    expect(appState.user?.email, 'demo@kart.app');

    await appState.signOut();
    expect(appState.isSignedIn, isFalse);
    expect(appState.user, isNull);
  });

  test('app state registers and supports social sign-in hooks', () async {
    final auth = InMemoryAuthService(
      users: const {'existing@kart.app': 'demo123'},
      enableSocialSignIn: true,
    );
    final analytics = InMemoryCrashAnalyticsService();
    final appState = AppState(authService: auth, analytics: analytics);

    final registered = await appState.register(
      email: 'new@kart.app',
      password: 'Demo@123!',
      displayName: 'New User',
    );
    expect(registered, isTrue);
    expect(appState.user?.email, 'new@kart.app');

    await appState.signOut();
    final googleOk = await appState.signInWithGoogle();
    expect(googleOk, isTrue);
    expect(appState.user?.email, 'google.user@demo.local');

    await appState.signOut();
    final appleOk = await appState.signInWithApple();
    expect(appleOk, isTrue);
    expect(appState.user?.email, 'apple.user@demo.local');
  });

  test('sign in rejects unknown user unless implicit creation is enabled', () async {
    final strictAuth = InMemoryAuthService(users: const {'demo@kart.app': 'demo123'});
    final strictAnalytics = InMemoryCrashAnalyticsService();
    final strictAppState = AppState(authService: strictAuth, analytics: strictAnalytics);

    final strictResult = await strictAppState.signIn(
      email: 'unknown@kart.app',
      password: 'demo123',
    );
    expect(strictResult, isFalse);
    expect(strictAppState.isSignedIn, isFalse);

    final permissiveAuth = InMemoryAuthService(
      users: const {'demo@kart.app': 'demo123'},
      allowImplicitAccountCreation: true,
    );
    final permissiveAnalytics = InMemoryCrashAnalyticsService();
    final permissiveAppState = AppState(
      authService: permissiveAuth,
      analytics: permissiveAnalytics,
    );

    final permissiveResult = await permissiveAppState.signIn(
      email: 'unknown@kart.app',
      password: 'demo123',
    );
    expect(permissiveResult, isTrue);
    expect(permissiveAppState.user?.email, 'unknown@kart.app');
  });

  test('sign out failure still clears local session state', () async {
    final auth = _ThrowingSignOutAuthService(
      users: const {'demo@kart.app': 'demo123'},
    );
    final analytics = InMemoryCrashAnalyticsService();
    final appState = AppState(authService: auth, analytics: analytics);

    final signedIn = await appState.signIn(
      email: 'demo@kart.app',
      password: 'demo123',
    );
    expect(signedIn, isTrue);
    expect(appState.isSignedIn, isTrue);

    await appState.signOut();

    expect(appState.isSignedIn, isFalse);
    expect(appState.user, isNull);
    expect(
      analytics.logs.value.any(
        (entry) => entry.message.contains('sign_out_failed'),
      ),
      isTrue,
    );
  });

  test('crash handlers compose with previously installed handlers', () {
    final analytics = InMemoryCrashAnalyticsService();
    int flutterHandlerCalls = 0;
    int platformHandlerCalls = 0;

    final previousFlutterHandler = FlutterError.onError;
    final previousPlatformHandler =
        WidgetsBinding.instance.platformDispatcher.onError;

    FlutterError.onError = (_) => flutterHandlerCalls++;
    WidgetsBinding.instance.platformDispatcher.onError = (error, stackTrace) {
      platformHandlerCalls++;
      return true;
    };

    try {
      installCrashAnalyticsHandlers(analytics);

      FlutterError.onError!(
        FlutterErrorDetails(
          exception: Exception('flutter boom'),
          stack: StackTrace.current,
        ),
      );

      final platformErrorHandler =
          WidgetsBinding.instance.platformDispatcher.onError;
      platformErrorHandler?.call(Exception('platform boom'), StackTrace.current);

      expect(flutterHandlerCalls, 1);
      expect(platformHandlerCalls, inInclusiveRange(0, 1));
      expect(
        analytics.logs.value.where((entry) => entry.level == CrashLogLevel.error),
        isNotEmpty,
      );
    } finally {
      FlutterError.onError = previousFlutterHandler;
      WidgetsBinding.instance.platformDispatcher.onError =
          previousPlatformHandler;
    }
  });
}

class _ThrowingSignOutAuthService extends InMemoryAuthService {
  _ThrowingSignOutAuthService({required super.users});

  @override
  Future<void> signOut() async {
    throw const AuthException('sign out backend failure');
  }
}
