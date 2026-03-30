// Copyright (c) 2026 Mohamed Jlidi. All Rights Reserved.
// Unauthorized use, copying, or distribution is strictly prohibited.
// Contact: mohamedjlidi210@gmail.com

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/irrigation_service.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../l10n/strings.dart';

class ZonesScreen extends StatelessWidget {
  const ZonesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final svc = context.watch<IrrigationService>();

    return Scaffold(
      backgroundColor: context.scaffoldBg,
      appBar: AppBar(
        backgroundColor:
            context.isDark ? const Color(0xFF1A2E1A) : const Color(0xFF14532D),
        foregroundColor: Colors.white,
        title: Text(
          context.tr('zones'),
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF16A34A),
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text(
          context.tr('add_zone'),
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        onPressed: () => _showAddZoneDialog(context, svc),
      ),
      body: svc.zones.isEmpty
          ? _EmptyZones()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: svc.zones.length,
              itemBuilder: (_, i) => _ZoneCard(zone: svc.zones[i]),
            ),
    );
  }

  void _showAddZoneDialog(BuildContext context, IrrigationService svc) {
    final nameCtrl = TextEditingController();
    String selectedEmoji = 'ðŸŒ±';
    final emojis = ['ðŸŒ±', 'ðŸŒ¿', 'ðŸ¥¦', 'ðŸŒ»', 'ðŸŒ·', 'ðŸŒ³', 'ðŸ…', 'ðŸŒµ'];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          backgroundColor: context.cardBg,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(
                context.tr('new_zone'),
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: context.textPrimary),
              ),
              const SizedBox(height: 20),
              // Emoji picker
              Wrap(
                spacing: 8,
                children: emojis
                    .map((e) => GestureDetector(
                          onTap: () => setState(() => selectedEmoji = e),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: selectedEmoji == e
                                  ? const Color(0xFF22C55E).withOpacity(0.15)
                                  : context.isDark
                                      ? Colors.white.withOpacity(0.06)
                                      : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: selectedEmoji == e
                                    ? const Color(0xFF22C55E)
                                    : Colors.transparent,
                              ),
                            ),
                            child: Text(e, style: const TextStyle(fontSize: 22)),
                          ),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameCtrl,
                style: TextStyle(color: context.textPrimary),
                decoration: InputDecoration(
                  labelText: context.tr('zone_name'),
                  labelStyle: TextStyle(color: context.textSecondary),
                  filled: true,
                  fillColor: context.inputFill,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: context.borderColor)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: context.borderColor)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: Color(0xFF22C55E), width: 2)),
                ),
              ),
              const SizedBox(height: 20),
              Row(children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: Text(context.tr('cancel'),
                        style: const TextStyle(color: Color(0xFF6B7280))),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      final name = nameCtrl.text.trim();
                      if (name.isEmpty) return;
                      svc.addZone(IrrigationZone(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        name: name,
                        emoji: selectedEmoji,
                      ));
                      Navigator.pop(ctx);
                    },
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: [Color(0xFF22C55E), Color(0xFF15803D)]),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(context.tr('save'),
                            style: const TextStyle(
                                color: Colors.white, fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ),
                ),
              ]),
            ]),
          ),
        ),
      ),
    );
  }
}

class _EmptyZones extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text('ðŸŒ±', style: TextStyle(fontSize: 60)),
          const SizedBox(height: 16),
          Text('No zones yet!',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: context.textPrimary)),
          const SizedBox(height: 6),
          Text('Add your first irrigation zone below',
              style: TextStyle(color: context.textSecondary, fontSize: 13)),
        ]),
      );
}

class _ZoneCard extends StatelessWidget {
  final IrrigationZone zone;
  const _ZoneCard({required this.zone});

  @override
  Widget build(BuildContext context) {
    final svc = context.read<IrrigationService>();
    final moisture = zone.soilMoisture;
    final moistureColor = moisture < 25
        ? Colors.red
        : moisture < 50
            ? const Color(0xFFF97316)
            : const Color(0xFF22C55E);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.borderColor),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 3))
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          // Emoji
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFF22C55E).withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
                child: Text(zone.emoji, style: const TextStyle(fontSize: 24))),
          ),
          const SizedBox(width: 14),
          // Name and moisture
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(zone.name,
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                      color: context.textPrimary)),
              const SizedBox(height: 4),
              Text('Soil: ${moisture.toStringAsFixed(0)}%',
                  style:
                      TextStyle(color: moistureColor, fontWeight: FontWeight.w600, fontSize: 12)),
            ]),
          ),
          // Edit button
          GestureDetector(
            onTap: () => _showEditDialog(context, svc),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: const Color(0xFF0EA5E9).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.edit_rounded,
                  color: Color(0xFF0EA5E9), size: 18),
            ),
          ),
          const SizedBox(width: 8),
          // Delete button
          GestureDetector(
            onTap: () => _confirmDelete(context, svc),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10)),
              child: Icon(Icons.delete_outline_rounded,
                  color: Colors.red.shade400, size: 18),
            ),
          ),
        ]),
        const SizedBox(height: 12),
        // Moisture bar
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: moisture / 100,
            backgroundColor: moistureColor.withOpacity(0.12),
            valueColor: AlwaysStoppedAnimation(moistureColor),
            minHeight: 8,
          ),
        ),
      ]),
    );
  }

  void _showEditDialog(BuildContext context, IrrigationService svc) {
    final ctrl = TextEditingController(text: zone.name);
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: context.cardBg,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text('Edit Zone',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: context.textPrimary)),
            const SizedBox(height: 20),
            TextField(
              controller: ctrl,
              style: TextStyle(color: context.textPrimary),
              decoration: InputDecoration(
                labelText: context.tr('zone_name'),
                labelStyle: TextStyle(color: context.textSecondary),
                filled: true,
                fillColor: context.inputFill,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: context.borderColor)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Color(0xFF22C55E), width: 2)),
              ),
            ),
            const SizedBox(height: 20),
            Row(children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(context.tr('cancel'),
                      style: const TextStyle(color: Color(0xFF6B7280))),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    svc.updateZoneName(zone.id, ctrl.text.trim());
                    Navigator.pop(ctx);
                  },
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: [Color(0xFF22C55E), Color(0xFF15803D)]),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(context.tr('save'),
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700)),
                    ),
                  ),
                ),
              ),
            ]),
          ]),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, IrrigationService svc) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: context.cardBg,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration:
                  BoxDecoration(color: Colors.red.shade50, shape: BoxShape.circle),
              child: Icon(Icons.delete_rounded,
                  color: Colors.red.shade400, size: 28),
            ),
            const SizedBox(height: 16),
            Text('Delete Zone?',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: context.textPrimary)),
            const SizedBox(height: 8),
            Text('"${zone.name}" will be permanently deleted.',
                textAlign: TextAlign.center,
                style: TextStyle(color: context.textSecondary, fontSize: 12)),
            const SizedBox(height: 24),
            Row(children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(context.tr('cancel'),
                      style: const TextStyle(
                          color: Color(0xFF6B7280), fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(ctx);
                    svc.deleteZone(zone.id);
                  },
                  child: Container(
                    height: 46,
                    decoration: BoxDecoration(
                      color: Colors.red.shade500,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Text(context.tr('delete'),
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w800)),
                    ),
                  ),
                ),
              ),
            ]),
          ]),
        ),
      ),
    );
  }
}

