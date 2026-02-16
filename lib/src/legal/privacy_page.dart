/// ---------------------------------------------------------------------------
/// lib/src/legal/privacy_page.dart
/// ---------------------------------------------------------------------------
///
/// Purpose:
/// - Defines privacy page module.
/// Architecture:
/// - Feature page layer for legal and support workflows.
/// File Version: 1.0.0
/// Framework : Core App Tech Utilities (Catu) Framework
/// Author: Neil Khatu
/// Copyright (c) (2017 : 2026) The Khatu Family Trust
///

library;

import 'package:flutter/material.dart';

import '../app_state/app_state.dart';
import '../shell/page_shell.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key, required this.appState});

  final AppState appState;

  @override
  Widget build(BuildContext context) {
    return AppPageShell(
      title: 'Privacy',
      appState: appState,
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'Replace this privacy copy with your policy content and links.',
        ),
      ),
    );
  }
}
