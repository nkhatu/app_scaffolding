/// SPDX-License-Identifier: Apache-2.0
/// Copyright (c) 2026 The Khatu Family Trust
/// ---------------------------------------------------------------------------
/// lib/src/theme/theme_data_factory.dart
/// ---------------------------------------------------------------------------
///
/// Purpose:
/// - Defines theme data factory module.
/// Architecture:
/// - Reusable theme layer for variant-based app theming.
/// File Version: 1.0.0
/// Framework : Core App Tech Utilities (Catu) Framework
/// Author: Neil Khatu
///

library;

import 'package:flutter/material.dart';

import 'app_theme.dart';

ThemeData buildAppTheme(AppThemeVariant variant) {
  switch (variant) {
    case AppThemeVariant.dark:
      return _darkTheme();
    case AppThemeVariant.highContrast:
      return _highContrastTheme();
    case AppThemeVariant.purple:
      return _purpleTheme();
  }
}

ThemeData _purpleTheme() {
  const seed = Colors.deepPurple;
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(seedColor: seed),
    appBarTheme: const AppBarTheme(
      backgroundColor: seed,
      foregroundColor: Colors.white,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(backgroundColor: seed),
    ),
  );
}

ThemeData _darkTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: Colors.white,
      onPrimary: Colors.black,
      surface: Colors.black,
      onSurface: Colors.white,
    ),
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
    ),
    cardColor: const Color(0xFF111111),
    dividerColor: Colors.white24,
  );
}

ThemeData _highContrastTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: Colors.black,
      onPrimary: Colors.white,
      secondary: Colors.yellow,
      onSecondary: Colors.black,
      error: Colors.red,
      onError: Colors.white,
      surface: Colors.white,
      onSurface: Colors.black,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
    ),
    textTheme: ThemeData.light().textTheme.apply(
      bodyColor: Colors.black,
      displayColor: Colors.black,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
    ),
  );
}
