/// ---------------------------------------------------------------------------
/// lib/src/auth/password_rules_text.dart
/// ---------------------------------------------------------------------------
///
/// Purpose:
/// - Shows password requirement guidance in a reusable dialog trigger widget.
/// Architecture:
/// - Authentication abstraction layer with pluggable providers.
/// File Version: 1.0.0
/// Framework : Core App Tech Utilities (Catu) Framework
/// Author: Neil Khatu
/// Copyright (c) (2017 : 2026) The Khatu Family Trust
///

library;

import 'package:flutter/material.dart';

class PasswordRulesText extends StatelessWidget {
  const PasswordRulesText({super.key});

  static const String rulesText = '''
Password requirements:
• At least 8 characters
• One uppercase letter (A–Z)
• One lowercase letter (a–z)
• One number (0–9)
• One special character (e.g. ! @ # \$ % ^ & *)
''';

  void _showRules(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Password requirements'),
        content: const Text(rulesText),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton(
        onPressed: () => _showRules(context),
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: const Size(0, 36),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: const Text(
          'View password requirements',
          style: TextStyle(fontSize: 13),
        ),
      ),
    );
  }
}
