import 'package:flutter/material.dart';

/// Mobile stub — notifications via le système Android (à étendre avec
/// flutter_local_notifications si besoin de vraies notifs en arrière-plan).
class NotificationService {
  static bool _granted = false;
  static bool _initialized = false;

  static Future<bool> requestPermission() async {
    // On Android 13+, la permission POST_NOTIFICATIONS est dans le manifest.
    // Pour l'instant on retourne true — à implémenter avec
    // flutter_local_notifications pour les vraies notifs système.
    _granted = true;
    _initialized = true;
    return true;
  }

  static void show({
    required String title, required String body,
    required String tag, String icon = '',
    bool debounce = true,
  }) {
    // Stub mobile — implémenter avec flutter_local_notifications
  }

  static void lowMoisture(double value) {}
  static void autoIrrigationStarted() {}
  static void irrigationStopped(double liters) {}
  static void rainForecast() {}

  static bool get isSupported => true;
  static bool get isGranted => _granted;
  static bool get isInitialized => _initialized;
  static String get permissionStatus => _granted ? 'granted' : 'default';

  static String get statusLabel => _granted ? 'Activées ✅' : 'Non demandées';

  static Color get statusColor =>
      _granted ? const Color(0xFF16A34A) : Colors.orange;
}
