// Copyright (c) 2026 Mohamed Jlidi. All Rights Reserved.
// Unauthorized use, copying, or distribution is strictly prohibited.
// Contact: mohamedjlidi210@gmail.com

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../services/irrigation_service.dart';
import '../models/models.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final svc = context.watch<IrrigationService>();

    return Scaffold(
      backgroundColor: const Color(0xFFF0FDF4),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 120,
            backgroundColor: const Color(0xFF14532D),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF052E16), Color(0xFF15803D)],
                    begin: Alignment.topLeft, end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(20, 52, 20, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text("ðŸ“… Schedule",
                          style: TextStyle(color: Colors.white, fontSize: 22,
                              fontWeight: FontWeight.w900)),
                      Text("${svc.schedules.where((s) => s.isActive).length} active plans",
                          style: const TextStyle(color: Color(0xFF86EFAC), fontSize: 12)),
                    ]),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text("${svc.schedules.length} total",
                          style: const TextStyle(color: Colors.white, fontSize: 11,
                              fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: svc.schedules.isEmpty
                ? SliverFillRemaining(child: _EmptyState())
                : SliverList(delegate: SliverChildBuilderDelegate(
                    (ctx, i) => _ScheduleCard(schedule: svc.schedules[i]),
                    childCount: svc.schedules.length,
                  )),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF16A34A),
        elevation: 6,
        icon: const Text("âž•", style: TextStyle(fontSize: 16)),
        label: const Text("Add Schedule",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        onPressed: () => _showAddDialog(context),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final svc = context.read<IrrigationService>();
    final nameCtrl = TextEditingController(text: 'New Cycle');
    int hour = 7, minute = 0, duration = 15;
    final days = List<bool>.filled(7, false);
    days[0] = true;
    final dayNames = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setState) => Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: EdgeInsets.fromLTRB(
              24, 20, 24, MediaQuery.of(context).viewInsets.bottom + 24),
          child: SingleChildScrollView(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Center(child: Container(width: 40, height: 4,
                  decoration: BoxDecoration(color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 20),
              const Text("New Schedule âœ¨",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900,
                      color: Color(0xFF052E16))),
              const SizedBox(height: 20),

              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  labelText: "Schedule Name",
                  prefixIcon: const Icon(Icons.label_rounded, color: Color(0xFF16A34A)),
                  filled: true, fillColor: const Color(0xFFF0FDF4),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 16),

              // Time
              const Text("â° Time", style: TextStyle(fontWeight: FontWeight.w800,
                  color: Color(0xFF052E16))),
              const SizedBox(height: 8),
              Row(children: [
                Expanded(child: DropdownButtonFormField<int>(
                  value: hour,
                  decoration: InputDecoration(
                    labelText: "Hour",
                    filled: true, fillColor: const Color(0xFFF0FDF4),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none),
                  ),
                  items: List.generate(24, (i) => DropdownMenuItem(
                      value: i, child: Text(i.toString().padLeft(2, '0')))),
                  onChanged: (v) => setState(() => hour = v!),
                )),
                const SizedBox(width: 12),
                Expanded(child: DropdownButtonFormField<int>(
                  value: minute,
                  decoration: InputDecoration(
                    labelText: "Min",
                    filled: true, fillColor: const Color(0xFFF0FDF4),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none),
                  ),
                  items: [0, 15, 30, 45].map((m) => DropdownMenuItem(
                      value: m, child: Text(m.toString().padLeft(2, '0')))).toList(),
                  onChanged: (v) => setState(() => minute = v!),
                )),
              ]),
              const SizedBox(height: 16),

              // Duration
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text("â± Duration", style: TextStyle(fontWeight: FontWeight.w800,
                    color: Color(0xFF052E16))),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(8)),
                  child: Text("$duration min", style: const TextStyle(
                      color: Color(0xFF16A34A), fontWeight: FontWeight.w800, fontSize: 13)),
                ),
              ]),
              Slider(
                value: duration.toDouble(), min: 5, max: 60, divisions: 11,
                activeColor: const Color(0xFF16A34A),
                label: "$duration min",
                onChanged: (v) => setState(() => duration = v.round()),
              ),

              // Days
              const Text("ðŸ“† Days", style: TextStyle(fontWeight: FontWeight.w800,
                  color: Color(0xFF052E16))),
              const SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: dayNames.asMap().entries.map((e) {
                    final i = e.key;
                    return GestureDetector(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        setState(() => days[i] = !days[i]);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 40, height: 40,
                        decoration: BoxDecoration(
                          gradient: days[i] ? const LinearGradient(
                              colors: [Color(0xFF4ADE80), Color(0xFF16A34A)]) : null,
                          color: days[i] ? null : Colors.grey.shade100,
                          shape: BoxShape.circle,
                          boxShadow: days[i] ? [BoxShadow(
                              color: const Color(0xFF22C55E).withOpacity(0.4),
                              blurRadius: 8)] : [],
                        ),
                        child: Center(child: Text(e.value,
                            style: TextStyle(
                              color: days[i] ? Colors.white : Colors.grey.shade500,
                              fontWeight: FontWeight.w800, fontSize: 13,
                            ))),
                      ),
                    );
                  }).toList()),

              const SizedBox(height: 24),
              Row(children: [
                Expanded(child: GestureDetector(
                  onTap: () => Navigator.pop(ctx),
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100, borderRadius: BorderRadius.circular(14)),
                    child: const Center(child: Text("Cancel",
                        style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF6B7280)))),
                  ),
                )),
                const SizedBox(width: 12),
                Expanded(flex: 2, child: GestureDetector(
                  onTap: () {
                    svc.addSchedule(IrrigationSchedule(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: nameCtrl.text.isEmpty ? 'New Cycle' : nameCtrl.text,
                      time: TimeOfDay(hour: hour, minute: minute),
                      days: days, durationMinutes: duration,
                    ));
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Row(children: [
                          Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
                          SizedBox(width: 10),
                          Text("Schedule saved successfully!"),
                        ]),
                        backgroundColor: const Color(0xFF16A34A),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    );
                  },
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: [Color(0xFF22C55E), Color(0xFF15803D)]),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [BoxShadow(
                          color: const Color(0xFF22C55E).withOpacity(0.4),
                          blurRadius: 12, offset: const Offset(0, 4))],
                    ),
                    child: const Center(child: Text("Save Schedule ðŸŽ‰",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800))),
                  ),
                )),
              ]),
            ]),
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Text("ðŸŒµ", style: TextStyle(fontSize: 64)),
      const SizedBox(height: 16),
      const Text("No schedules yet!", style: TextStyle(
          fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF052E16))),
      const SizedBox(height: 6),
      Text("Add your first irrigation plan â†“",
          style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
    ]),
  );
}

