/// ---------------------------------------------------------------------------
/// lib/src/shell/page_shell.dart
/// ---------------------------------------------------------------------------
///
/// Purpose:
/// - Defines page shell module.
/// Architecture:
/// - Shared UI shell with header, body, footer, and menu integration.
/// File Version: 1.0.0
/// Framework : Core App Tech Utilities (Catu) Framework
/// Author: Neil Khatu
/// Copyright (c) (2017 : 2026) The Khatu Family Trust
///

library;

import 'package:flutter/material.dart';

import '../app_state/app_state.dart';
import '../menu/app_menu.dart';
import '../routing/app_routes.dart';

class AppPageShell extends StatelessWidget {
  const AppPageShell({
    super.key,
    required this.title,
    required this.body,
    required this.appState,
    this.footerText = 'Copyright © Catu App',
  });

  final String title;
  final Widget body;
  final AppState appState;
  final String footerText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppPageHeader(
        title: title,
        onMenuSelected: (action) => _onMenuSelection(context, action),
      ),
      body: Column(
        children: [
          Expanded(child: body),
          const Divider(height: 1),
          AppPageFooter(text: footerText),
        ],
      ),
    );
  }

  Future<void> _onMenuSelection(
    BuildContext context,
    AppMenuAction action,
  ) async {
    switch (action) {
      case AppMenuAction.home:
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.home,
          (_) => false,
        );
        break;
      case AppMenuAction.settings:
        Navigator.pushNamed(context, AppRoutes.settings);
        break;
      case AppMenuAction.support:
        Navigator.pushNamed(context, AppRoutes.support);
        break;
      case AppMenuAction.feedback:
        Navigator.pushNamed(context, AppRoutes.feedback);
        break;
      case AppMenuAction.privacy:
        Navigator.pushNamed(context, AppRoutes.privacy);
        break;
      case AppMenuAction.copyright:
        Navigator.pushNamed(context, AppRoutes.copyright);
        break;
      case AppMenuAction.signOut:
        await appState.signOut();
        if (!context.mounted) return;
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.signIn,
          (_) => false,
        );
        break;
    }
  }
}

class AppPageHeader extends StatelessWidget implements PreferredSizeWidget {
  const AppPageHeader({
    super.key,
    required this.title,
    required this.onMenuSelected,
  });

  final String title;
  final ValueChanged<AppMenuAction> onMenuSelected;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: [
        AppMenuButton(onSelected: onMenuSelected),
        const SizedBox(width: 8),
      ],
    );
  }
}

class AppPageFooter extends StatelessWidget {
  const AppPageFooter({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(text, style: Theme.of(context).textTheme.bodySmall),
    );
  }
}
