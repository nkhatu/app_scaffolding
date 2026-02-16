/// ---------------------------------------------------------------------------
/// lib/src/framework/app_framework.dart
/// ---------------------------------------------------------------------------
///
/// Purpose:
/// - Wires routes, state, auth, theme, and feature pages into a runnable app.
/// Architecture:
/// - Top-level composition root for scaffold modules using dependency injection.
/// File Version: 1.1.0
/// Framework : Core App Tech Utilities (Catu) Framework
/// Author: Neil Khatu
/// Copyright (c) (2017 : 2026) The Khatu Family Trust
///

library;

import 'package:flutter/material.dart';

import '../analytics/crash_analytics_service.dart';
import '../app_state/app_state.dart';
import '../auth/auth_service.dart';
import '../auth/register_page.dart';
import '../auth/sign_in_page.dart';
import '../bootstrap/bootstrap_page.dart';
import '../di/app_framework_dependencies.dart';
import '../feedback/feedback_page.dart';
import '../home/home_page.dart';
import '../legal/copyright_page.dart';
import '../legal/privacy_page.dart';
import '../routing/app_routes.dart';
import '../settings/settings_page.dart';
import '../support/support_page.dart';
import '../theme/theme_controller.dart';
import '../theme/theme_data_factory.dart';

class AppFrameworkConfig {
  const AppFrameworkConfig({
    required this.appName,
    required this.supportEmail,
    required this.copyrightNotice,
    this.appVersion = '0.1.0',
    this.appBuild = '1',
  });

  final String appName;
  final String supportEmail;
  final String copyrightNotice;
  final String appVersion;
  final String appBuild;
}

class AppFrameworkApp extends StatefulWidget {
  AppFrameworkApp({
    super.key,
    required AuthService authService,
    required CrashAnalyticsService analytics,
    required this.config,
    AppFrameworkDependencies? dependencies,
  }) : dependencies =
           dependencies ??
           AppFrameworkDependencies(
             authService: authService,
             analytics: analytics,
           );

  AppFrameworkApp.withDependencies({
    super.key,
    required this.dependencies,
    required this.config,
  });

  final AppFrameworkDependencies dependencies;
  final AppFrameworkConfig config;

  @override
  State<AppFrameworkApp> createState() => _AppFrameworkAppState();
}

class _AppFrameworkAppState extends State<AppFrameworkApp> {
  late final AppState _appState;
  late final ThemeController _themeController;

  @override
  void initState() {
    super.initState();
    installCrashAnalyticsHandlers(widget.dependencies.analytics);
    _appState = widget.dependencies.createAppState();
    _themeController = widget.dependencies.createThemeController();
    _themeController.load();
    _appState.addListener(_syncThemeUser);
  }

  @override
  void dispose() {
    _appState.removeListener(_syncThemeUser);
    _appState.dispose();
    _themeController.dispose();
    super.dispose();
  }

  void _syncThemeUser() {
    _themeController.load(userId: _appState.user?.id);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _themeController,
      builder: (context, _) => MaterialApp(
        title: widget.config.appName,
        theme: buildAppTheme(_themeController.variant),
        initialRoute: AppRoutes.bootstrap,
        routes: {
          AppRoutes.bootstrap: (_) => BootstrapPage(appState: _appState),
          AppRoutes.signIn: (_) => SignInPage(appState: _appState),
          AppRoutes.register: (_) => RegisterPage(appState: _appState),
          AppRoutes.home: (_) =>
              HomePage(appState: _appState, appName: widget.config.appName),
          AppRoutes.settings: (_) => SettingsPage(
            appState: _appState,
            themeController: _themeController,
            analytics: widget.dependencies.analytics,
            appVersion: widget.config.appVersion,
            appBuild: widget.config.appBuild,
          ),
          AppRoutes.support: (_) => SupportPage(
            appState: _appState,
            supportEmail: widget.config.supportEmail,
          ),
          AppRoutes.feedback: (_) => FeedbackPage(
            appState: _appState,
            analytics: widget.dependencies.analytics,
          ),
          AppRoutes.privacy: (_) => PrivacyPage(appState: _appState),
          AppRoutes.copyright: (_) => CopyrightPage(
            appState: _appState,
            copyrightNotice: widget.config.copyrightNotice,
          ),
        },
      ),
    );
  }
}
