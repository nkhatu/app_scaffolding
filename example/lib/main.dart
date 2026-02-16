/// ---------------------------------------------------------------------------
/// example/lib/main.dart
/// ---------------------------------------------------------------------------
///
/// Purpose:
/// - Defines app entry point and bootstraps the framework app.
/// Architecture:
/// - Layered Flutter architecture with explicit UI/state/service boundaries.
/// File Version: 1.1.0
/// Framework : Core App Tech Utilities (Catu) Framework
/// Author: Neil Khatu
/// Copyright (c) (2017 : 2026) The Khatu Family Trust
///

library;

import 'package:flutter/material.dart';
import 'package:app_scaffolding/app_scaffolding.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final auth = InMemoryAuthService(
    users: {'demo@kart.app': 'demo123', 'admin@kart.app': 'admin123'},
    adminEmail: 'admin@kart.app',
  );

  final analytics = InMemoryCrashAnalyticsService();

  runApp(
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
}
