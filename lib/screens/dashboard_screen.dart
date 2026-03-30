// Copyright (c) 2026 Mohamed Jlidi. All Rights Reserved.
// Unauthorized use, copying, or distribution is strictly prohibited.
// Contact: mohamedjlidi210@gmail.com

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/irrigation_service.dart';
import '../services/auth_service.dart';
import '../services/settings_service.dart';
import '../widgets/sensor_card.dart';
import '../widgets/control_panel.dart';
import '../theme/app_theme.dart';
import '../l10n/strings.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final svc  = context.watch<IrrigationService>();
    final auth = context.watch<AuthService>();
    final name = auth.user?.name.split(' ').first ?? 'there';

    return Scaffold(
      backgroundColor: context.scaffoldBg,
      body: CustomScrollView(
        slivers: [
          // â”€â”€ Gradient App Bar â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: const Color(0xFF14532D),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF052E16), Color(0xFF16A34A)],
                    begin: Alignment.topLeft, end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text("Hey $name ðŸ‘‹",
                                  style: const TextStyle(color: Color(0xFF86EFAC),
                                      fontSize: 13, fontWeight: FontWeight.w600)),
                              const Text("Smart Irrigation",
                                  style: TextStyle(color: Colors.white,
                                      fontSize: 22, fontWeight: FontWeight.w900)),
                            ]),
                            // Status pill
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 400),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                              decoration: BoxDecoration(
                                color: svc.isIrrigating
                                    ? const Color(0xFF22C55E)
                                    : Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: svc.isIrrigating ? [
                                  BoxShadow(color: const Color(0xFF22C55E).withOpacity(0.5),
                                      blurRadius: 12, spreadRadius: 2)
                                ] : [],
                              ),
                              child: Row(children: [
                                Container(width: 8, height: 8,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: svc.isIrrigating
                                          ? Colors.white : Colors.white.withOpacity(0.5),
                                    )),
                                const SizedBox(width: 6),
                                Text(svc.isIrrigating ? "Running ðŸ’§" : "Standby",
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 12,
                                        fontWeight: FontWeight.w700)),
                              ]),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Quick stats row
                        Row(children: [
                          _QuickStat(icon: "ðŸ’§",
                              value: "${svc.totalWaterThisWeek.toStringAsFixed(0)}L",
                              label: "This week"),
                          const SizedBox(width: 12),
                          _QuickStat(icon: "ðŸ”„",
                              value: "${svc.irrigationCountThisWeek}",
                              label: "Sessions"),
                          const SizedBox(width: 12),
                          _QuickStat(icon: "ðŸ“…",
                              value: "${svc.schedules.where((s) => s.isActive).length}",
                              label: "Active plans"),
                        ]),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // â”€â”€ Section title â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                  Row(children: [
                    Container(width: 4, height: 20,
                        decoration: BoxDecoration(
                          color: const Color(0xFF22C55E),
                          borderRadius: BorderRadius.circular(2),
                        )),
                    const SizedBox(width: 8),
                    Text(context.tr('live_sensors'),
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800,
                            color: context.textPrimary)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCFCE7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text("Live â—", style: TextStyle(
                          color: Color(0xFF16A34A), fontSize: 10, fontWeight: FontWeight.w700)),
                    ),
                  ]),
                  const SizedBox(height: 12),

                  // â”€â”€ Weather widget â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: context.cardBg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: context.borderColor),
                    ),
                    child: Row(children: [
                      Text(svc.weatherEmoji, style: const TextStyle(fontSize: 28)),
                      const SizedBox(width: 12),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(context.tr('weather'), style: TextStyle(color: context.textSecondary, fontSize: 11, fontWeight: FontWeight.w700)),
                        Text('${svc.weatherCondition[0].toUpperCase()}${svc.weatherCondition.substring(1)}  \u2022  ${context.read<SettingsService>().formatTemp(svc.outsideTemp)}',
                            style: TextStyle(color: context.textPrimary, fontWeight: FontWeight.w800, fontSize: 14)),
                      ])),
                      if (svc.willRainToday) Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: const Color(0xFF0EA5E9).withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                        child: const Text('\ud83c\udf27 Rain', style: TextStyle(color: Color(0xFF0EA5E9), fontWeight: FontWeight.w700, fontSize: 12)),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 12),

                  // â”€â”€ Alert banner â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                  if (svc.soilMoisture < 25) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Row(children: [
                        const Text("ðŸš¨", style: TextStyle(fontSize: 20)),
                        const SizedBox(width: 10),
                        Expanded(child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Low Soil Moisture!",
                                  style: TextStyle(
                                      color: Colors.red.shade700,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 13)),
                              Text("Soil is at ${svc.soilMoisture.toStringAsFixed(0)}% â€” irrigation recommended.",
                                  style: TextStyle(
                                      color: Colors.red.shade500,
                                      fontSize: 11)),
                            ])),
                        GestureDetector(
                          onTap: () => svc.startIrrigation(durationMinutes: 10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.red.shade500,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text("Water now",
                                style: TextStyle(color: Colors.white,
                                    fontWeight: FontWeight.w700, fontSize: 11)),
                          ),
                        ),
                      ]),
                    ),
                    const SizedBox(height: 12),
                  ] else if (svc.humidity < 35) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.orange.shade200),
                      ),
                      child: Row(children: [
                        const Text("âš ï¸", style: TextStyle(fontSize: 20)),
                        const SizedBox(width: 10),
                        Expanded(child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Low Humidity",
                                  style: TextStyle(
                                      color: Colors.orange.shade700,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 13)),
                              Text("Humidity at ${svc.humidity.toStringAsFixed(0)}% â€” monitor closely.",
                                  style: TextStyle(
                                      color: Colors.orange.shade600,
                                      fontSize: 11)),
                            ])),
                      ]),
                    ),
                    const SizedBox(height: 12),
                  ],

                  // â”€â”€ Sensors â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                  Row(children: [
                    Expanded(child: SensorCard(
                      label: "Humidity", emoji: "ðŸ’§",
                      value: "${svc.humidity.toStringAsFixed(1)}%",
                      progress: svc.humidity / 100,
                      gradientColors: const [Color(0xFF0EA5E9), Color(0xFF0369A1)],
                      bgColor: context.isDark ? const Color(0xFF1A2E3A) : const Color(0xFFE0F2FE),
                    )),
                    const SizedBox(width: 10),
                    Expanded(child: SensorCard(
                      label: "Temp", emoji: "ðŸŒ¡ï¸",
                      value: "${svc.temperature.toStringAsFixed(1)}Â°",
                      progress: svc.temperature / 50,
                      gradientColors: const [Color(0xFFF97316), Color(0xFFEA580C)],
                      bgColor: context.isDark ? const Color(0xFF2A1E10) : const Color(0xFFFFF7ED),
                    )),
                    const SizedBox(width: 10),
                    Expanded(child: SensorCard(
                      label: "Soil", emoji: "ðŸŒ¿",
                      value: "${svc.soilMoisture.toStringAsFixed(1)}%",
                      progress: svc.soilMoisture / 100,
                      gradientColors: const [Color(0xFF22C55E), Color(0xFF16A34A)],
                      bgColor: context.isDark ? const Color(0xFF122012) : const Color(0xFFF0FDF4),
                    )),
                  ]),

                  // â”€â”€ Efficiency Score â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                  const SizedBox(height: 22),
                  Row(children: [
                    Container(width: 4, height: 20, decoration: BoxDecoration(color: const Color(0xFF8B5CF6), borderRadius: BorderRadius.circular(2))),
                    const SizedBox(width: 8),
                    Text(context.tr('efficiency'), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: context.textPrimary)),
                  ]),
                  const SizedBox(height: 12),
                  _EfficiencyCard(score: svc.efficiencyScore),

                  const SizedBox(height: 22),

                  // â”€â”€ Control panel â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                  Row(children: [
                    Container(width: 4, height: 20,
                        decoration: BoxDecoration(color: const Color(0xFFF97316),
                            borderRadius: BorderRadius.circular(2))),
                    const SizedBox(width: 8),
                    Text(context.tr('manual_control'),
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800,
                            color: context.textPrimary)),
                  ]),
                  const SizedBox(height: 12),
                  const ControlPanel(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickStat extends StatelessWidget {
  final String icon, value, label;
  const _QuickStat({required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(children: [
        Text(icon, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 6),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(value, style: const TextStyle(color: Colors.white,
              fontWeight: FontWeight.w800, fontSize: 14)),
          Text(label, style: TextStyle(color: Colors.white.withOpacity(0.6),
              fontSize: 9)),
        ]),
      ]),
    ),
  );
}

