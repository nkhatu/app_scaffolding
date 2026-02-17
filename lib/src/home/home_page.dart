/// SPDX-License-Identifier: Apache-2.0
/// Copyright (c) 2026 The Khatu Family Trust
/// ---------------------------------------------------------------------------
/// lib/src/home/home_page.dart
/// ---------------------------------------------------------------------------
///
/// Purpose:
/// - Defines home page module.
/// Architecture:
/// - Layered Flutter architecture with explicit UI/state/service boundaries.
/// File Version: 1.0.0
/// Framework : Core App Tech Utilities (Catu) Framework
/// Author: Neil Khatu
///

library;

import 'package:flutter/material.dart';

import '../app_state/app_state.dart';
import '../shell/page_shell.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.appState, required this.appName});

  final AppState appState;
  final String appName;

  @override
  Widget build(BuildContext context) {
    return AppPageShell(
      title: appName,
      appState: appState,
      body: Center(
        child: Text(
          'Welcome ${appState.user?.displayName ?? "Guest"}',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}