class _ScheduleCard extends StatelessWidget {
  final IrrigationSchedule schedule;
  const _ScheduleCard({required this.schedule});

  @override
  Widget build(BuildContext context) {
    final svc = context.read<IrrigationService>();
    final dayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final activeDays = schedule.days.asMap().entries
        .where((e) => e.value).map((e) => dayLabels[e.key]).join(' Â· ');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: schedule.isActive
              ? const Color(0xFF86EFAC) : Colors.grey.shade200, width: 1.5),
        boxShadow: [BoxShadow(
          color: schedule.isActive
              ? const Color(0xFF22C55E).withOpacity(0.08) : Colors.black.withOpacity(0.04),
          blurRadius: 12, offset: const Offset(0, 4),
        )],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(children: [
          // Icon
          Container(
            width: 52, height: 52,
            decoration: BoxDecoration(
              gradient: schedule.isActive
                  ? const LinearGradient(
                      colors: [Color(0xFF4ADE80), Color(0xFF16A34A)],
                      begin: Alignment.topLeft, end: Alignment.bottomRight)
                  : LinearGradient(colors: [Colors.grey.shade200, Colors.grey.shade300]),
              borderRadius: BorderRadius.circular(16),
              boxShadow: schedule.isActive ? [BoxShadow(
                color: const Color(0xFF22C55E).withOpacity(0.3), blurRadius: 8)] : [],
            ),
            child: const Center(child: Text("â°", style: TextStyle(fontSize: 24))),
          ),
          const SizedBox(width: 14),

          // Info
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(schedule.name, style: const TextStyle(
                fontWeight: FontWeight.w800, fontSize: 15, color: Color(0xFF052E16))),
            const SizedBox(height: 2),
            Text("${schedule.time.fmt()} Â· ${schedule.durationMinutes} min",
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12,
                    fontWeight: FontWeight.w600)),
            if (activeDays.isNotEmpty) ...[
              const SizedBox(height: 3),
              Text(activeDays, style: TextStyle(color: Colors.grey.shade400, fontSize: 11)),
            ],
          ])),

          // Controls
          Column(children: [
            Switch(
              value: schedule.isActive,
              activeColor: Colors.white,
              activeTrackColor: const Color(0xFF22C55E),
              onChanged: (_) {
                HapticFeedback.selectionClick();
                svc.toggleSchedule(schedule.id);
              },
            ),
            GestureDetector(
              onTap: () {
                HapticFeedback.heavyImpact();
                showDialog(
                  context: context,
                  builder: (ctx) => Dialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24)),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              shape: BoxShape.circle),
                          child: Icon(Icons.delete_rounded,
                              color: Colors.red.shade400, size: 28),
                        ),
                        const SizedBox(height: 16),
                        const Text("Delete Schedule?", style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w900,
                            color: Color(0xFF052E16))),
                        const SizedBox(height: 8),
                        Text("\"${schedule.name}\" will be permanently deleted.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.grey.shade500, fontSize: 12)),
                        const SizedBox(height: 24),
                        Row(children: [
                          Expanded(child: TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text("Cancel", style: TextStyle(
                                color: Color(0xFF6B7280),
                                fontWeight: FontWeight.w700)),
                          )),
                          const SizedBox(width: 12),
                          Expanded(child: GestureDetector(
                            onTap: () {
                              Navigator.pop(ctx);
                              svc.deleteSchedule(schedule.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Row(children: [
                                    Icon(Icons.delete_rounded,
                                        color: Colors.white, size: 18),
                                    SizedBox(width: 10),
                                    Text("Schedule deleted."),
                                  ]),
                                  backgroundColor: Colors.red.shade500,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                              );
                            },
                            child: Container(
                              height: 46,
                              decoration: BoxDecoration(
                                color: Colors.red.shade500,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Center(child: Text("Delete",
                                  style: TextStyle(color: Colors.white,
                                      fontWeight: FontWeight.w800))),
                            ),
                          )),
                        ]),
                      ]),
                    ),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.red.shade50, borderRadius: BorderRadius.circular(8)),
                child: Icon(Icons.delete_outline_rounded,
                    color: Colors.red.shade400, size: 18),
              ),
            ),
          ]),
        ]),
      ),
    );
  }
}

