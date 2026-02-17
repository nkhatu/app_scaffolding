/// SPDX-License-Identifier: Apache-2.0
/// Copyright (c) 2026 The Khatu Family Trust
/// ---------------------------------------------------------------------------
/// lib/src/legal/copyright_page.dart
/// ---------------------------------------------------------------------------
///
/// Purpose:
/// - Defines copyright page module.
/// Architecture:
/// - Feature page layer for legal and support workflows.
/// File Version: 1.0.0
/// Framework : Core App Tech Utilities (Catu) Framework
/// Author: Neil Khatu
///

library;

import 'package:flutter/material.dart';

import '../app_state/app_state.dart';
import '../shell/page_shell.dart';

class CopyrightPage extends StatelessWidget {
  const CopyrightPage({
    super.key,
    required this.appState,
    required this.copyrightNotice,
  });

  final AppState appState;
  final String copyrightNotice;

  @override
  Widget build(BuildContext context) {
    return AppPageShell(
      title: 'Copyright',
      appState: appState,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(copyrightNotice),
      ),
    );
  }
}
