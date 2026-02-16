/// ---------------------------------------------------------------------------
/// lib/src/di/app_framework_dependencies.dart
/// ---------------------------------------------------------------------------
///
/// Purpose:
/// - Defines dependency injection contracts for framework composition.
/// Architecture:
/// - Composition-layer wiring via constructor-injected dependencies.
/// File Version: 1.0.0
/// Framework : Core App Tech Utilities (Catu) Framework
/// Author: Neil Khatu
/// Copyright (c) (2017 : 2026) The Khatu Family Trust
///

library;

import '../analytics/crash_analytics_service.dart';
import '../app_state/app_state.dart';
import '../auth/auth_service.dart';
import '../theme/theme_controller.dart';

typedef AppStateFactory =
    AppState Function({
      required AuthService authService,
      required CrashAnalyticsService analytics,
    });

typedef ThemeControllerFactory = ThemeController Function();

class AppFrameworkDependencies {
  const AppFrameworkDependencies({
    required this.authService,
    required this.analytics,
    this.appStateFactory,
    this.themeControllerFactory,
  });

  final AuthService authService;
  final CrashAnalyticsService analytics;
  final AppStateFactory? appStateFactory;
  final ThemeControllerFactory? themeControllerFactory;

  AppState createAppState() {
    final factory = appStateFactory;
    if (factory != null) {
      return factory(authService: authService, analytics: analytics);
    }
    return AppState(authService: authService, analytics: analytics);
  }

  ThemeController createThemeController() {
    final factory = themeControllerFactory;
    if (factory != null) return factory();
    return ThemeController();
  }
}
