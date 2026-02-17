/// SPDX-License-Identifier: Apache-2.0
/// Copyright (c) 2026 The Khatu Family Trust
/// ---------------------------------------------------------------------------
/// lib/src/menu/app_menu.dart
/// ---------------------------------------------------------------------------
///
/// Purpose:
/// - Defines app menu module.
/// Architecture:
/// - Layered Flutter architecture with explicit UI/state/service boundaries.
/// File Version: 1.0.0
/// Framework : Core App Tech Utilities (Catu) Framework
/// Author: Neil Khatu
///

library;

import 'package:flutter/material.dart';

enum AppMenuAction {
  userProfile,
  inbox,
  support,
  privacy,
  copyrightAndLicense,
  feedback,
  settings,
  logout,
}

class AppMenuButton extends StatelessWidget {
  const AppMenuButton({super.key, required this.onSelected});

  final ValueChanged<AppMenuAction> onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<AppMenuAction>(
      icon: const Icon(Icons.menu),
      onSelected: onSelected,
      itemBuilder: (context) => const [
        PopupMenuItem(
          value: AppMenuAction.userProfile,
          child: Text('User Profile'),
        ),
        PopupMenuItem(value: AppMenuAction.inbox, child: Text('Inbox')),
        PopupMenuDivider(),
        PopupMenuItem(value: AppMenuAction.support, child: Text('Support')),
        PopupMenuItem(value: AppMenuAction.privacy, child: Text('Privacy')),
        PopupMenuItem(
          value: AppMenuAction.copyrightAndLicense,
          child: Text('Copyright & License'),
        ),
        PopupMenuDivider(),
        PopupMenuItem(value: AppMenuAction.feedback, child: Text('Feedback')),
        PopupMenuItem(value: AppMenuAction.settings, child: Text('Settings')),
        PopupMenuItem(value: AppMenuAction.logout, child: Text('Logout')),
      ],
    );
  }
}
