// Copyright (c) 2026 Mohamed Jlidi. All Rights Reserved.
// Unauthorized use, copying, or distribution is strictly prohibited.
// Contact: mohamedjlidi210@gmail.com

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/settings_service.dart';
import '../services/notification_service.dart';
import '../l10n/strings.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsService>();

    return Scaffold(
      backgroundColor: context.scaffoldBg,
      appBar: AppBar(
        backgroundColor: context.isDark
            ? const Color(0xFF1A2E1A)
            : const Color(0xFF14532D),
        foregroundColor: Colors.white,
        title: Text(
          context.tr('settings'),
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.w800),
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // â”€â”€ Appearance â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
          _SectionTitle('Apparence', context),
          const SizedBox(height: 10),

          _SettingsCard(
            child: Column(
              children: [
                // Dark Mode toggle
                Row(
                  children: [
                    _IconBox(
                      icon: Icons.dark_mode_rounded,
                      color: const Color(0xFF8B5CF6),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        context.tr('dark_mode'),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: context.textPrimary,
                        ),
                      ),
                    ),
                    Switch(
                      value: settings.isDarkMode,
                      onChanged: (_) => settings.toggleDarkMode(),
                      activeColor: const Color(0xFF22C55E),
                    ),
                  ],
                ),
                Divider(height: 24, color: context.borderColor),
                // Language selector
                Row(
                  children: [
                    _IconBox(
                      icon: Icons.language_rounded,
                      color: const Color(0xFF0EA5E9),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        context.tr('language'),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: context.textPrimary,
                        ),
                      ),
                    ),
                    _LangButton(
                      label: 'EN',
                      selected: settings.language == 'en',
                      onTap: () => settings.setLanguage('en'),
                    ),
                    const SizedBox(width: 6),
                    _LangButton(
                      label: 'FR',
                      selected: settings.language == 'fr',
                      onTap: () => settings.setLanguage('fr'),
                    ),
                    const SizedBox(width: 6),
                    _LangButton(
                      label: '\u0639\u0631',
                      selected: settings.language == 'ar',
                      onTap: () => settings.setLanguage('ar'),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 22),

          // â”€â”€ Smart Irrigation â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
          _SectionTitle('Smart Irrigation', context),
          const SizedBox(height: 10),

          _SettingsCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Auto-irrigation toggle
                Row(
                  children: [
                    _IconBox(
                      icon: Icons.auto_awesome_rounded,
                      color: const Color(0xFF22C55E),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.tr('auto_irrigation'),
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: context.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Automatically water when soil drops below threshold',
                            style: TextStyle(
                              fontSize: 11,
                              color: context.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: settings.autoIrrigationEnabled,
                      onChanged: (v) => settings.setAutoIrrigation(v),
                      activeColor: const Color(0xFF22C55E),
                    ),
                  ],
                ),

                // Threshold slider (visible only when auto is ON)
                if (settings.autoIrrigationEnabled) ...[
                  Divider(height: 24, color: context.borderColor),
                  Row(
                    children: [
                      _IconBox(
                        icon: Icons.water_drop_outlined,
                        color: const Color(0xFF0EA5E9),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  context.tr('auto_threshold'),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                    color: context.textPrimary,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0EA5E9)
                                        .withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '${settings.autoIrrigationThreshold.toStringAsFixed(0)}%',
                                    style: const TextStyle(
                                      color: Color(0xFF0EA5E9),
                                      fontWeight: FontWeight.w800,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Slider(
                              value: settings.autoIrrigationThreshold,
                              min: 10,
                              max: 60,
                              divisions: 50,
                              activeColor: const Color(0xFF0EA5E9),
                              onChanged: (v) => settings.setThreshold(v),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],

                Divider(height: 24, color: context.borderColor),

                // Plant profile
                Row(
                  children: [
                    _IconBox(
                      icon: Icons.eco_rounded,
                      color: const Color(0xFF16A34A),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.tr('plant_profile'),
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: context.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: const [
                              _PlantChipData(
                                  emoji: 'ðŸŒ±',
                                  label: 'General',
                                  value: 'general'),
                              _PlantChipData(
                                  emoji: 'ðŸ…',
                                  label: 'Tomato',
                                  value: 'tomato'),
                              _PlantChipData(
                                  emoji: 'ðŸŒ¹',
                                  label: 'Rose',
                                  value: 'rose'),
                              _PlantChipData(
                                  emoji: 'ðŸŒµ',
                                  label: 'Cactus',
                                  value: 'cactus'),
                              _PlantChipData(
                                  emoji: 'ðŸŒ¿',
                                  label: 'Lawn',
                                  value: 'lawn'),
                              _PlantChipData(
                                  emoji: 'ðŸ¥¦',
                                  label: 'Vegetables',
                                  value: 'vegetables'),
                            ].map((chip) {
                              final selected =
                                  settings.plantProfile == chip.value;
                              return GestureDetector(
                                onTap: () =>
                                    settings.setPlantProfile(chip.value),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 7),
                                  decoration: BoxDecoration(
                                    color: selected
                                        ? const Color(0xFF22C55E)
                                            .withOpacity(0.15)
                                        : context.isDark
                                            ? Colors.white
                                                .withOpacity(0.06)
                                            : Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: selected
                                          ? const Color(0xFF22C55E)
                                          : context.borderColor,
                                      width: selected ? 1.5 : 1,
                                    ),
                                  ),
                                  child: Text(
                                    '${chip.emoji} ${chip.label}',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: selected
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                      color: selected
                                          ? const Color(0xFF16A34A)
                                          : context.textPrimary,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 22),

          // â”€â”€ Water Management â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
          _SectionTitle('Water Management', context),
          const SizedBox(height: 10),

          _SettingsCard(
            child: Column(
              children: [
                // Weekly water goal slider
                Row(
                  children: [
                    _IconBox(
                      icon: Icons.local_drink_rounded,
                      color: const Color(0xFF22C55E),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                context.tr('water_goal'),
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: context.textPrimary,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF22C55E)
                                      .withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '${settings.weeklyWaterGoal.toStringAsFixed(0)}L',
                                  style: const TextStyle(
                                    color: Color(0xFF22C55E),
                                    fontWeight: FontWeight.w800,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Slider(
                            value: settings.weeklyWaterGoal,
                            min: 20,
                            max: 300,
                            divisions: 56,
                            activeColor: const Color(0xFF22C55E),
                            onChanged: (v) => settings.setWeeklyGoal(v),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Divider(height: 24, color: context.borderColor),
                // Water cost input
                Row(
                  children: [
                    _IconBox(
                      icon: Icons.euro_rounded,
                      color: const Color(0xFFF59E0B),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.tr('water_cost'),
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: context.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 10),
                          _WaterCostField(
                            initialValue: settings.waterCostPerLiter,
                            onChanged: (v) => settings.setWaterCost(v),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),

          // â”€â”€ Units â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
          _SectionTitle('Units', context),
          const SizedBox(height: 10),
          _SettingsCard(
            child: Column(
              children: [
                Row(
                  children: [
                    _IconBox(icon: Icons.thermostat_rounded, color: const Color(0xFFF97316)),
                    const SizedBox(width: 14),
                    Expanded(child: Text(context.tr('temp_unit'),
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: context.textPrimary))),
                    _TogglePair(
                      first: 'Â°C', second: 'Â°F',
                      selectedFirst: settings.tempUnit == 'C',
                      onFirst: () => settings.setTempUnit('C'),
                      onSecond: () => settings.setTempUnit('F'),
                    ),
                  ],
                ),
                Divider(height: 24, color: context.borderColor),
                Row(
                  children: [
                    _IconBox(icon: Icons.water_drop_rounded, color: const Color(0xFF0EA5E9)),
                    const SizedBox(width: 14),
                    Expanded(child: Text(context.tr('volume_unit'),
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: context.textPrimary))),
                    _TogglePair(
                      first: 'L', second: 'gal',
                      selectedFirst: settings.volumeUnit == 'L',
                      onFirst: () => settings.setVolumeUnit('L'),
                      onSecond: () => settings.setVolumeUnit('gal'),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 22),

          // â”€â”€ Notifications â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
          _SectionTitle('Notifications', context),
          const SizedBox(height: 10),
          _NotificationCard(settings: settings),

          const SizedBox(height: 22),

          // â”€â”€ About â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
          _SectionTitle('About', context),
          const SizedBox(height: 10),
          _SettingsCard(
            child: Column(children: [
              Row(children: [
                _IconBox(icon: Icons.info_outline_rounded, color: const Color(0xFF6366F1)),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Smart Irrigation', style: TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 15, color: context.textPrimary)),
                  Text('Version 1.0.0', style: TextStyle(
                      fontSize: 11, color: context.textSecondary)),
                ])),
              ]),
              Divider(height: 24, color: context.borderColor),
              Row(children: [
                _IconBox(icon: Icons.code_rounded, color: const Color(0xFF0EA5E9)),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Designed & Developed by', style: TextStyle(
                      fontSize: 11, color: context.textSecondary)),
                  const SizedBox(height: 2),
                  Text('Mohamed Jlidi', style: TextStyle(
                      fontWeight: FontWeight.w800, fontSize: 15,
                      color: context.textPrimary, letterSpacing: 0.3)),
                ])),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [Color(0xFF22C55E), Color(0xFF0EA5E9)]),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text('Â© 2025', style: TextStyle(
                      color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                ),
              ]),
            ]),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _TogglePair extends StatelessWidget {
  final String first, second;
  final bool selectedFirst;
  final VoidCallback onFirst, onSecond;
  const _TogglePair({required this.first, required this.second,
      required this.selectedFirst, required this.onFirst, required this.onSecond});

  @override
  Widget build(BuildContext context) => Row(
    children: [
      GestureDetector(
        onTap: onFirst,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: selectedFirst ? const Color(0xFF22C55E).withOpacity(0.15) : Colors.transparent,
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(10)),
            border: Border.all(color: selectedFirst ? const Color(0xFF22C55E) : context.borderColor),
          ),
          child: Text(first, style: TextStyle(
            fontWeight: selectedFirst ? FontWeight.w700 : FontWeight.w500,
            color: selectedFirst ? const Color(0xFF16A34A) : context.textSecondary,
            fontSize: 13,
          )),
        ),
      ),
      GestureDetector(
        onTap: onSecond,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: !selectedFirst ? const Color(0xFF22C55E).withOpacity(0.15) : Colors.transparent,
            borderRadius: const BorderRadius.horizontal(right: Radius.circular(10)),
            border: Border.all(color: !selectedFirst ? const Color(0xFF22C55E) : context.borderColor),
          ),
          child: Text(second, style: TextStyle(
            fontWeight: !selectedFirst ? FontWeight.w700 : FontWeight.w500,
            color: !selectedFirst ? const Color(0xFF16A34A) : context.textSecondary,
            fontSize: 13,
          )),
        ),
      ),
    ],
  );
}

// â”€â”€ Notification card with real browser permission status â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class _NotificationCard extends StatefulWidget {
  final SettingsService settings;
  const _NotificationCard({required this.settings});
  @override
  State<_NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<_NotificationCard> {
  bool _requesting = false;

  Future<void> _handleToggle() async {
    final current = widget.settings.notificationsEnabled;
    if (!current) {
      // Turning ON â†’ ask browser permission
      setState(() => _requesting = true);
      final granted = await NotificationService.requestPermission();
      setState(() => _requesting = false);
      if (!granted && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Autorisez les notifications dans les paramÃ¨tres du navigateur.'),
          backgroundColor: Colors.orange.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ));
        return; // don't enable in settings if permission denied
      }
    }
    widget.settings.toggleNotifications();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final status = NotificationService.permissionStatus;
    final isGranted = status == 'granted';
    final isDenied  = status == 'denied';

    return _SettingsCard(
      child: Column(
        children: [
          Row(
            children: [
              _IconBox(icon: Icons.notifications_rounded, color: const Color(0xFFF59E0B)),
              const SizedBox(width: 14),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Notifications push',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15,
                          color: context.textPrimary)),
                  const SizedBox(height: 2),
                  Text('Alertes sol sec, irrigation, pluie prÃ©vue',
                      style: TextStyle(fontSize: 11, color: context.textSecondary)),
                ],
              )),
              _requesting
                  ? const SizedBox(width: 24, height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2,
                          color: Color(0xFF22C55E)))
                  : Switch(
                      value: widget.settings.notificationsEnabled,
                      onChanged: (_) => _handleToggle(),
                      activeColor: const Color(0xFF22C55E),
                    ),
            ],
          ),
          // â”€â”€ Permission status badge â”€â”€
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: NotificationService.statusColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: NotificationService.statusColor.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(
                  isGranted ? Icons.check_circle_rounded
                      : isDenied ? Icons.block_rounded
                      : Icons.help_outline_rounded,
                  color: NotificationService.statusColor,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(child: Text(
                  isGranted
                      ? 'Permission accordÃ©e â€” les notifications sont actives'
                      : isDenied
                          ? 'BloquÃ©es par le navigateur â€” cliquez sur ðŸ”’ dans la barre d\'adresse pour autoriser'
                          : 'Activez le toggle pour demander la permission',
                  style: TextStyle(fontSize: 11, color: NotificationService.statusColor,
                      fontWeight: FontWeight.w600),
                )),
              ],
            ),
          ),
          // â”€â”€ Alert types â”€â”€
          if (isGranted) ...[
            const SizedBox(height: 10),
            _AlertRow(icon: 'âš ï¸', label: 'Sol trop sec (< 20%)'),
            _AlertRow(icon: 'ðŸ’§', label: 'Irrigation automatique dÃ©marrÃ©e'),
            _AlertRow(icon: 'âœ…', label: 'Irrigation terminÃ©e'),
            _AlertRow(icon: 'ðŸŒ§', label: 'Pluie prÃ©vue aujourd\'hui'),
          ],
        ],
      ),
    );
  }
}

class _AlertRow extends StatelessWidget {
  final String icon, label;
  const _AlertRow({required this.icon, required this.label});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 4),
    child: Row(children: [
      Text(icon, style: const TextStyle(fontSize: 13)),
      const SizedBox(width: 8),
      Text(label, style: TextStyle(fontSize: 12, color: context.textSecondary)),
    ]),
  );
}

