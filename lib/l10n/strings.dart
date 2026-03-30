import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/settings_service.dart';

class S {
  static const Map<String, Map<String, String>> _t = {
    'en': {
      'app_name': 'Smart Irrigation',
      'dashboard': 'Dashboard', 'schedule': 'Schedule',
      'history': 'History', 'profile': 'Profile', 'settings': 'Settings',
      'live_sensors': 'Live Sensors', 'manual_control': 'Manual Control',
      'analytics': 'Analytics', 'sign_in': 'Sign In', 'sign_out': 'Sign Out',
      'dark_mode': 'Dark Mode', 'language': 'Language',
      'auto_irrigation': 'Auto-Irrigation',
      'auto_irrigation_desc': 'Start automatically when soil is too dry',
      'threshold': 'Moisture Threshold',
      'plant_profile': 'Plant Profile', 'water_goal': 'Weekly Water Goal',
      'water_cost': 'Water Cost (\u20ac/L)', 'efficiency': 'Efficiency Score',
      'this_week': 'This week', 'sessions': 'Sessions', 'active_plans': 'Active plans',
      'water_now': 'Water now', 'low_moisture': 'Low Soil Moisture!',
      'low_humidity': 'Low Humidity', 'add_schedule': 'Add Schedule',
      'save': 'Save', 'cancel': 'Cancel', 'delete': 'Delete',
      'export_csv': 'Export CSV', 'weather': 'Weather',
      'zones': 'Zones', 'add_zone': 'Add Zone',
      'notifications': 'Notifications', 'units': 'Units',
      'temp_unit': 'Temperature', 'volume_unit': 'Volume',
      'monthly_usage': 'Monthly Usage', 'water_cost_week': 'Est. Water Cost',
      'efficiency_perfect': 'Excellent \ud83c\udf1f', 'efficiency_good': 'Good \ud83d\udc4d',
      'efficiency_low': 'Needs Attention \u26a0\ufe0f',
      'onboarding_skip': 'Skip', 'get_started': 'Get Started \u2192',
      'rain_expected': 'Rain expected today',
      'auto_paused': 'Auto-irrigation paused (rain forecast)',
      'zone_garden': 'Garden', 'zone_lawn': 'Lawn', 'zone_vegetable': 'Vegetable',
      'new_zone': 'New Zone', 'zone_name': 'Zone Name',
      'notifications_enabled': 'Push Notifications',
      'notification_desc': 'Alerts for low moisture & irrigation events',
      // Legacy keys for compatibility
      'schedule_tab': 'Schedule', 'history_tab': 'History', 'profile_tab': 'Profile',
      'auto_threshold': 'Moisture Threshold',
      'efficiency_score': 'Efficiency Score',
      'edit_name': 'Edit Display Name', 'change_password': 'Change Password',
      'good_morning': 'Good morning', 'good_afternoon': 'Good afternoon',
      'good_evening': 'Good evening', 'running': 'Running', 'standby': 'Standby',
      'choose_duration': 'Choose duration', 'remaining': 'remaining',
      'watering': 'Watering', 'no_schedules': 'No schedules yet',
      'new_schedule': 'New Schedule', 'no_sessions': 'No sessions yet!',
      'weekly_goal': 'Weekly Goal', 'estimated_cost': 'Estimated Cost',
      'monthly_usage_alt': 'Monthly Usage', 'download_csv': 'Download CSV',
      'perfect': 'Perfect', 'good': 'Good', 'needs_attention': 'Needs Attention',
    },
    'fr': {
      'app_name': 'Irrigation Intelligente',
      'dashboard': 'Tableau de bord', 'schedule': 'Planning',
      'history': 'Historique', 'profile': 'Profil', 'settings': 'Param\u00e8tres',
      'live_sensors': 'Capteurs en direct', 'manual_control': 'Contr\u00f4le manuel',
      'analytics': 'Analytiques', 'sign_in': 'Se connecter', 'sign_out': 'Se d\u00e9connecter',
      'dark_mode': 'Mode sombre', 'language': 'Langue',
      'auto_irrigation': 'Auto-irrigation',
      'auto_irrigation_desc': 'D\u00e9marrer automatiquement si sol trop sec',
      'threshold': 'Seuil d\'humidit\u00e9',
      'plant_profile': 'Profil de plante', 'water_goal': 'Objectif hebdomadaire',
      'water_cost': 'Co\u00fbt de l\'eau (\u20ac/L)', 'efficiency': 'Score d\'efficacit\u00e9',
      'this_week': 'Cette semaine', 'sessions': 'Sessions', 'active_plans': 'Plans actifs',
      'water_now': 'Arroser', 'low_moisture': 'Sol trop sec !',
      'low_humidity': 'Humidit\u00e9 faible', 'add_schedule': 'Ajouter planning',
      'save': 'Enregistrer', 'cancel': 'Annuler', 'delete': 'Supprimer',
      'export_csv': 'Exporter CSV', 'weather': 'M\u00e9t\u00e9o',
      'zones': 'Zones', 'add_zone': 'Ajouter zone',
      'notifications': 'Notifications', 'units': 'Unit\u00e9s',
      'temp_unit': 'Temp\u00e9rature', 'volume_unit': 'Volume',
      'monthly_usage': 'Consommation mensuelle', 'water_cost_week': 'Co\u00fbt estim\u00e9',
      'efficiency_perfect': 'Excellent \ud83c\udf1f', 'efficiency_good': 'Bien \ud83d\udc4d',
      'efficiency_low': 'A am\u00e9liorer \u26a0\ufe0f',
      'onboarding_skip': 'Passer', 'get_started': 'Commencer \u2192',
      'rain_expected': 'Pluie pr\u00e9vue aujourd\'hui',
      'auto_paused': 'Auto-irrigation suspendue (pluie pr\u00e9vue)',
      'zone_garden': 'Jardin', 'zone_lawn': 'Pelouse', 'zone_vegetable': 'Potager',
      'new_zone': 'Nouvelle zone', 'zone_name': 'Nom de la zone',
      'notifications_enabled': 'Notifications push',
      'notification_desc': 'Alertes sol sec & \u00e9v\u00e9nements d\'irrigation',
      // Legacy keys for compatibility
      'schedule_tab': 'Planning', 'history_tab': 'Historique', 'profile_tab': 'Profil',
      'auto_threshold': 'Seuil d\'humidit\u00e9',
      'efficiency_score': 'Score d\'efficacit\u00e9',
      'edit_name': 'Modifier le nom d\'affichage', 'change_password': 'Changer le mot de passe',
      'good_morning': 'Bonjour', 'good_afternoon': 'Bon apr\u00e8s-midi',
      'good_evening': 'Bonsoir', 'running': 'En cours', 'standby': 'En attente',
      'choose_duration': 'Choisir la dur\u00e9e', 'remaining': 'restant',
      'watering': 'Arrosage', 'no_schedules': 'Aucun planning',
      'new_schedule': 'Nouveau planning', 'no_sessions': 'Aucune s\u00e9ance !',
      'weekly_goal': 'Objectif hebdomadaire', 'estimated_cost': 'Co\u00fbt estim\u00e9',
      'download_csv': 'T\u00e9l\u00e9charger CSV',
      'perfect': 'Parfait', 'good': 'Bien', 'needs_attention': 'Attention requise',
    },
    'ar': {
      'app_name': '\u0627\u0644\u0631\u064a \u0627\u0644\u0630\u0643\u064a',
      'dashboard': '\u0644\u0648\u062d\u0629 \u0627\u0644\u062a\u062d\u0643\u0645', 'schedule': '\u0627\u0644\u062c\u062f\u0648\u0644',
      'history': '\u0627\u0644\u0633\u062c\u0644', 'profile': '\u0627\u0644\u0645\u0644\u0641', 'settings': '\u0627\u0644\u0625\u0639\u062f\u0627\u062f\u0627\u062a',
      'live_sensors': '\u0627\u0644\u0645\u0633\u062a\u0634\u0639\u0631\u0627\u062a \u0627\u0644\u062d\u064a\u0629', 'manual_control': '\u0627\u0644\u062a\u062d\u0643\u0645 \u0627\u0644\u064a\u062f\u0648\u064a',
      'analytics': '\u0627\u0644\u062a\u062d\u0644\u064a\u0644\u0627\u062a', 'sign_in': '\u062a\u0633\u062c\u064a\u0644 \u0627\u0644\u062f\u062e\u0648\u0644', 'sign_out': '\u062a\u0633\u062c\u064a\u0644 \u0627\u0644\u062e\u0631\u0648\u062c',
      'dark_mode': '\u0627\u0644\u0648\u0636\u0639 \u0627\u0644\u062f\u0627\u0643\u0646', 'language': '\u0627\u0644\u0644\u063a\u0629',
      'auto_irrigation': '\u0627\u0644\u0631\u064a \u0627\u0644\u062a\u0644\u0642\u0627\u0626\u064a',
      'auto_irrigation_desc': '\u0627\u0644\u062a\u0634\u063a\u064a\u0644 \u062a\u0644\u0642\u0627\u0626\u064a\u064b\u0627 \u0639\u0646\u062f \u062c\u0641\u0627\u0641 \u0627\u0644\u062a\u0631\u0628\u0629',
      'threshold': '\u062d\u062f \u0627\u0644\u0631\u0637\u0648\u0628\u0629',
      'plant_profile': '\u0645\u0644\u0641 \u0627\u0644\u0646\u0628\u0627\u062a', 'water_goal': '\u0647\u062f\u0641 \u0627\u0644\u0645\u064a\u0627\u0647 \u0627\u0644\u0623\u0633\u0628\u0648\u0639\u064a',
      'water_cost': '\u062a\u0643\u0644\u0641\u0629 \u0627\u0644\u0645\u064a\u0627\u0647 (\u20ac/\u0644)', 'efficiency': '\u062f\u0631\u062c\u0629 \u0627\u0644\u0643\u0641\u0627\u0621\u0629',
      'this_week': '\u0647\u0630\u0627 \u0627\u0644\u0623\u0633\u0628\u0648\u0639', 'sessions': '\u062c\u0644\u0633\u0627\u062a', 'active_plans': '\u062e\u0637\u0637 \u0646\u0634\u0637\u0629',
      'water_now': '\u0631\u064a \u0627\u0644\u0622\u0646', 'low_moisture': '\u0631\u0637\u0648\u0628\u0629 \u0627\u0644\u062a\u0631\u0628\u0629 \u0645\u0646\u062e\u0641\u0636\u0629!',
      'low_humidity': '\u0631\u0637\u0648\u0628\u0629 \u0645\u0646\u062e\u0641\u0636\u0629', 'add_schedule': '\u0625\u0636\u0627\u0641\u0629 \u062c\u062f\u0648\u0644',
      'save': '\u062d\u0641\u0638', 'cancel': '\u0625\u0644\u063a\u0627\u0621', 'delete': '\u062d\u0630\u0641',
      'export_csv': '\u062a\u0635\u062f\u064a\u0631 CSV', 'weather': '\u0627\u0644\u0637\u0642\u0633',
      'zones': '\u0627\u0644\u0645\u0646\u0627\u0637\u0642', 'add_zone': '\u0625\u0636\u0627\u0641\u0629 \u0645\u0646\u0637\u0642\u0629',
      'notifications': '\u0627\u0644\u0625\u0634\u0639\u0627\u0631\u0627\u062a', 'units': '\u0627\u0644\u0648\u062d\u062f\u0627\u062a',
      'temp_unit': '\u062f\u0631\u062c\u0629 \u0627\u0644\u062d\u0631\u0627\u0631\u0629', 'volume_unit': '\u0627\u0644\u062d\u062c\u0645',
      'monthly_usage': '\u0627\u0644\u0627\u0633\u062a\u0647\u0644\u0627\u0643 \u0627\u0644\u0634\u0647\u0631\u064a', 'water_cost_week': '\u0627\u0644\u062a\u0643\u0644\u0641\u0629 \u0627\u0644\u0645\u0642\u062f\u0631\u0629',
      'efficiency_perfect': '\u0645\u0645\u062a\u0627\u0632 \ud83c\udf1f', 'efficiency_good': '\u062c\u064a\u062f \ud83d\udc4d',
      'efficiency_low': '\u064a\u062d\u062a\u0627\u062c \u062a\u062d\u0633\u064a\u0646 \u26a0\ufe0f',
      'onboarding_skip': '\u062a\u062e\u0637\u064a', 'get_started': '\u0627\u0628\u062f\u0623 \u0627\u0644\u0622\u0646 \u2190',
      'rain_expected': '\u0645\u062a\u0648\u0642\u0639 \u0647\u0637\u0648\u0644 \u0645\u0637\u0631 \u0627\u0644\u064a\u0648\u0645',
      'auto_paused': '\u0627\u0644\u0631\u064a \u0627\u0644\u062a\u0644\u0642\u0627\u0626\u064a \u0645\u0648\u0642\u0641 (\u062a\u0648\u0642\u0639 \u0645\u0637\u0631)',
      'zone_garden': '\u0627\u0644\u062d\u062f\u064a\u0642\u0629', 'zone_lawn': '\u0627\u0644\u0639\u0634\u0628', 'zone_vegetable': '\u0627\u0644\u062e\u0636\u0631\u0648\u0627\u062a',
      'new_zone': '\u0645\u0646\u0637\u0642\u0629 \u062c\u062f\u064a\u062f\u0629', 'zone_name': '\u0627\u0633\u0645 \u0627\u0644\u0645\u0646\u0637\u0642\u0629',
      'notifications_enabled': '\u0627\u0644\u0625\u0634\u0639\u0627\u0631\u0627\u062a \u0627\u0644\u0641\u0648\u0631\u064a\u0629',
      'notification_desc': '\u062a\u0646\u0628\u064a\u0647\u0627\u062a \u062c\u0641\u0627\u0641 \u0627\u0644\u062a\u0631\u0628\u0629 \u0648\u0623\u062d\u062f\u0627\u062b \u0627\u0644\u0631\u064a',
      // Legacy keys for compatibility
      'schedule_tab': '\u0627\u0644\u062c\u062f\u0648\u0644', 'history_tab': '\u0627\u0644\u0633\u062c\u0644', 'profile_tab': '\u0627\u0644\u0645\u0644\u0641',
      'auto_threshold': '\u062d\u062f \u0627\u0644\u0631\u0637\u0648\u0628\u0629',
      'efficiency_score': '\u062f\u0631\u062c\u0629 \u0627\u0644\u0643\u0641\u0627\u0621\u0629',
      'edit_name': '\u062a\u0639\u062f\u064a\u0644 \u0627\u0644\u0627\u0633\u0645', 'change_password': '\u062a\u063a\u064a\u064a\u0631 \u0643\u0644\u0645\u0629 \u0627\u0644\u0633\u0631',
      'good_morning': '\u0635\u0628\u0627\u062d \u0627\u0644\u062e\u064a\u0631', 'good_afternoon': '\u0645\u0633\u0627\u0621 \u0627\u0644\u062e\u064a\u0631',
      'good_evening': '\u0645\u0633\u0627\u0621 \u0627\u0644\u062e\u064a\u0631', 'running': '\u064a\u0639\u0645\u0644', 'standby': '\u062c\u0627\u0647\u0632',
      'choose_duration': '\u0627\u062e\u062a\u0631 \u0627\u0644\u0645\u062f\u0629', 'remaining': '\u0645\u062a\u0628\u0642\u064a',
      'watering': '\u0631\u064a', 'no_schedules': '\u0644\u0627 \u062c\u062f\u0627\u0648\u0644 \u0628\u0639\u062f',
      'new_schedule': '\u062c\u062f\u0648\u0644 \u062c\u062f\u064a\u062f', 'no_sessions': '\u0644\u0627 \u062c\u0644\u0633\u0627\u062a \u0628\u0639\u062f!',
      'weekly_goal': '\u0627\u0644\u0647\u062f\u0641 \u0627\u0644\u0623\u0633\u0628\u0648\u0639\u064a', 'estimated_cost': '\u0627\u0644\u062a\u0643\u0644\u0641\u0629 \u0627\u0644\u0645\u0642\u062f\u0631\u0629',
      'download_csv': '\u062a\u062d\u0645\u064a\u0644 CSV',
      'perfect': '\u0645\u0645\u062a\u0627\u0632', 'good': '\u062c\u064a\u062f', 'needs_attention': '\u064a\u062d\u062a\u0627\u062c \u0645\u062a\u0627\u0628\u0639\u0629',
    },
  };

  static String of(BuildContext context, String key) {
    try {
      final lang = Provider.of<SettingsService>(context, listen: false).language;
      return _t[lang]?[key] ?? _t['en']![key] ?? key;
    } catch (_) {
      return _t['en']![key] ?? key;
    }
  }
}

// Keep AppStrings for backward compatibility
class AppStrings {
  AppStrings._();
  static String get(String key, String lang) {
    return S._t[lang]?[key] ?? S._t['en']![key] ?? key;
  }
}

extension ContextStrings on BuildContext {
  String tr(String key) => S.of(this, key);
  bool get isRTL {
    try {
      return Provider.of<SettingsService>(this, listen: false).language == 'ar';
    } catch (_) {
      return false;
    }
  }
}
