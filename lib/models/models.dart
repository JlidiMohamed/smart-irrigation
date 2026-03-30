import 'package:flutter/material.dart';

class SensorData {
  final DateTime timestamp;
  final double humidity;
  final double temperature;
  final double soilMoisture;

  SensorData({
    required this.timestamp,
    required this.humidity,
    required this.temperature,
    required this.soilMoisture,
  });

  Map<String, dynamic> toJson() => {
        'timestamp': timestamp.toIso8601String(),
        'humidity': humidity,
        'temperature': temperature,
        'soilMoisture': soilMoisture,
      };

  factory SensorData.fromJson(Map<String, dynamic> json) => SensorData(
        timestamp: DateTime.parse(json['timestamp']),
        humidity: json['humidity'],
        temperature: json['temperature'],
        soilMoisture: json['soilMoisture'],
      );
}

class IrrigationSchedule {
  final String id;
  final String name;
  final TimeOfDay time;
  final List<bool> days; // 7 days Mon-Sun
  final int durationMinutes;
  bool isActive;
  final String? zoneId;

  IrrigationSchedule({
    required this.id,
    required this.name,
    required this.time,
    required this.days,
    required this.durationMinutes,
    this.isActive = true,
    this.zoneId,
  });
}

class IrrigationZone {
  final String id;
  String name;
  String emoji;
  double soilMoisture;
  bool isActive;

  IrrigationZone({
    required this.id,
    required this.name,
    this.emoji = '🌱',
    this.soilMoisture = 50.0,
    this.isActive = true,
  });
}

class IrrigationEvent {
  final DateTime startTime;
  final DateTime endTime;
  final String trigger; // 'manual', 'scheduled', 'auto'
  final double waterUsedLiters;

  IrrigationEvent({
    required this.startTime,
    required this.endTime,
    required this.trigger,
    required this.waterUsedLiters,
  });
}

extension TimeOfDayFormat on TimeOfDay {
  String fmt() {
    final h = hour.toString().padLeft(2, '0');
    final m = minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}

