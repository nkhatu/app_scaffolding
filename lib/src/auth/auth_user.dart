/// SPDX-License-Identifier: Apache-2.0
/// Copyright (c) 2026 The Khatu Family Trust
/// ---------------------------------------------------------------------------
/// lib/src/auth/auth_user.dart
/// ---------------------------------------------------------------------------
///
/// Purpose:
/// - Defines auth user module.
/// Architecture:
/// - Authentication abstraction layer with pluggable providers.
/// File Version: 1.0.0
/// Framework : Core App Tech Utilities (Catu) Framework
/// Author: Neil Khatu
///

library;

class AuthUser {
  const AuthUser({
    required this.id,
    required this.email,
    required this.displayName,
    this.isAdmin = false,
  });

  final String id;
  final String email;
  final String displayName;
  final bool isAdmin;
}
