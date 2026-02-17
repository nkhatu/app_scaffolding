/// SPDX-License-Identifier: Apache-2.0
/// Copyright (c) 2026 The Khatu Family Trust
/// ---------------------------------------------------------------------------
/// lib/src/profile/user_profile_page.dart
/// ---------------------------------------------------------------------------
///
/// Purpose:
/// - Displays a simple user profile summary for the signed-in user.
/// Architecture:
/// - Feature page layer for account and identity surfaces.
/// File Version: 1.0.0
/// Framework : Core App Tech Utilities (Catu) Framework
/// Author: Neil Khatu
///

library;

import 'package:flutter/material.dart';

import '../app_state/app_state.dart';
import '../shell/page_shell.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key, required this.appState});

  final AppState appState;

  @override
  Widget build(BuildContext context) {
    final user = appState.user;
    final displayName = user?.displayName ?? 'Guest';
    final email = user?.email ?? 'Not signed in';
    final role = appState.isAdmin ? 'Admin' : (user == null ? 'Guest' : 'User');

    return AppPageShell(
      title: 'User Profile',
      appState: appState,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const CircleAvatar(radius: 34, child: Icon(Icons.person, size: 34)),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.badge_outlined),
            title: const Text('Display Name'),
            subtitle: Text(displayName),
          ),
          ListTile(
            leading: const Icon(Icons.email_outlined),
            title: const Text('Email'),
            subtitle: Text(email),
          ),
          ListTile(
            leading: const Icon(Icons.verified_user_outlined),
            title: const Text('Role'),
            subtitle: Text(role),
          ),
        ],
      ),
    );
  }
}
