import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/irrigation_service.dart';
import '../services/settings_service.dart';
import '../theme/app_theme.dart';
import '../l10n/strings.dart';
import '../utils/csv_export.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});
  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;
  @override
  void initState() { super.initState(); _tab = TabController(length: 2, vsync: this); }
  @override
  void dispose() { _tab.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final svc = context.watch<IrrigationService>();

    return Scaffold(
      backgroundColor: context.scaffoldBg,
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          SliverAppBar(
            pinned: true, expandedHeight: 140,
            backgroundColor: const Color(0xFF14532D),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF052E16), Color(0xFF15803D)],
                    begin: Alignment.topLeft, end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(20, 52, 20, 0),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text("📊 Analytics",
                      style: TextStyle(color: Colors.white, fontSize: 22,
                          fontWeight: FontWeight.w900)),
                  const SizedBox(height: 12),
                  // Summary pills
                  Row(children: [
                    _Pill("💧 ${svc.totalWaterThisWeek.toStringAsFixed(1)}L",
                        "This week"),
                    const SizedBox(width: 10),
                    _Pill("🔄 ${svc.irrigationCountThisWeek}",
                        "Sessions"),
                    const SizedBox(width: 10),
                    _Pill("📈 ${svc.irrigationCountThisWeek > 0 ? (svc.totalWaterThisWeek / svc.irrigationCountThisWeek).toStringAsFixed(1) : '0'}L",
                        "Avg/session"),
                  ]),
                ]),
              ),
            ),
            bottom: TabBar(
              controller: _tab,
              indicatorColor: const Color(0xFF4ADE80),
              indicatorWeight: 3,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white60,
              labelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
              tabs: const [Tab(text: "📈 Charts"), Tab(text: "🗂 Events")],
            ),
          ),
        ],
        body: TabBarView(
          controller: _tab,
          children: [
            _ChartsTab(svc: svc),
            _EventsTab(svc: svc),
          ],
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String value, label;
  const _Pill(this.value, this.label);
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.15),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.white.withOpacity(0.2)),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(value, style: const TextStyle(color: Colors.white,
          fontWeight: FontWeight.w800, fontSize: 12)),
      Text(label, style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 9)),
    ]),
  );
}

class _ChartsTab extends StatelessWidget {
  final IrrigationService svc;
  const _ChartsTab({required this.svc});

  @override
  Widget build(BuildContext context) {
    final data = svc.sensorHistory.length > 24
        ? svc.sensorHistory.sublist(svc.sensorHistory.length - 24)
        : svc.sensorHistory;
    final settings = context.watch<SettingsService>();
    final monthlyCost = svc.totalWaterThisWeek * settings.waterCostPerLiter;
    final monthlyUsage = svc.monthlyWaterUsage;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _ChartCard(title: "🌿 Soil Moisture", unit: "%",
            color: const Color(0xFF22C55E),
            bgColor: context.isDark ? const Color(0xFF122012) : const Color(0xFFF0FDF4),
            spots: data.asMap().entries.map((e) =>
                FlSpot(e.key.toDouble(), e.value.soilMoisture)).toList()),
        const SizedBox(height: 14),
        _ChartCard(title: "💧 Humidity", unit: "%",
            color: const Color(0xFF0EA5E9),
            bgColor: context.isDark ? const Color(0xFF0D1E2A) : const Color(0xFFF0F9FF),
            spots: data.asMap().entries.map((e) =>
                FlSpot(e.key.toDouble(), e.value.humidity)).toList()),
        const SizedBox(height: 14),
        _ChartCard(title: "🌡️ Temperature", unit: "°C",
            color: const Color(0xFFF97316),
            bgColor: context.isDark ? const Color(0xFF2A1800) : const Color(0xFFFFF7ED),
            spots: data.asMap().entries.map((e) =>
                FlSpot(e.key.toDouble(), e.value.temperature)).toList()),
        const SizedBox(height: 14),
        // Monthly Usage Bar Chart
        _MonthlyUsageChart(monthlyUsage: monthlyUsage),
        const SizedBox(height: 14),
        // Water Cost Card
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: context.cardBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFF59E0B).withOpacity(0.3)),
            boxShadow: [BoxShadow(color: const Color(0xFFF59E0B).withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 4))],
          ),
          child: Row(children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF59E0B).withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.euro_rounded, color: Color(0xFFF59E0B), size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(context.tr('water_cost_week'), style: TextStyle(color: context.textSecondary, fontSize: 12, fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text('\u20ac${monthlyCost.toStringAsFixed(2)}',
                  style: const TextStyle(color: Color(0xFFF59E0B), fontWeight: FontWeight.w900, fontSize: 22)),
              Text('This week · ${svc.totalWaterThisWeek.toStringAsFixed(1)}L used',
                  style: TextStyle(color: context.textSecondary, fontSize: 11)),
            ])),
          ]),
        ),
      ],
    );
  }
}

class _ChartCard extends StatelessWidget {
  final String title, unit;
  final Color color, bgColor;
  final List<FlSpot> spots;
  const _ChartCard({required this.title, required this.unit, required this.color,
      required this.bgColor, required this.spots});

