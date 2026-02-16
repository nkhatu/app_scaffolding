/// ---------------------------------------------------------------------------
/// test/app_scaffolding_test.dart
/// ---------------------------------------------------------------------------
///
/// Purpose:
/// - Validates core app state behaviors for sign-in/sign-out flow.
/// Architecture:
/// - Layered Flutter architecture with explicit UI/state/service boundaries.
/// File Version: 1.0.0
/// Framework : Core App Tech Utilities (Catu) Framework
/// Author: Neil Khatu
/// Copyright (c) (2017 : 2026) The Khatu Family Trust
///

library;

import 'package:flutter_test/flutter_test.dart';

import 'package:app_scaffolding/app_scaffolding.dart';

void main() {
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
}