class _PlantChipData {
  final String emoji;
  final String label;
  final String value;
  const _PlantChipData(
      {required this.emoji, required this.label, required this.value});
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final BuildContext parentCtx;
  const _SectionTitle(this.title, this.parentCtx);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 4),
        child: Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: context.textSecondary,
            letterSpacing: 1.2,
          ),
        ),
      );
}

class _SettingsCard extends StatelessWidget {
  final Widget child;
  const _SettingsCard({required this.child});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.cardBg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: context.borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(context.isDark ? 0.2 : 0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: child,
      );
}

class _IconBox extends StatelessWidget {
  final IconData icon;
  final Color color;
  const _IconBox({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 18),
      );
}

class _LangButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _LangButton(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: selected
                ? const Color(0xFF22C55E).withOpacity(0.15)
                : context.isDark
                    ? Colors.white.withOpacity(0.06)
                    : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected
                  ? const Color(0xFF22C55E)
                  : context.borderColor,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight:
                  selected ? FontWeight.w700 : FontWeight.w500,
              color: selected
                  ? const Color(0xFF16A34A)
                  : context.textPrimary,
            ),
          ),
        ),
      );
}

class _WaterCostField extends StatefulWidget {
  final double initialValue;
  final ValueChanged<double> onChanged;
  const _WaterCostField(
      {required this.initialValue, required this.onChanged});

  @override
  State<_WaterCostField> createState() => _WaterCostFieldState();
}

class _WaterCostFieldState extends State<_WaterCostField> {
  late TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(
        text: widget.initialValue.toStringAsFixed(4));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => TextField(
        controller: _ctrl,
        keyboardType:
            const TextInputType.numberWithOptions(decimal: true),
        style: TextStyle(color: context.textPrimary),
        decoration: InputDecoration(
          prefixText: 'â‚¬ ',
          prefixStyle: TextStyle(
              color: context.textSecondary, fontWeight: FontWeight.w600),
          filled: true,
          fillColor: context.inputFill,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: context.borderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: context.borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
                color: Color(0xFF22C55E), width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
              horizontal: 14, vertical: 12),
        ),
        onSubmitted: (v) {
          final parsed = double.tryParse(v);
          if (parsed != null && parsed >= 0) {
            widget.onChanged(parsed);
          }
        },
        onEditingComplete: () {
          final parsed = double.tryParse(_ctrl.text);
          if (parsed != null && parsed >= 0) {
            widget.onChanged(parsed);
          }
        },
      );
}

