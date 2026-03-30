// Copyright (c) 2026 Mohamed Jlidi. All Rights Reserved.
// Unauthorized use, copying, or distribution is strictly prohibited.
// Contact: mohamedjlidi210@gmail.com

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlantProfile {
  final String id, name, emoji;
  final double moistureThreshold; // auto-irrigate below this
  final double idealMoisture;     // target moisture
  const PlantProfile({required this.id, required this.name, required this.emoji,
      required this.moistureThreshold, required this.idealMoisture});
}

class SettingsService extends ChangeNotifier {
  static const List<PlantProfile> plantProfiles = [
    PlantProfile(id: 'general',    name: 'General',    emoji: 'ðŸŒ±', moistureThreshold: 25, idealMoisture: 60),
    PlantProfile(id: 'tomato',     name: 'Tomato',     emoji: 'ðŸ…', moistureThreshold: 40, idealMoisture: 70),
    PlantProfile(id: 'rose',       name: 'Rose',       emoji: 'ðŸŒ¹', moistureThreshold: 35, idealMoisture: 65),
    PlantProfile(id: 'cactus',     name: 'Cactus',     emoji: 'ðŸŒµ', moistureThreshold: 10, idealMoisture: 20),
    PlantProfile(id: 'lawn',       name: 'Lawn',       emoji: 'ðŸŒ¿', moistureThreshold: 30, idealMoisture: 55),
    PlantProfile(id: 'vegetables', name: 'Vegetables', emoji: 'ðŸ¥¦', moistureThreshold: 45, idealMoisture: 75),
  ];

  bool _isDarkMode = false;
  String _language = 'en'; // 'en', 'fr', 'ar'
  bool _autoIrrigationEnabled = false;
  double _autoIrrigationThreshold = 25.0;
  double _waterCostPerLiter = 0.003;
  String _plantProfileId = 'general';
  double _weeklyWaterGoal = 100.0;
  bool _notificationsEnabled = true;
  String _tempUnit = 'C'; // 'C' or 'F'
  String _volumeUnit = 'L'; // 'L' or 'gal'

  bool get isDarkMode => _isDarkMode;
  String get language => _language;
  bool get autoIrrigationEnabled => _autoIrrigationEnabled;
  double get autoIrrigationThreshold => _autoIrrigationThreshold;
  double get waterCostPerLiter => _waterCostPerLiter;
  String get plantProfileId => _plantProfileId;
  // Keep backward compat alias
  String get plantProfile => _plantProfileId;
  double get weeklyWaterGoal => _weeklyWaterGoal;
  bool get notificationsEnabled => _notificationsEnabled;
  String get tempUnit => _tempUnit;
  String get volumeUnit => _volumeUnit;
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;
  PlantProfile get currentPlant => plantProfiles.firstWhere((p) => p.id == _plantProfileId,
      orElse: () => plantProfiles.first);

  String formatTemp(double c) => _tempUnit == 'C'
      ? '${c.toStringAsFixed(1)}Â°C'
      : '${(c * 9 / 5 + 32).toStringAsFixed(1)}Â°F';
  String formatVolume(double l) => _volumeUnit == 'L'
      ? '${l.toStringAsFixed(1)}L'
      : '${(l * 0.264172).toStringAsFixed(2)}gal';

  Future<void> load() async {
    final p = await SharedPreferences.getInstance();
    _isDarkMode             = p.getBool('darkMode') ?? false;
    _language               = p.getString('language') ?? 'en';
    _autoIrrigationEnabled  = p.getBool('autoIrrigation') ?? false;
    _autoIrrigationThreshold= p.getDouble('autoThreshold') ?? 25.0;
    _waterCostPerLiter      = p.getDouble('waterCost') ?? 0.003;
    _plantProfileId         = p.getString('plantProfile') ?? 'general';
    _weeklyWaterGoal        = p.getDouble('weeklyGoal') ?? 100.0;
    _notificationsEnabled   = p.getBool('notifications') ?? true;
    _tempUnit               = p.getString('tempUnit') ?? 'C';
    _volumeUnit             = p.getString('volumeUnit') ?? 'L';
    notifyListeners();
  }

  Future<void> _save() async {
    final p = await SharedPreferences.getInstance();
    await p.setBool('darkMode', _isDarkMode);
    await p.setString('language', _language);
    await p.setBool('autoIrrigation', _autoIrrigationEnabled);
    await p.setDouble('autoThreshold', _autoIrrigationThreshold);
    await p.setDouble('waterCost', _waterCostPerLiter);
    await p.setString('plantProfile', _plantProfileId);
    await p.setDouble('weeklyGoal', _weeklyWaterGoal);
    await p.setBool('notifications', _notificationsEnabled);
    await p.setString('tempUnit', _tempUnit);
    await p.setString('volumeUnit', _volumeUnit);
  }

  void toggleDarkMode()           { _isDarkMode = !_isDarkMode; _save(); notifyListeners(); }
  void setLanguage(String v)      { _language = v; _save(); notifyListeners(); }
  void setAutoIrrigation(bool v)  { _autoIrrigationEnabled = v; _save(); notifyListeners(); }
  void setThreshold(double v)     { _autoIrrigationThreshold = v; _save(); notifyListeners(); }
  void setWaterCost(double v)     { _waterCostPerLiter = v; _save(); notifyListeners(); }
  void setPlantProfile(String v)  { _plantProfileId = v; _save(); notifyListeners(); }
  void setWeeklyGoal(double v)    { _weeklyWaterGoal = v; _save(); notifyListeners(); }
  void toggleNotifications()      { _notificationsEnabled = !_notificationsEnabled; _save(); notifyListeners(); }
  void setTempUnit(String v)      { _tempUnit = v; _save(); notifyListeners(); }
  void setVolumeUnit(String v)    { _volumeUnit = v; _save(); notifyListeners(); }
}

