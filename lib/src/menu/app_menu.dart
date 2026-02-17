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
  home,
  settings,
  support,
  feedback,
  privacy,
  copyright,
  signOut,
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
        PopupMenuItem(value: AppMenuAction.home, child: Text('Home')),
        PopupMenuItem(value: AppMenuAction.settings, child: Text('Settings')),
        PopupMenuItem(value: AppMenuAction.support, child: Text('Support')),
        PopupMenuItem(value: AppMenuAction.feedback, child: Text('Feedback')),
        PopupMenuItem(value: AppMenuAction.privacy, child: Text('Privacy')),
        PopupMenuItem(value: AppMenuAction.copyright, child: Text('Copyright')),
        PopupMenuDivider(),
        PopupMenuItem(value: AppMenuAction.signOut, child: Text('Sign out')),
      ],
    );
  }
}
