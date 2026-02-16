/// ---------------------------------------------------------------------------
/// lib/src/settings/settings_page.dart
/// ---------------------------------------------------------------------------
///
/// Purpose:
/// - Defines settings page module.
/// Architecture:
/// - Feature layer for settings and diagnostics surfaces.
/// File Version: 1.0.0
/// Framework : Core App Tech Utilities (Catu) Framework
/// Author: Neil Khatu
/// Copyright (c) (2017 : 2026) The Khatu Family Trust
///

library;

import 'package:flutter/material.dart';

import '../analytics/crash_analytics_service.dart';
import '../app_state/app_state.dart';
import '../shell/page_shell.dart';
import '../theme/app_theme.dart';
import '../theme/theme_controller.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({
    super.key,
    required this.appState,
    required this.themeController,
    required this.analytics,
    required this.appVersion,
    required this.appBuild,
  });

  final AppState appState;
  final ThemeController themeController;
  final CrashAnalyticsService analytics;
  final String appVersion;
  final String appBuild;

  @override
  Widget build(BuildContext context) {
    return AppPageShell(
      title: 'Settings',
      appState: appState,
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          AnimatedBuilder(
            animation: themeController,
            builder: (context, _) => ListTile(
              leading: const Icon(Icons.palette_outlined),
              title: const Text('Theme'),
              subtitle: Text(_themeLabel(themeController.variant)),
              trailing: DropdownButton<AppThemeVariant>(
                value: themeController.variant,
                onChanged: (value) {
                  if (value == null) return;
                  themeController.setVariant(value);
                },
                items: AppThemeVariant.values
                    .map(
                      (variant) => DropdownMenuItem(
                        value: variant,
                        child: Text(_themeLabel(variant)),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            subtitle: Text('Version $appVersion • Build $appBuild'),
          ),
          const Divider(height: 1),
          ExpansionTile(
            leading: const Icon(Icons.warning_amber_outlined),
            title: const Text('Crash Analytics Logs'),
            subtitle: const Text('Runtime warnings and errors'),
            children: [
              SizedBox(
                height: 260,
                child: ValueListenableBuilder<List<CrashLogEntry>>(
                  valueListenable: analytics.logs,
                  builder: (context, logs, _) {
                    if (logs.isEmpty) {
                      return const Center(child: Text('No logs yet'));
                    }
                    return ListView.builder(
                      itemCount: logs.length,
                      itemBuilder: (context, index) {
                        final entry = logs[logs.length - 1 - index];
                        return ListTile(
                          dense: true,
                          title: Text(entry.message),
                          subtitle: Text(
                            '${entry.level.name.toUpperCase()} • ${entry.timestamp.toIso8601String()}',
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _themeLabel(AppThemeVariant variant) {
    switch (variant) {
      case AppThemeVariant.purple:
        return 'Purple';
      case AppThemeVariant.dark:
        return 'Dark (Black/White)';
      case AppThemeVariant.highContrast:
        return 'High Contrast';
    }
  }
}
