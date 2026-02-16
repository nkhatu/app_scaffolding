/// ---------------------------------------------------------------------------
/// lib/src/theme/theme_controller.dart
/// ---------------------------------------------------------------------------
///
/// Purpose:
/// - Defines theme controller module.
/// Architecture:
/// - Reusable theme layer for variant-based app theming.
/// File Version: 1.0.0
/// Framework : Core App Tech Utilities (Catu) Framework
/// Author: Neil Khatu
/// Copyright (c) (2017 : 2026) The Khatu Family Trust
///

library;

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_theme.dart';

class ThemeController extends ChangeNotifier {
  static const _guestThemeKey = 'app_scaffold_theme_guest';
  static const _userThemePrefix = 'app_scaffold_theme_user_';

  AppThemeVariant _variant = AppThemeVariant.purple;
  String? _activeUserId;

  AppThemeVariant get variant => _variant;

  Future<void> load({String? userId}) async {
    _activeUserId = userId?.trim();
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_keyFor(_activeUserId));
    final resolved = _decode(stored);
    if (_variant != resolved) {
      _variant = resolved;
      notifyListeners();
    }
  }

  Future<void> setVariant(AppThemeVariant variant) async {
    if (_variant == variant) return;
    _variant = variant;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyFor(_activeUserId), _encode(variant));
  }

  String _keyFor(String? userId) {
    if (userId == null || userId.isEmpty) return _guestThemeKey;
    return '$_userThemePrefix$userId';
  }

  AppThemeVariant _decode(String? value) {
    switch (value) {
      case 'dark':
        return AppThemeVariant.dark;
      case 'high_contrast':
        return AppThemeVariant.highContrast;
      case 'purple':
      default:
        return AppThemeVariant.purple;
    }
  }

  String _encode(AppThemeVariant variant) {
    switch (variant) {
      case AppThemeVariant.dark:
        return 'dark';
      case AppThemeVariant.highContrast:
        return 'high_contrast';
      case AppThemeVariant.purple:
        return 'purple';
    }
  }
}
