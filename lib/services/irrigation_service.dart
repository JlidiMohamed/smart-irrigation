// Copyright (c) 2026 Mohamed Jlidi. All Rights Reserved.
// Unauthorized use, copying, or distribution is strictly prohibited.
// Contact: mohamedjlidi210@gmail.com

import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/models.dart';
import 'notification_service.dart';

// â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
// Firestore structure:
//   sensors/{uid}/latest/current     â† latest reading (realtime)
//   sensors/{uid}/readings/{auto-id} â† sensor history archive
//   history/{uid}/events/{auto-id}   â† irrigation events log
// â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•

class IrrigationService extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String? _uid;

  // â”€â”€ Sensor state â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  double _humidity     = 62.0;
  double _temperature  = 24.5;
  double _soilMoisture = 45.0;

  double get humidity      => _humidity;
  double get temperature   => _temperature;
  double get soilMoisture  => _soilMoisture;

  // â”€â”€ Irrigation state â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  bool _isIrrigating     = false;
  int  _remainingSeconds = 0;
  Timer? _irrigationTimer;
  Timer? _sensorTimer;

  bool get isIrrigating     => _isIrrigating;
  int  get remainingSeconds => _remainingSeconds;

  // â”€â”€ Zones â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  final List<IrrigationZone> _zones = [
    IrrigationZone(id: 'z1', name: 'Garden', emoji: 'ðŸŒ±', soilMoisture: 52.0),
    IrrigationZone(id: 'z2', name: 'Lawn', emoji: 'ðŸŒ¿', soilMoisture: 41.0),
    IrrigationZone(id: 'z3', name: 'Vegetables', emoji: 'ðŸ¥¦', soilMoisture: 68.0),
  ];
  List<IrrigationZone> get zones => List.unmodifiable(_zones);

  void addZone(IrrigationZone z) { _zones.add(z); notifyListeners(); }
  void deleteZone(String id) { _zones.removeWhere((z) => z.id == id); notifyListeners(); }
  void updateZoneName(String id, String name) {
    final idx = _zones.indexWhere((z) => z.id == id);
    if (idx != -1) { _zones[idx].name = name; notifyListeners(); }
  }

  // â”€â”€ Auto-irrigation â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  bool _autoEnabled = false;
  double _autoThreshold = 25.0;

  void updateAutoSettings(bool enabled, double threshold) {
    _autoEnabled = enabled;
    _autoThreshold = threshold;
    notifyListeners();
  }

  // â”€â”€ Weather simulation â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  String _weatherCondition = 'sunny';
  double _outsideTemp = 22.0;
  bool _willRainToday = false;
  Timer? _weatherTimer;

  String get weatherCondition => _weatherCondition;
  double get outsideTemp => _outsideTemp;
  bool get willRainToday => _willRainToday;

  String get weatherEmoji {
    switch (_weatherCondition) {
      case 'rainy': return 'ðŸŒ§';
      case 'cloudy': return 'â˜ï¸';
      case 'windy': return 'ðŸ’¨';
      default: return 'â˜€ï¸';
    }
  }

  void _updateWeather() {
    final rng = Random();
    final roll = rng.nextDouble();
    if (roll < 0.50) {
      _weatherCondition = 'sunny';
    } else if (roll < 0.80) {
      _weatherCondition = 'cloudy';
    } else if (roll < 0.95) {
      _weatherCondition = 'rainy';
      if (!_willRainToday) NotificationService.rainForecast();
      _willRainToday = true;
    } else {
      _weatherCondition = 'windy';
    }
    // Vary outside temp by time of day (15-32Â°C)
    final hour = DateTime.now().hour;
    _outsideTemp = (15.0 + (17.0 * (1.0 - ((hour - 14).abs() / 14.0))).clamp(0.0, 17.0))
        + (rng.nextDouble() - 0.5) * 2;
    notifyListeners();
  }

  // â”€â”€ Weekly goal â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  double _weeklyGoal = 100.0;
  void setWeeklyGoal(double goal) { _weeklyGoal = goal; notifyListeners(); }

  double get efficiencyScore =>
      (_weeklyGoal > 0 ? (totalWaterThisWeek / _weeklyGoal * 100).clamp(0, 100) : 0);

  // â”€â”€ Monthly stats â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Map<String, double> get monthlyWaterUsage {
    final monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final now = DateTime.now();
    // Use a list to preserve order (last 6 months)
    final orderedKeys = <String>[];
    final result = <String, double>{};
    for (int i = 5; i >= 0; i--) {
      // DateTime handles month=0 -> Dec of previous year correctly
      final m = DateTime(now.year, now.month - i, 1);
      final key = '${monthNames[m.month - 1]}${m.year}';
      orderedKeys.add(key);
      result[key] = 0.0;
    }
    for (final e in _history) {
      final monthsAgo = (now.year - e.startTime.year) * 12 +
          now.month - e.startTime.month;
      if (monthsAgo >= 0 && monthsAgo < 6) {
        final m = DateTime(now.year, now.month - monthsAgo, 1);
        final key = '${monthNames[m.month - 1]}${m.year}';
        if (result.containsKey(key)) {
          result[key] = (result[key] ?? 0) + e.waterUsedLiters;
        }
      }
    }
    // Return with short month labels for display
    final displayResult = <String, double>{};
    for (int i = 0; i < orderedKeys.length; i++) {
      final k = orderedKeys[i];
      // Extract just the month part (first 3 chars)
      displayResult[k.substring(0, 3)] = result[k] ?? 0.0;
    }
    return displayResult;
  }

  // â”€â”€ Schedules â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  final List<IrrigationSchedule> _schedules = [
    IrrigationSchedule(
      id: '1', name: 'Morning Cycle',
      time: TimeOfDay(hour: 6, minute: 30),
      days: [true, true, true, true, true, false, false],
      durationMinutes: 20, isActive: true,
    ),
    IrrigationSchedule(
      id: '2', name: 'Evening Cycle',
      time: TimeOfDay(hour: 18, minute: 0),
      days: [false, true, false, true, false, true, false],
      durationMinutes: 15, isActive: false,
    ),
  ];
  List<IrrigationSchedule> get schedules => List.unmodifiable(_schedules);

  // â”€â”€ History â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  final List<IrrigationEvent> _history = [];
  List<IrrigationEvent> get history => List.unmodifiable(_history);

  // â”€â”€ Sensor history for charts â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  final List<SensorData> _sensorHistory = [];
  List<SensorData> get sensorHistory => List.unmodifiable(_sensorHistory);

  StreamSubscription? _sensorStream;

  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
  IrrigationService() {
    _generateInitialHistory();
    _startSensorSimulation();
    _updateWeather();
    _weatherTimer = Timer.periodic(const Duration(minutes: 5), (_) => _updateWeather());
  }

  // â”€â”€ Called after login â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  void setUser(String uid) {
    _uid = uid;
    _listenToLatestSensor();
    _loadHistoryFromFirestore();
  }

  void clearUser() {
    _uid = null;
    _sensorStream?.cancel();
  }

  // â”€â”€ Firestore real-time listener â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  void _listenToLatestSensor() {
    if (_uid == null) return;
    _sensorStream?.cancel();
    _sensorStream = _db
        .collection('sensors').doc(_uid)
        .collection('latest').doc('current')
        .snapshots()
        .listen((snap) {
      if (!snap.exists) return;
      final data = snap.data()!;
      // If a real hardware device writes 'source: hardware', use those values
      if ((data['source'] as String? ?? '') == 'hardware') {
        _humidity     = (data['humidity']     as num).toDouble();
        _temperature  = (data['temperature']  as num).toDouble();
        _soilMoisture = (data['soilMoisture'] as num).toDouble();
        notifyListeners();
      }
    });
  }

  // â”€â”€ Write sensor to Firestore â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Future<void> _pushSensorToFirestore(SensorData r) async {
    if (_uid == null) return;
    try {
      final ref = _db.collection('sensors').doc(_uid);
      final payload = {
        'humidity':     r.humidity,
        'temperature':  r.temperature,
        'soilMoisture': r.soilMoisture,
        'timestamp':    FieldValue.serverTimestamp(),
        'source':       'simulation',
      };
      await ref.collection('latest').doc('current').set(payload);
      await ref.collection('readings').add(payload);
    } catch (_) {} // silent if not configured
  }

  // â”€â”€ Load irrigation events from Firestore â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Future<void> _loadHistoryFromFirestore() async {
    if (_uid == null) return;
    try {
      final snap = await _db
          .collection('history').doc(_uid)
          .collection('events')
          .orderBy('startTime', descending: true)
          .limit(50)
          .get();
      for (final doc in snap.docs) {
        final d = doc.data();
        _history.add(IrrigationEvent(
          startTime:       (d['startTime']       as Timestamp).toDate(),
          endTime:         (d['endTime']         as Timestamp).toDate(),
          trigger:          d['trigger']          as String,
          waterUsedLiters: (d['waterUsedLiters'] as num).toDouble(),
        ));
      }
      notifyListeners();
    } catch (_) {} // silent if not configured
  }

  // â”€â”€ Write event to Firestore â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Future<void> _pushEventToFirestore(IrrigationEvent e) async {
    if (_uid == null) return;
    try {
      await _db
          .collection('history').doc(_uid)
          .collection('events')
          .add({
        'startTime':       Timestamp.fromDate(e.startTime),
        'endTime':         Timestamp.fromDate(e.endTime),
        'trigger':         e.trigger,
        'waterUsedLiters': e.waterUsedLiters,
      });
    } catch (_) {} // silent if not configured
  }

  // â”€â”€ Sensor simulation â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  void _generateInitialHistory() {
    final rng = Random();
    final now = DateTime.now();
    for (int i = 47; i >= 0; i--) {
      _sensorHistory.add(SensorData(
        timestamp:    now.subtract(Duration(hours: i)),
        humidity:     50 + rng.nextDouble() * 35,
        temperature:  20 + rng.nextDouble() * 12,
        soilMoisture: 30 + rng.nextDouble() * 50,
      ));
    }
    for (int i = 6; i >= 0; i--) {
      final start = now.subtract(Duration(days: i, hours: 6));
      _history.add(IrrigationEvent(
        startTime: start,
        endTime:   start.add(Duration(minutes: 15 + rng.nextInt(15))),
        trigger:   i % 3 == 0 ? 'manual' : 'scheduled',
        waterUsedLiters: 8 + rng.nextDouble() * 10,
      ));
    }
  }

  void _startSensorSimulation() {
    final rng = Random();
    _sensorTimer = Timer.periodic(const Duration(seconds: 3), (_) async {
      _humidity     = (_humidity     + (rng.nextDouble() - 0.5) * 3).clamp(30.0, 95.0);
      _temperature  = (_temperature  + (rng.nextDouble() - 0.5) * 0.5).clamp(15.0, 45.0);
      _soilMoisture = _isIrrigating
          ? (_soilMoisture + rng.nextDouble() * 1.5).clamp(0.0, 100.0)
          : (_soilMoisture - rng.nextDouble() * 0.3).clamp(0.0, 100.0);

      // Auto-irrigation check
      if (_autoEnabled && _soilMoisture < _autoThreshold && !_isIrrigating) {
        NotificationService.autoIrrigationStarted();
        startIrrigation(durationMinutes: 10, trigger: 'auto');
      }

      // Low moisture warning (below 20%, independent of auto mode)
      if (_soilMoisture < 20.0 && !_isIrrigating) {
        NotificationService.lowMoisture(_soilMoisture);
      }

      final reading = SensorData(
        timestamp:    DateTime.now(),
        humidity:     _humidity,
        temperature:  _temperature,
        soilMoisture: _soilMoisture,
      );
      _sensorHistory.add(reading);
      if (_sensorHistory.length > 200) _sensorHistory.removeAt(0);
      await _pushSensorToFirestore(reading);
      notifyListeners();
    });
  }

  // â”€â”€ Manual control â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  void startIrrigation({int durationMinutes = 10, String trigger = 'manual'}) {
    if (_isIrrigating) return;
    _isIrrigating = true;
    _remainingSeconds = durationMinutes * 60;
    final startTime = DateTime.now();
    notifyListeners();
    _irrigationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _remainingSeconds--;
      if (_remainingSeconds <= 0) { _stopIrrigation(startTime, trigger); timer.cancel(); }
      notifyListeners();
    });
  }

  void stopIrrigation() {
    if (!_isIrrigating) return;
    _irrigationTimer?.cancel();
    _stopIrrigation(DateTime.now(), 'manual');
  }

  void _stopIrrigation(DateTime startTime, String trigger) {
    _isIrrigating = false;
    _remainingSeconds = 0;
    final endTime = DateTime.now();
    final event = IrrigationEvent(
      startTime: startTime, endTime: endTime, trigger: trigger,
      waterUsedLiters: endTime.difference(startTime).inSeconds / 60.0 * 1.2,
    );
    _history.insert(0, event);
    _pushEventToFirestore(event);
    NotificationService.irrigationStopped(event.waterUsedLiters);
    notifyListeners();
  }

  // â”€â”€ Schedules â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  void addSchedule(IrrigationSchedule s) { _schedules.add(s); notifyListeners(); }
  void toggleSchedule(String id) {
    final idx = _schedules.indexWhere((s) => s.id == id);
    if (idx != -1) { _schedules[idx].isActive = !_schedules[idx].isActive; notifyListeners(); }
  }
  void deleteSchedule(String id) { _schedules.removeWhere((s) => s.id == id); notifyListeners(); }

  // â”€â”€ Stats â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  double get totalWaterThisWeek {
    final weekAgo = DateTime.now().subtract(const Duration(days: 7));
    return _history.where((e) => e.startTime.isAfter(weekAgo))
        .fold(0.0, (sum, e) => sum + e.waterUsedLiters);
  }
  int get irrigationCountThisWeek {
    final weekAgo = DateTime.now().subtract(const Duration(days: 7));
    return _history.where((e) => e.startTime.isAfter(weekAgo)).length;
  }

  @override
  void dispose() {
    _sensorTimer?.cancel();
    _irrigationTimer?.cancel();
    _sensorStream?.cancel();
    _weatherTimer?.cancel();
    super.dispose();
  }
}

