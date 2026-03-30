// Copyright (c) 2026 Mohamed Jlidi. All Rights Reserved.
// Unauthorized use, copying, or distribution is strictly prohibited.
// Contact: mohamedjlidi210@gmail.com

// stat_card.dart â€” kept for compatibility, not used in redesign
import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;
  const StatCard({super.key, required this.label, required this.value,
      required this.icon, required this.color});
  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

