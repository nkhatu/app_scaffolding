/// SPDX-License-Identifier: Apache-2.0
/// Copyright (c) 2026 The Khatu Family Trust
/// ---------------------------------------------------------------------------
/// example/test/widget_test.dart
/// ---------------------------------------------------------------------------
///
/// Purpose:
/// - Validates that scaffolded example boots to the sign-in surface.
/// Architecture:
/// - Layered Flutter architecture with explicit UI/state/service boundaries.
/// File Version: 1.1.0
/// Framework : Core App Tech Utilities (Catu) Framework
/// Author: Neil Khatu
///

library;

import 'package:catu_framework/catu_framework.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('example app shows sign in page', (WidgetTester tester) async {
    final auth = InMemoryAuthService(users: const {'demo@kart.app': 'demo123'});
    final analytics = InMemoryCrashAnalyticsService();

    await tester.pumpWidget(
      AppFrameworkApp(
        authService: auth,
        analytics: analytics,
        config: const AppFrameworkConfig(
          appName: 'Catu Framework',
          appVersion: '0.1.1',
          appBuild: '31',
          supportEmail: 'support@kart.app',
          copyrightNotice: 'Copyright © 2026 Catu Framework',
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Sign In'), findsAtLeastNWidgets(1));
    expect(find.byType(TextFormField), findsAtLeastNWidgets(2));
  });
}
