/// SPDX-License-Identifier: Apache-2.0
/// Copyright (c) 2026 The Khatu Family Trust
/// ---------------------------------------------------------------------------
/// lib/src/feedback/feedback_page.dart
/// ---------------------------------------------------------------------------
///
/// Purpose:
/// - Defines feedback page module.
/// Architecture:
/// - Feature page layer for legal and support workflows.
/// File Version: 1.0.0
/// Framework : Core App Tech Utilities (Catu) Framework
/// Author: Neil Khatu
///

library;

import 'package:flutter/material.dart';

import '../analytics/crash_analytics_service.dart';
import '../app_state/app_state.dart';
import '../shell/page_shell.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({
    super.key,
    required this.appState,
    required this.analytics,
  });

  final AppState appState;
  final CrashAnalyticsService analytics;

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  static const String _githubRepoUrl =
      'https://github.com/nkhatu/catu_framework';

  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final message = _controller.text.trim();
    if (message.isEmpty) return;
    widget.analytics.logEvent('feedback_submitted');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Feedback captured. Integrate backend next.'),
      ),
    );
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return AppPageShell(
      title: 'Feedback',
      appState: widget.appState,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Share your suggestions, issues, or feature requests below.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          const Text('GitHub repository:'),
          const SizedBox(height: 4),
          const SelectableText(_githubRepoUrl),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            maxLines: 6,
            decoration: const InputDecoration(
              labelText: 'Message',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton(
              onPressed: _submit,
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}
