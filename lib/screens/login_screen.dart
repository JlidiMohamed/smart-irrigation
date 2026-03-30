// Copyright (c) 2026 Mohamed Jlidi. All Rights Reserved.
// Unauthorized use, copying, or distribution is strictly prohibited.
// Contact: mohamedjlidi210@gmail.com

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _emailCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();
  bool _obscure = true;
  bool _loading = false;
  String? _error;
  late AnimationController _anim;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fade  = CurvedAnimation(parent: _anim, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero)
        .animate(CurvedAnimation(parent: _anim, curve: Curves.easeOut));
    _anim.forward();
  }

  @override
  void dispose() { _anim.dispose(); _emailCtrl.dispose(); _passCtrl.dispose(); super.dispose(); }

  void _showForgotPassword(BuildContext context) {
    final emailCtrl = TextEditingController();
    String? dialogError;
    bool sending = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.lock_reset_rounded,
                    color: Color(0xFF16A34A), size: 28),
              ),
              const SizedBox(height: 16),
              const Text("Reset Password", style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF052E16))),
              const SizedBox(height: 6),
              Text("Enter your email and we'll send you a reset link.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12, height: 1.4)),
              const SizedBox(height: 20),
              TextField(
                controller: emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: "you@example.com",
                  prefixIcon: const Icon(Icons.alternate_email_rounded,
                      color: Color(0xFF16A34A), size: 20),
                  filled: true, fillColor: const Color(0xFFF9FAFB),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade200)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade200)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF22C55E), width: 2)),
                ),
              ),
              if (dialogError != null) ...[
                const SizedBox(height: 10),
                Text(dialogError!, style: TextStyle(color: Colors.red.shade600, fontSize: 12)),
              ],
              const SizedBox(height: 20),
              Row(children: [
                Expanded(child: TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text("Cancel", style: TextStyle(color: Color(0xFF6B7280))),
                )),
                const SizedBox(width: 8),
                Expanded(child: GestureDetector(
                  onTap: sending ? null : () async {
                    setState(() { sending = true; dialogError = null; });
                    final err = await context.read<AuthService>()
                        .resetPassword(emailCtrl.text.trim());
                    if (!ctx.mounted) return;
                    if (err != null) {
                      setState(() { dialogError = err; sending = false; });
                    } else {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Row(children: [
                            Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
                            SizedBox(width: 10),
                            Text("Reset link sent! Check your email."),
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
                    child: Center(child: sending
                        ? const SizedBox(width: 18, height: 18,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text("Send Link",
                            style: TextStyle(color: Colors.white,
                                fontWeight: FontWeight.w700))),
                  ),
                )),
              ]),
            ]),
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    setState(() { _loading = true; _error = null; });
    final err = await context.read<AuthService>().login(_emailCtrl.text.trim(), _passCtrl.text);
    if (!mounted) return;
    if (err != null) setState(() { _error = err; _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF052E16), Color(0xFF14532D), Color(0xFF166534)],
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: FadeTransition(
              opacity: _fade,
              child: SlideTransition(
                position: _slide,
                child: Column(children: [
                  const SizedBox(height: 52),

                  // Big friendly icon
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 900),
                    curve: Curves.elasticOut,
                    builder: (_, v, child) => Transform.scale(scale: v, child: child),
                    child: Stack(alignment: Alignment.center, children: [
                      Container(
                        width: 100, height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF22C55E).withOpacity(0.15),
                        ),
                      ),
                      Container(
                        width: 78, height: 78,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF4ADE80), Color(0xFF16A34A)],
                            begin: Alignment.topLeft, end: Alignment.bottomRight,
                          ),
                          boxShadow: [BoxShadow(
                            color: const Color(0xFF22C55E).withOpacity(0.5),
                            blurRadius: 24, spreadRadius: 2,
                          )],
                        ),
                        child: const Center(child: Text("ðŸ’§", style: TextStyle(fontSize: 36))),
                      ),
                    ]),
                  ),

                  const SizedBox(height: 18),
                  const Text("Smart Irrigation", style: TextStyle(
                    color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF22C55E).withOpacity(0.18),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFF22C55E).withOpacity(0.3)),
                    ),
                    child: const Text("ðŸ‘‹ Welcome back!", style: TextStyle(
                        color: Color(0xFF86EFAC), fontSize: 12, fontWeight: FontWeight.w600)),
                  ),

                  const SizedBox(height: 36),

                  // Card
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [BoxShadow(
                        color: Colors.black.withOpacity(0.2), blurRadius: 40, offset: const Offset(0, 12))],
                    ),
                    padding: const EdgeInsets.all(26),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCFCE7),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.lock_open_rounded, color: Color(0xFF16A34A), size: 18),
                        ),
                        const SizedBox(width: 10),
                        const Text("Sign in to your account", style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF14532D))),
                      ]),
                      const SizedBox(height: 22),

                      _FancyField(ctrl: _emailCtrl, label: "Email", hint: "you@example.com",
                          icon: Icons.alternate_email_rounded, type: TextInputType.emailAddress),
                      const SizedBox(height: 14),
                      _FancyField(
                        ctrl: _passCtrl, label: "Password", hint: "Your password",
                        icon: Icons.lock_rounded, obscure: _obscure,
                        suffix: GestureDetector(
                          onTap: () => setState(() => _obscure = !_obscure),
                          child: Icon(_obscure ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                              color: const Color(0xFF16A34A), size: 20),
                        ),
                      ),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => _showForgotPassword(context),
                          child: const Text("Forgot password?", style: TextStyle(
                              color: Color(0xFF16A34A), fontSize: 12, fontWeight: FontWeight.w600)),
                        ),
                      ),

                      if (_error != null) ...[
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.red.shade200),
                          ),
                          child: Row(children: [
                            Icon(Icons.warning_amber_rounded, color: Colors.red.shade400, size: 16),
                            const SizedBox(width: 8),
                            Expanded(child: Text(_error!, style: TextStyle(color: Colors.red.shade600, fontSize: 12))),
                          ]),
                        ),
                        const SizedBox(height: 12),
                      ],

                      // Submit
                      GestureDetector(
                        onTap: _loading ? null : _login,
                        child: Container(
                          height: 54,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF16A34A), Color(0xFF052E16)],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [BoxShadow(
                              color: const Color(0xFF16A34A).withOpacity(0.4),
                              blurRadius: 14, offset: const Offset(0, 6),
                            )],
                          ),
                          child: Center(child: _loading
                              ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5)
                              : const Row(mainAxisSize: MainAxisSize.min, children: [
                                  Text("Let's go!", style: TextStyle(color: Colors.white,
                                      fontSize: 16, fontWeight: FontWeight.w800)),
                                  SizedBox(width: 8),
                                  Text("ðŸš€", style: TextStyle(fontSize: 16)),
                                ])),
                        ),
                      ),

                      const SizedBox(height: 18),
                      Row(children: [
                        Expanded(child: Divider(color: Colors.grey.shade200)),
                        Padding(padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text("no account?", style: TextStyle(color: Colors.grey.shade400, fontSize: 11))),
                        Expanded(child: Divider(color: Colors.grey.shade200)),
                      ]),
                      const SizedBox(height: 14),

                      GestureDetector(
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) => const SignupScreen())),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0FDF4),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFF86EFAC)),
                          ),
                          child: const Center(child: Text("Create an account ðŸŒ±",
                              style: TextStyle(color: Color(0xFF14532D),
                                  fontWeight: FontWeight.w700, fontSize: 14))),
                        ),
                      ),
                    ]),
                  ),

                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      _emailCtrl.text = 'demo@irrigation.com';
                      _passCtrl.text  = 'demo123';
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withOpacity(0.15)),
                      ),
                      child: Row(children: [
                        const Text("ðŸ’¡", style: TextStyle(fontSize: 14)),
                        const SizedBox(width: 8),
                        Text("Tap to use demo account",
                            style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12)),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // â”€â”€ Signature â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                  const _Signature(),
                  const SizedBox(height: 24),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Signature extends StatelessWidget {
  const _Signature();
  @override
  Widget build(BuildContext context) => Column(children: [
    Text('Designed & Developed by',
        style: TextStyle(color: Colors.white.withOpacity(0.35),
            fontSize: 11, letterSpacing: 0.5)),
    const SizedBox(height: 3),
    Text('Mohamed Jlidi',
        style: TextStyle(
            color: Colors.white.withOpacity(0.75),
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8)),
  ]);
}

class _FancyField extends StatelessWidget {
  final TextEditingController ctrl;
  final String label, hint;
  final IconData icon;
  final bool obscure;
  final Widget? suffix;
  final TextInputType? type;
  const _FancyField({required this.ctrl, required this.label, required this.hint,
      required this.icon, this.obscure = false, this.suffix, this.type});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(fontSize: 12,
          fontWeight: FontWeight.w700, color: Color(0xFF374151))),
      const SizedBox(height: 6),
      TextField(
        controller: ctrl, obscureText: obscure, keyboardType: type,
        style: const TextStyle(fontSize: 15, color: Color(0xFF111827)),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          prefixIcon: Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(color: const Color(0xFFDCFCE7),
                borderRadius: BorderRadius.circular(9)),
            child: Icon(icon, color: const Color(0xFF16A34A), size: 17),
          ),
          suffixIcon: suffix != null
              ? Padding(padding: const EdgeInsets.only(right: 12), child: suffix) : null,
          filled: true, fillColor: const Color(0xFFF9FAFB),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey.shade200)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey.shade200)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFF22C55E), width: 2)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    ],
  );
}

