// Copyright (c) 2026 Mohamed Jlidi. All Rights Reserved.
// Unauthorized use, copying, or distribution is strictly prohibited.
// Contact: mohamedjlidi210@gmail.com

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/irrigation_service.dart';
import '../theme/app_theme.dart';
import '../l10n/strings.dart';
import 'settings_screen.dart';
import 'zones_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    final svc  = context.watch<IrrigationService>();
    final user = auth.user!;
    final initials = user.name.trim().isNotEmpty
        ? user.name.trim().split(' ').map((w) => w[0]).take(2).join().toUpperCase()
        : '?';

    return Scaffold(
      backgroundColor: context.scaffoldBg,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: const Color(0xFF14532D),
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF052E16), Color(0xFF16A34A)],
                    begin: Alignment.topLeft, end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 16),
                      Container(
                        width: 84, height: 84,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF4ADE80), Color(0xFF16A34A)],
                            begin: Alignment.topLeft, end: Alignment.bottomRight,
                          ),
                          boxShadow: [BoxShadow(
                            color: const Color(0xFF22C55E).withOpacity(0.5),
                            blurRadius: 20, spreadRadius: 2)],
                        ),
                        child: Center(child: Text(initials,
                            style: const TextStyle(color: Colors.white,
                                fontSize: 30, fontWeight: FontWeight.w900))),
                      ),
                      const SizedBox(height: 12),
                      Text(user.name, style: const TextStyle(
                          color: Colors.white, fontSize: 20,
                          fontWeight: FontWeight.w800)),
                      const SizedBox(height: 4),
                      Text(user.email, style: TextStyle(
                          color: Colors.white.withOpacity(0.6), fontSize: 13)),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                // â”€â”€ Stats â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                Row(children: [
                  _StatBox(emoji: "ðŸ’§",
                      value: "${svc.totalWaterThisWeek.toStringAsFixed(1)}L",
                      label: "This week"),
                  const SizedBox(width: 10),
                  _StatBox(emoji: "ðŸ”„",
                      value: "${svc.irrigationCountThisWeek}",
                      label: "Sessions"),
                  const SizedBox(width: 10),
                  _StatBox(emoji: "ðŸ“…",
                      value: "${svc.schedules.where((s) => s.isActive).length}",
                      label: "Active plans"),
                ]),
                const SizedBox(height: 20),

                // â”€â”€ Account section â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                _SectionHeader("Account"),
                const SizedBox(height: 10),
                _ActionTile(
                  icon: Icons.badge_rounded,
                  label: "Edit Display Name",
                  onTap: () => _showEditName(context, auth, user.name),
                ),
                _ActionTile(
                  icon: Icons.lock_reset_rounded,
                  label: "Change Password",
                  onTap: () => _showChangePassword(context, auth),
                ),
                _ActionTile(
                  icon: Icons.settings_rounded,
                  label: context.tr('settings'),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
                ),
                _ActionTile(
                  icon: Icons.map_rounded,
                  iconColor: const Color(0xFF0EA5E9),
                  label: context.tr('zones'),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ZonesScreen())),
                ),
                const SizedBox(height: 20),

                // â”€â”€ Support section â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                _SectionHeader("App"),
                const SizedBox(height: 10),
                _ActionTile(
                  icon: Icons.info_outline_rounded,
                  label: "App Version",
                  trailing: const Text("1.0.0",
                      style: TextStyle(color: Color(0xFF6B7280), fontSize: 13)),
                  onTap: null,
                ),
                _ActionTile(
                  icon: Icons.water_drop_rounded,
                  iconColor: const Color(0xFF0EA5E9),
                  label: "Soil Moisture Status",
                  trailing: _MoistureChip(svc.soilMoisture),
                  onTap: null,
                ),
                const SizedBox(height: 20),

                // â”€â”€ Logout â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                GestureDetector(
                  onTap: () => _confirmLogout(context, auth),
                  child: Container(
                    width: double.infinity,
                    height: 54,
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(Icons.logout_rounded, color: Colors.red.shade500, size: 20),
                      const SizedBox(width: 10),
                      Text("Sign Out", style: TextStyle(
                          color: Colors.red.shade500,
                          fontWeight: FontWeight.w800, fontSize: 15)),
                    ]),
                  ),
                ),
                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditName(BuildContext context, AuthService auth, String current) {
    final ctrl = TextEditingController(text: current);
    String? error;
    bool saving = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Text("Edit Name", style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w900,
                  color: Color(0xFF052E16))),
              const SizedBox(height: 20),
              TextField(
                controller: ctrl,
                decoration: InputDecoration(
                  labelText: "Display Name",
                  prefixIcon: const Icon(Icons.badge_rounded,
                      color: Color(0xFF16A34A)),
                  filled: true, fillColor: const Color(0xFFF9FAFB),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade200)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                          color: Color(0xFF22C55E), width: 2)),
                ),
              ),
              if (error != null) ...[
                const SizedBox(height: 8),
                Text(error!, style: TextStyle(
                    color: Colors.red.shade600, fontSize: 12)),
              ],
              const SizedBox(height: 20),
              Row(children: [
                Expanded(child: TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text("Cancel",
                      style: TextStyle(color: Color(0xFF6B7280))),
                )),
                const SizedBox(width: 8),
                Expanded(child: GestureDetector(
                  onTap: saving ? null : () async {
                    setState(() { saving = true; error = null; });
                    final err = await auth.updateDisplayName(ctrl.text.trim());
                    if (!ctx.mounted) return;
                    if (err != null) {
                      setState(() { error = err; saving = false; });
                    } else {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Row(children: [
                            Icon(Icons.check_circle_rounded,
                                color: Colors.white, size: 18),
                            SizedBox(width: 10),
                            Text("Name updated!"),
                          ]),
                          backgroundColor: const Color(0xFF16A34A),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      );
                    }
                  },
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: [Color(0xFF22C55E), Color(0xFF15803D)]),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(child: saving
                        ? const SizedBox(width: 18, height: 18,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2))
                        : const Text("Save", style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700))),
                  ),
                )),
              ]),
            ]),
          ),
        ),
      ),
    );
  }

  void _showChangePassword(BuildContext context, AuthService auth) {
    final currentCtrl = TextEditingController();
    final newCtrl     = TextEditingController();
    final confirmCtrl = TextEditingController();
    bool obscure1 = true, obscure2 = true, obscure3 = true;
    String? error;
    bool saving = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Text("Change Password", style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w900,
                  color: Color(0xFF052E16))),
              const SizedBox(height: 20),
              _PassField(ctrl: currentCtrl, label: "Current Password",
                  obscure: obscure1,
                  onToggle: () => setState(() => obscure1 = !obscure1)),
              const SizedBox(height: 12),
              _PassField(ctrl: newCtrl, label: "New Password",
                  obscure: obscure2,
                  onToggle: () => setState(() => obscure2 = !obscure2)),
              const SizedBox(height: 12),
              _PassField(ctrl: confirmCtrl, label: "Confirm New Password",
                  obscure: obscure3,
                  onToggle: () => setState(() => obscure3 = !obscure3)),
              if (error != null) ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Text(error!, style: TextStyle(
                      color: Colors.red.shade600, fontSize: 12)),
                ),
              ],
              const SizedBox(height: 20),
              Row(children: [
                Expanded(child: TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text("Cancel",
                      style: TextStyle(color: Color(0xFF6B7280))),
                )),
                const SizedBox(width: 8),
                Expanded(child: GestureDetector(
                  onTap: saving ? null : () async {
                    if (newCtrl.text != confirmCtrl.text) {
                      setState(() => error = "New passwords don't match.");
                      return;
                    }
                    setState(() { saving = true; error = null; });
                    final err = await auth.updatePassword(
                        currentCtrl.text, newCtrl.text);
                    if (!ctx.mounted) return;
                    if (err != null) {
                      setState(() { error = err; saving = false; });
                    } else {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Row(children: [
                            Icon(Icons.check_circle_rounded,
                                color: Colors.white, size: 18),
                            SizedBox(width: 10),
                            Text("Password updated successfully!"),
                          ]),
                          backgroundColor: const Color(0xFF16A34A),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      );
                    }
                  },
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: [Color(0xFF22C55E), Color(0xFF15803D)]),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(child: saving
                        ? const SizedBox(width: 18, height: 18,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2))
                        : const Text("Update", style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700))),
                  ),
                )),
              ]),
            ]),
          ),
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context, AuthService auth) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                  color: Colors.red.shade50, shape: BoxShape.circle),
              child: Icon(Icons.logout_rounded, color: Colors.red.shade400, size: 28),
            ),
            const SizedBox(height: 16),
            const Text("Sign Out?", style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w900,
                color: Color(0xFF052E16))),
            const SizedBox(height: 8),
            Text("Are you sure you want to sign out?",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
            const SizedBox(height: 24),
            Row(children: [
              Expanded(child: TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text("Cancel", style: TextStyle(
                    color: Color(0xFF6B7280), fontWeight: FontWeight.w700)),
              )),
              const SizedBox(width: 12),
              Expanded(child: GestureDetector(
                onTap: () { Navigator.pop(ctx); auth.logout(); },
                child: Container(
                  height: 46,
                  decoration: BoxDecoration(
                    color: Colors.red.shade500,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Center(child: Text("Sign Out",
                      style: TextStyle(color: Colors.white,
                          fontWeight: FontWeight.w800))),
                ),
              )),
            ]),
          ]),
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String emoji, value, label;
  const _StatBox({required this.emoji, required this.value, required this.label});
  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05),
            blurRadius: 10, offset: const Offset(0, 3))],
      ),
      child: Column(children: [
        Text(emoji, style: const TextStyle(fontSize: 22)),
        const SizedBox(height: 6),
        Text(value, style: TextStyle(fontWeight: FontWeight.w900,
            fontSize: 16, color: context.textPrimary)),
        Text(label, style: TextStyle(color: context.textSecondary, fontSize: 10)),
      ]),
    ),
  );
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);
  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.centerLeft,
    child: Text(title, style: const TextStyle(
        fontSize: 12, fontWeight: FontWeight.w800,
        color: Color(0xFF6B7280), letterSpacing: 1)),
  );
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final String label;
  final Widget? trailing;
  final VoidCallback? onTap;
  const _ActionTile({required this.icon, required this.label,
      this.iconColor, this.trailing, this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04),
            blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: context.subtleBg,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor ?? const Color(0xFF16A34A), size: 18),
        ),
        const SizedBox(width: 14),
        Expanded(child: Text(label, style: TextStyle(
            fontWeight: FontWeight.w600, fontSize: 14,
            color: context.textPrimary))),
        trailing ?? (onTap != null
            ? Icon(Icons.chevron_right_rounded,
                color: context.textSecondary, size: 20)
            : const SizedBox()),
      ]),
    ),
  );
}

class _MoistureChip extends StatelessWidget {
  final double value;
  const _MoistureChip(this.value);
  @override
  Widget build(BuildContext context) {
    final color = value < 25 ? Colors.red.shade500
        : value < 50 ? Colors.orange : const Color(0xFF16A34A);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text("${value.toStringAsFixed(0)}%",
          style: TextStyle(color: color,
              fontWeight: FontWeight.w800, fontSize: 13)),
    );
  }
}

class _PassField extends StatelessWidget {
  final TextEditingController ctrl;
  final String label;
  final bool obscure;
  final VoidCallback onToggle;
  const _PassField({required this.ctrl, required this.label,
      required this.obscure, required this.onToggle});

  @override
  Widget build(BuildContext context) => TextField(
    controller: ctrl,
    obscureText: obscure,
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: const Icon(Icons.lock_rounded, color: Color(0xFF16A34A), size: 20),
      suffixIcon: GestureDetector(
        onTap: onToggle,
        child: Icon(obscure ? Icons.visibility_off_rounded : Icons.visibility_rounded,
            color: const Color(0xFF16A34A), size: 20),
      ),
      filled: true, fillColor: const Color(0xFFF9FAFB),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF22C55E), width: 2)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
  );
}

