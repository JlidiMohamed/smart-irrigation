// stat_card.dart — kept for compatibility, not used in redesign
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