class _EfficiencyCard extends StatelessWidget {
  final double score;
  const _EfficiencyCard({required this.score});

  Color get _color {
    if (score >= 70) return const Color(0xFF22C55E);
    if (score >= 40) return const Color(0xFFF97316);
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final label = score >= 70 ? context.tr('efficiency_perfect')
        : score >= 40 ? context.tr('efficiency_good') : context.tr('efficiency_low');
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _color.withOpacity(0.3)),
        boxShadow: [BoxShadow(color: _color.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Row(children: [
        SizedBox(width: 70, height: 70,
          child: Stack(alignment: Alignment.center, children: [
            CircularProgressIndicator(value: score / 100, strokeWidth: 7,
                backgroundColor: _color.withOpacity(0.15),
                valueColor: AlwaysStoppedAnimation(_color)),
            Text('${score.toInt()}%', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: _color)),
          ]),
        ),
        const SizedBox(width: 16),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(context.tr('efficiency'), style: TextStyle(color: context.textSecondary, fontSize: 11, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: context.textPrimary, fontWeight: FontWeight.w900, fontSize: 16)),
          const SizedBox(height: 4),
          Text('Based on weekly water goal', style: TextStyle(color: context.textSecondary, fontSize: 11)),
        ])),
      ]),
    );
  }
}

