// Copyright (c) 2026 Mohamed Jlidi. All Rights Reserved.
// Unauthorized use, copying, or distribution is strictly prohibited.
// Contact: mohamedjlidi210@gmail.com

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../services/irrigation_service.dart';

class ControlPanel extends StatefulWidget {
  const ControlPanel({super.key});
  @override
  State<ControlPanel> createState() => _ControlPanelState();
}

class _ControlPanelState extends State<ControlPanel>
    with SingleTickerProviderStateMixin {
  int _selectedDuration = 10;
  final List<int> _durations = [5, 10, 15, 20, 30, 45];
  late AnimationController _pulseCtrl;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(vsync: this,
        duration: const Duration(seconds: 2))..repeat(reverse: true);
    _pulse = Tween<double>(begin: 1.0, end: 1.08)
        .animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() { _pulseCtrl.dispose(); super.dispose(); }

  String _fmt(int s) {
    final m = (s ~/ 60).toString().padLeft(2, '0');
    final sec = (s % 60).toString().padLeft(2, '0');
    return '$m:$sec';
  }

  @override
  Widget build(BuildContext context) {
    final svc = context.watch<IrrigationService>();

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06),
              blurRadius: 20, offset: const Offset(0, 6)),
        ],
      ),
      child: Column(children: [
        // â”€â”€ Big animated button â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
        GestureDetector(
          onTap: () {
            HapticFeedback.mediumImpact();
            if (svc.isIrrigating) {
              svc.stopIrrigation();
            } else {
              svc.startIrrigation(durationMinutes: _selectedDuration);
            }
          },
          child: AnimatedBuilder(
            animation: _pulse,
            builder: (_, child) => Transform.scale(
              scale: svc.isIrrigating ? _pulse.value : 1.0,
              child: child,
            ),
            child: Stack(alignment: Alignment.center, children: [
              // Glow ring
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                width: 140, height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: svc.isIrrigating
                      ? const Color(0xFF22C55E).withOpacity(0.15)
                      : Colors.grey.withOpacity(0.08),
                ),
              ),
              // Main button
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                width: 116, height: 116,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: svc.isIrrigating
                      ? const LinearGradient(
                          colors: [Color(0xFF4ADE80), Color(0xFF16A34A)],
                          begin: Alignment.topLeft, end: Alignment.bottomRight,
                        )
                      : LinearGradient(
                          colors: [Colors.grey.shade200, Colors.grey.shade300],
                        ),
                  boxShadow: svc.isIrrigating
                      ? [BoxShadow(color: const Color(0xFF22C55E).withOpacity(0.5),
                            blurRadius: 24, spreadRadius: 4)]
                      : [BoxShadow(color: Colors.grey.withOpacity(0.3),
                            blurRadius: 12, offset: const Offset(0, 4))],
                ),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      svc.isIrrigating ? "ðŸ’§" : "â–¶",
                      key: ValueKey(svc.isIrrigating),
                      style: TextStyle(
                        fontSize: svc.isIrrigating ? 34 : 28,
                        color: svc.isIrrigating ? null : Colors.grey.shade500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    svc.isIrrigating ? "STOP" : "START",
                    style: TextStyle(
                      fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.5,
                      color: svc.isIrrigating ? Colors.white : Colors.grey.shade500,
                    ),
                  ),
                ]),
              ),
            ]),
          ),
        ),

        const SizedBox(height: 16),

        // â”€â”€ Status â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: svc.isIrrigating
              ? Column(key: const ValueKey('on'), children: [
                  Text(
                    _fmt(svc.remainingSeconds),
                    style: const TextStyle(
                      fontSize: 36, fontWeight: FontWeight.w900,
                      color: Color(0xFF16A34A),
                      fontFeatures: [FontFeature.tabularFigures()],
                    ),
                  ),
                  Text("remaining", style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                  const SizedBox(height: 14),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: (svc.remainingSeconds / (_selectedDuration * 60)).clamp(0, 1),
                      backgroundColor: Colors.grey.shade100,
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF22C55E)),
                      minHeight: 10,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text("ðŸŒ± Watering your garden...",
                        style: TextStyle(color: Color(0xFF16A34A),
                            fontSize: 12, fontWeight: FontWeight.w600)),
                  ),
                ])
              : Column(key: const ValueKey('off'), children: [
                  Text("Choose duration",
                      style: TextStyle(color: Colors.grey.shade600,
                          fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  Wrap(spacing: 8, children: _durations.map((d) {
                    final sel = d == _selectedDuration;
                    return GestureDetector(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        setState(() => _selectedDuration = d);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          gradient: sel
                              ? const LinearGradient(
                                  colors: [Color(0xFF22C55E), Color(0xFF16A34A)])
                              : null,
                          color: sel ? null : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: sel ? [BoxShadow(
                              color: const Color(0xFF22C55E).withOpacity(0.35),
                              blurRadius: 8, offset: const Offset(0, 3))] : [],
                        ),
                        child: Text("${d}m",
                            style: TextStyle(
                              color: sel ? Colors.white : Colors.grey.shade600,
                              fontWeight: FontWeight.w700, fontSize: 13,
                            )),
                      ),
                    );
                  }).toList()),
                ]),
        ),
      ]),
    );
  }
}

