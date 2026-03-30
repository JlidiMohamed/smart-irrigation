// Copyright (c) 2026 Mohamed Jlidi. All Rights Reserved.
// Unauthorized use, copying, or distribution is strictly prohibited.
// Contact: mohamedjlidi210@gmail.com

import 'package:flutter/material.dart';

/// Mobile stub â€” notifications via le systÃ¨me Android (Ã  Ã©tendre avec
/// flutter_local_notifications si besoin de vraies notifs en arriÃ¨re-plan).
class NotificationService {
  static bool _granted = false;
  static bool _initialized = false;

  static Future<bool> requestPermission() async {
    // On Android 13+, la permission POST_NOTIFICATIONS est dans le manifest.
    // Pour l'instant on retourne true â€” Ã  implÃ©menter avec
    // flutter_local_notifications pour les vraies notifs systÃ¨me.
    _granted = true;
    _initialized = true;
    return true;
  }

  static void show({
    required String title, required String body,
    required String tag, String icon = '',
    bool debounce = true,
  }) {
    // Stub mobile â€” implÃ©menter avec flutter_local_notifications
  }

  static void lowMoisture(double value) {}
  static void autoIrrigationStarted() {}
  static void irrigationStopped(double liters) {}
  static void rainForecast() {}

  static bool get isSupported => true;
  static bool get isGranted => _granted;
  static bool get isInitialized => _initialized;
  static String get permissionStatus => _granted ? 'granted' : 'default';

  static String get statusLabel => _granted ? 'ActivÃ©es âœ…' : 'Non demandÃ©es';

  static Color get statusColor =>
      _granted ? const Color(0xFF16A34A) : Colors.orange;
}

