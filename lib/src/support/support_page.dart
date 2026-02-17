/// SPDX-License-Identifier: Apache-2.0
/// Copyright (c) 2026 The Khatu Family Trust
/// ---------------------------------------------------------------------------
/// lib/src/support/support_page.dart
/// ---------------------------------------------------------------------------
///
/// Purpose:
/// - Defines support page module.
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

class SupportPage extends StatelessWidget {
  const SupportPage({
    super.key,
    required this.appState,
    required this.supportEmail,
  });

  static const String _githubRepoUrl =
      'https://github.com/nkhatu/catu_framework';

  final AppState appState;
  final String supportEmail;

  @override
  Widget build(BuildContext context) {
    return AppPageShell(
      title: 'Support',
      appState: appState,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Need help?', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 12),
          Text('Contact support at: $supportEmail'),
          const SizedBox(height: 12),
          const Text('GitHub repository:'),
          const SizedBox(height: 4),
          const SelectableText(_githubRepoUrl),
          const SizedBox(height: 12),
          const Text(
            'For production apps, replace this page with your support workflow.',
          ),
        ],
      ),
    );
  }
}
