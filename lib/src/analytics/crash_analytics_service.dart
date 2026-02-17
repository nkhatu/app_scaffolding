/// SPDX-License-Identifier: Apache-2.0
/// Copyright (c) 2026 The Khatu Family Trust
/// ---------------------------------------------------------------------------
/// lib/src/analytics/crash_analytics_service.dart
/// ---------------------------------------------------------------------------
///
/// Purpose:
/// - Defines crash analytics service module.
/// Architecture:
/// - Layered Flutter architecture with explicit UI/state/service boundaries.
/// File Version: 1.0.0
/// Framework : Core App Tech Utilities (Catu) Framework
/// Author: Neil Khatu
///

library;

import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

enum CrashLogLevel { info, warning, error }

class CrashLogEntry {
  const CrashLogEntry({
    required this.level,
    required this.message,
    required this.timestamp,
  });

  final CrashLogLevel level;
  final String message;
  final DateTime timestamp;
}

abstract class CrashAnalyticsService {
  ValueListenable<List<CrashLogEntry>> get logs;

  void logEvent(String message);
  void logWarning(String message);
  void recordError(Object error, StackTrace stackTrace, {String? reason});
}

class InMemoryCrashAnalyticsService implements CrashAnalyticsService {
  InMemoryCrashAnalyticsService({this.maxEntries = 250});

  final int maxEntries;
  final ValueNotifier<List<CrashLogEntry>> _logs =
      ValueNotifier<List<CrashLogEntry>>(<CrashLogEntry>[]);

  @override
  ValueListenable<List<CrashLogEntry>> get logs => _logs;

  @override
  void logEvent(String message) {
    _append(CrashLogLevel.info, message);
  }

  @override
  void logWarning(String message) {
    _append(CrashLogLevel.warning, message);
  }

  @override
  void recordError(Object error, StackTrace stackTrace, {String? reason}) {
    final details = reason == null ? error.toString() : '$reason: $error';
    _append(CrashLogLevel.error, details);
    debugPrint(stackTrace.toString());
  }

  void _append(CrashLogLevel level, String message) {
    final next = List<CrashLogEntry>.of(_logs.value)
      ..add(
        CrashLogEntry(
          level: level,
          message: message.trim(),
          timestamp: DateTime.now(),
        ),
      );

    if (next.length > maxEntries) {
      next.removeRange(0, next.length - maxEntries);
    }
    _logs.value = UnmodifiableListView(next);
  }
}

void installCrashAnalyticsHandlers(CrashAnalyticsService analytics) {
  final previousFlutterErrorHandler = FlutterError.onError;
  final previousPlatformErrorHandler =
      WidgetsBinding.instance.platformDispatcher.onError;

  FlutterError.onError = (details) {
    if (previousFlutterErrorHandler != null) {
      previousFlutterErrorHandler(details);
    } else {
      FlutterError.presentError(details);
    }
    analytics.recordError(
      details.exception,
      details.stack ?? StackTrace.current,
      reason: 'flutter_error',
    );
  };

  WidgetsBinding.instance.platformDispatcher.onError = (error, stackTrace) {
    analytics.recordError(error, stackTrace, reason: 'platform_error');
    if (previousPlatformErrorHandler != null) {
      return previousPlatformErrorHandler(error, stackTrace);
    }
    return true;
  };
}