  @override
  Widget build(BuildContext context) {
    final latest = spots.isNotEmpty ? spots.last.y : 0.0;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: bgColor, borderRadius: BorderRadius.circular(22),
        border: Border.all(color: color.withOpacity(0.2), width: 1.5),
        boxShadow: [BoxShadow(color: color.withOpacity(0.08),
            blurRadius: 14, offset: const Offset(0, 4))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14,
              color: context.textPrimary)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
            child: Text("${latest.toStringAsFixed(1)}$unit",
                style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 13)),
          ),
        ]),
        const SizedBox(height: 14),
        SizedBox(
          height: 110,
          child: spots.isEmpty
              ? Center(child: Text("No data yet",
                  style: TextStyle(color: Colors.grey.shade400)))
              : LineChart(LineChartData(
                  minY: 0, maxY: unit == "°C" ? 50 : 100,
                  gridData: FlGridData(show: true, drawVerticalLine: false,
                      horizontalInterval: unit == "°C" ? 12.5 : 25,
                      getDrawingHorizontalLine: (_) =>
                          FlLine(color: color.withOpacity(0.1), strokeWidth: 1)),
                  borderData: FlBorderData(show: false),
                  titlesData: const FlTitlesData(
                    leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  lineBarsData: [LineChartBarData(
                    spots: spots, isCurved: true, color: color, barWidth: 3,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(show: true,
                        color: color.withOpacity(0.12)),
                  )],
                )),
        ),
      ]),
    );
  }
}

class _EventsTab extends StatelessWidget {
  final IrrigationService svc;
  const _EventsTab({required this.svc});

  void _exportCsv() => exportCsv(svc.history);

  @override
  Widget build(BuildContext context) {
    if (svc.history.isEmpty) {
      return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Text("🌵", style: TextStyle(fontSize: 56)),
        const SizedBox(height: 12),
        Text("No sessions yet!", style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.w800, color: context.textPrimary)),
        Text("Start your first irrigation to see history",
            style: TextStyle(color: context.textSecondary, fontSize: 13)),
      ]));
    }

    return Column(
      children: [
        // Export CSV button
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: _exportCsv,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF22C55E).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFF22C55E).withOpacity(0.3)),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.download_rounded, color: Color(0xFF16A34A), size: 16),
                  const SizedBox(width: 6),
                  Text(context.tr('export_csv'),
                      style: const TextStyle(color: Color(0xFF16A34A),
                          fontWeight: FontWeight.w700, fontSize: 13)),
                ]),
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: svc.history.length,
            itemBuilder: (_, i) {
              final e = svc.history[i];
              final mins = e.endTime.difference(e.startTime).inMinutes;
              final isManual = e.trigger == 'manual';
              final color = isManual ? const Color(0xFF0EA5E9) : const Color(0xFF22C55E);
              final emoji = isManual ? "👆" : "📅";

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.cardBg, borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: color.withOpacity(0.15), width: 1.5),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04),
                      blurRadius: 8, offset: const Offset(0, 3))],
                ),
                child: Row(children: [
                  Container(
                    width: 48, height: 48,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(14)),
                    child: Center(child: Text(emoji, style: const TextStyle(fontSize: 22))),
                  ),
                  const SizedBox(width: 14),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(isManual ? "Manual irrigation" : "Scheduled irrigation",
                        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14,
                            color: context.textPrimary)),
                    const SizedBox(height: 2),
                    Text(_formatDate(e.startTime),
                        style: TextStyle(color: context.textSecondary, fontSize: 11)),
                  ])),
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Text("${e.waterUsedLiters.toStringAsFixed(1)} L",
                        style: TextStyle(fontWeight: FontWeight.w900, color: color, fontSize: 15)),
                    Text("$mins min", style: TextStyle(color: context.textSecondary, fontSize: 11)),
                  ]),
                ]),
              );
            },
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime dt) {
    final months = ['Jan','Feb','Mar','Apr','May','Jun',
        'Jul','Aug','Sep','Oct','Nov','Dec'];
    return "${months[dt.month-1]} ${dt.day}, "
        "${dt.hour.toString().padLeft(2,'0')}:${dt.minute.toString().padLeft(2,'0')}";
  }
}

class _MonthlyUsageChart extends StatelessWidget {
  final Map<String, double> monthlyUsage;
  const _MonthlyUsageChart({required this.monthlyUsage});

  @override
  Widget build(BuildContext context) {
    final entries = monthlyUsage.entries.toList();
    final maxVal = entries.fold(0.0, (m, e) => e.value > m ? e.value : m);
    const color = Color(0xFF22C55E);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: context.isDark ? const Color(0xFF122012) : const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: color.withOpacity(0.2), width: 1.5),
        boxShadow: [BoxShadow(color: color.withOpacity(0.08), blurRadius: 14, offset: const Offset(0, 4))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(context.tr('monthly_usage'), style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: context.textPrimary)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
            child: Text('6 months', style: const TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 12)),
          ),
        ]),
        const SizedBox(height: 16),
        SizedBox(
          height: 120,
          child: entries.isEmpty
              ? Center(child: Text('No data yet', style: TextStyle(color: context.textSecondary)))
              : BarChart(BarChartData(
                  maxY: maxVal > 0 ? maxVal * 1.2 : 10,
                  gridData: FlGridData(show: true, drawVerticalLine: false,
                      getDrawingHorizontalLine: (_) => FlLine(color: color.withOpacity(0.1), strokeWidth: 1)),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (v, _) {
                          final idx = v.toInt();
                          if (idx >= 0 && idx < entries.length) {
                            return Text(entries[idx].key,
                                style: TextStyle(color: context.textSecondary, fontSize: 10, fontWeight: FontWeight.w600));
                          }
                          return const SizedBox();
                        },
                      ),
                    ),
                  ),
                  barGroups: entries.asMap().entries.map((e) => BarChartGroupData(
                    x: e.key,
                    barRods: [BarChartRodData(
                      toY: e.value.value,
                      color: color,
                      width: 16,
                      borderRadius: BorderRadius.circular(4),
                      backDrawRodData: BackgroundBarChartRodData(
                        show: true, toY: maxVal > 0 ? maxVal * 1.2 : 10,
                        color: color.withOpacity(0.08),
                      ),
                    )],
                  )).toList(),
                )),
        ),
      ]),
    );
  }
}
