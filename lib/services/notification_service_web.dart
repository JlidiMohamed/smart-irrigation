// Copyright (c) 2026 Mohamed Jlidi. All Rights Reserved.
// Unauthorized use, copying, or distribution is strictly prohibited.
// Contact: mohamedjlidi210@gmail.com

// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter/material.dart';

class NotificationService {
  static bool _granted = false;
  static bool _initialized = false;
  static final Map<String, DateTime> _lastShown = {};
  static const _debounce = Duration(minutes: 2);

  static Future<bool> requestPermission() async {
    if (!html.Notification.supported) return false;
    if (html.Notification.permission == 'granted') {
      _granted = true; _initialized = true; return true;
    }
    if (html.Notification.permission == 'denied') {
      _granted = false; _initialized = true; return false;
    }
    final result = await html.Notification.requestPermission();
    _granted = result == 'granted';
    _initialized = true;
    return _granted;
  }

  static void show({
    required String title, required String body,
    required String tag, String icon = '/icons/Icon-192.png',
    bool debounce = true,
  }) {
    if (!_granted || !html.Notification.supported) return;
    if (debounce) {
      final last = _lastShown[tag];
      if (last != null && DateTime.now().difference(last) < _debounce) return;
    }
    _lastShown[tag] = DateTime.now();
    html.Notification(title, body: body, icon: icon, tag: tag);
  }

  static void lowMoisture(double value) => show(
    title: 'âš ï¸ Sol trop sec',
    body: 'HumiditÃ© du sol Ã  ${value.toStringAsFixed(0)}% â€” irrigation recommandÃ©e.',
    tag: 'low_moisture',
  );
  static void autoIrrigationStarted() => show(
    title: 'ðŸ’§ Irrigation automatique dÃ©marrÃ©e',
    body: 'Le sol a atteint le seuil minimum. Irrigation en coursâ€¦',
    tag: 'auto_started', debounce: false,
  );
  static void irrigationStopped(double liters) => show(
    title: 'âœ… Irrigation terminÃ©e',
    body: '${liters.toStringAsFixed(1)} L utilisÃ©s.',
    tag: 'irrigation_done', debounce: false,
  );
  static void rainForecast() => show(
    title: 'ðŸŒ§ Pluie prÃ©vue aujourd\'hui',
    body: 'L\'irrigation automatique est suspendue.',
    tag: 'rain_forecast',
  );

  static bool get isSupported => html.Notification.supported;
  static bool get isGranted => _granted;
  static bool get isInitialized => _initialized;

  static String get permissionStatus => html.Notification.permission ?? 'default';

  static String get statusLabel {
    switch (permissionStatus) {
      case 'granted': return 'ActivÃ©es âœ…';
      case 'denied':  return 'BloquÃ©es âŒ';
      default:        return 'Non demandÃ©es';
    }
  }

  static Color get statusColor {
    switch (permissionStatus) {
      case 'granted': return const Color(0xFF16A34A);
      case 'denied':  return Colors.red;
      default:        return Colors.orange;
    }
  }
}

