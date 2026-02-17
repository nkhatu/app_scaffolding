/// SPDX-License-Identifier: Apache-2.0
/// Copyright (c) 2026 The Khatu Family Trust
/// ---------------------------------------------------------------------------
/// lib/src/bootstrap/bootstrap_page.dart
/// ---------------------------------------------------------------------------
///
/// Purpose:
/// - Defines bootstrap page module.
/// Architecture:
/// - Layered Flutter architecture with explicit UI/state/service boundaries.
/// File Version: 1.0.0
/// Framework : Core App Tech Utilities (Catu) Framework
/// Author: Neil Khatu
///

library;

import 'package:flutter/material.dart';

import '../app_state/app_state.dart';
import '../routing/app_routes.dart';

class BootstrapPage extends StatefulWidget {
  const BootstrapPage({super.key, required this.appState});

  final AppState appState;

  @override
  State<BootstrapPage> createState() => _BootstrapPageState();
}

class _BootstrapPageState extends State<BootstrapPage> {
  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    await widget.appState.bootstrap();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      widget.appState.isSignedIn ? AppRoutes.home : AppRoutes.signIn,
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
