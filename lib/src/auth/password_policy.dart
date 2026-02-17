/// SPDX-License-Identifier: Apache-2.0
/// Copyright (c) 2026 The Khatu Family Trust
/// ---------------------------------------------------------------------------
/// lib/src/auth/password_policy.dart
/// ---------------------------------------------------------------------------
///
/// Purpose:
/// - Defines password policy rules for sign-up and password entry validation.
/// Architecture:
/// - Authentication abstraction layer with pluggable providers.
/// File Version: 1.0.0
/// Framework : Core App Tech Utilities (Catu) Framework
/// Author: Neil Khatu
///

library;

class PasswordPolicy {
  static const int minLength = 8;

  static final RegExp _upper = RegExp(r'[A-Z]');
  static final RegExp _lower = RegExp(r'[a-z]');
  static final RegExp _digit = RegExp(r'\d');
  static final RegExp _special = RegExp(
    r'''[!@#\$%\^&\*\(\)_\+\-=\[\]\{\};:'",\.<>\/\?\\\|`~]''',
  );

  static String? validate(String? password) {
    final value = (password ?? '').trim();
    if (value.isEmpty) return 'Password is required';
    if (value.length < minLength) {
      return 'Password must be at least $minLength characters';
    }
    if (!_upper.hasMatch(value)) {
      return 'Password must include at least 1 uppercase letter';
    }
    if (!_lower.hasMatch(value)) {
      return 'Password must include at least 1 lowercase letter';
    }
    if (!_digit.hasMatch(value)) {
      return 'Password must include at least 1 number';
    }
    if (!_special.hasMatch(value)) {
      return 'Password must include at least 1 special character';
    }
    return null;
  }

  static String? validateConfirmation({
    required String password,
    required String confirm,
  }) {
    final p = password.trim();
    final c = confirm.trim();
    if (c.isEmpty) return 'Please confirm your password';
    if (p != c) return 'Passwords do not match';
    return validate(c);
  }
}
