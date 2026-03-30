// Copyright (c) 2026 Mohamed Jlidi. All Rights Reserved.
// Unauthorized use, copying, or distribution is strictly prohibited.
// Contact: mohamedjlidi210@gmail.com

import 'package:flutter/material.dart';

class SensorCard extends StatelessWidget {
  final String label, emoji, value;
  final double progress;
  final List<Color> gradientColors;
  final Color bgColor;

  const SensorCard({
    super.key,
    required this.label,
    required this.emoji,
    required this.value,
    required this.progress,
    required this.gradientColors,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.8, end: 1.0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.elasticOut,
      builder: (_, v, child) => Transform.scale(scale: v, child: child),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: gradientColors.first.withOpacity(0.2), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: gradientColors.first.withOpacity(0.12),
              blurRadius: 12, offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon circle
            Container(
              width: 38, height: 38,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: gradientColors,
                    begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(
                  color: gradientColors.last.withOpacity(0.35),
                  blurRadius: 8, offset: const Offset(0, 3),
                )],
              ),
              child: Center(child: Text(emoji, style: const TextStyle(fontSize: 18))),
            ),
            const SizedBox(height: 10),
            Text(value,
                style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w900,
                  color: gradientColors.last,
                )),
            Text(label,
                style: TextStyle(fontSize: 10, color: Colors.grey.shade600,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: progress.clamp(0.0, 1.0)),
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOut,
                builder: (_, v, __) => LinearProgressIndicator(
                  value: v,
                  backgroundColor: gradientColors.first.withOpacity(0.15),
                  valueColor: AlwaysStoppedAnimation<Color>(gradientColors.first),
                  minHeight: 5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

