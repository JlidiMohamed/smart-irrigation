import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with SingleTickerProviderStateMixin {
  final _nameCtrl    = TextEditingController();
  final _emailCtrl   = TextEditingController();
  final _passCtrl    = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscureP = true, _obscureC = true;
  bool _loading = false;
  String? _error;
  late AnimationController _anim;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 700))..forward();
  }

  @override
  void dispose() {
    _anim.dispose();
    _nameCtrl.dispose(); _emailCtrl.dispose();
    _passCtrl.dispose(); _confirmCtrl.dispose();
    super.dispose();
  }

  double get _strength {
    final p = _passCtrl.text;
    if (p.isEmpty) return 0;
    double s = 0;
    if (p.length >= 6) s += 0.25;
    if (p.length >= 10) s += 0.25;
    if (p.contains(RegExp(r'[A-Z]'))) s += 0.25;
    if (p.contains(RegExp(r'[0-9!@#$%]'))) s += 0.25;
    return s;
  }

  Color get _strengthColor {
    final s = _strength;
    if (s <= 0.25) return Colors.red;
    if (s <= 0.5) return Colors.orange;
    if (s <= 0.75) return Colors.amber;
    return const Color(0xFF22C55E);
  }

  String get _strengthLabel {
    final s = _strength;
    if (s <= 0.25) return "Weak 😬";
    if (s <= 0.5) return "Fair 🙂";
    if (s <= 0.75) return "Good 😎";
    return "Strong 💪";
  }

  Future<void> _signup() async {
    if (_passCtrl.text != _confirmCtrl.text) {
      setState(() => _error = "Passwords don't match.");
      return;
    }
    if (_passCtrl.text.length < 6) {
      setState(() => _error = "Password needs at least 6 characters.");
      return;
    }
    setState(() { _loading = true; _error = null; });
    final auth = context.read<AuthService>();
    final err = await auth.signup(
        _nameCtrl.text.trim(), _emailCtrl.text.trim(), _passCtrl.text);
    if (!mounted) return;
    if (err != null) {
      setState(() { _error = err; _loading = false; });
      return;
    }
    // Sign out immediately so user must log in manually
    await auth.logout();
    if (!mounted) return;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              width: 72, height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFF4ADE80), Color(0xFF16A34A)],
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                ),
                boxShadow: [BoxShadow(
                  color: const Color(0xFF22C55E).withOpacity(0.4),
                  blurRadius: 20, spreadRadius: 2)],
              ),
              child: const Center(child: Text("🎉", style: TextStyle(fontSize: 34))),
            ),
            const SizedBox(height: 20),
            const Text("Account Created!", style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF052E16))),
            const SizedBox(height: 8),
            Text("Welcome aboard! A confirmation email has been sent to your address.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13, height: 1.4)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFDCFCE7),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF86EFAC)),
              ),
              child: Row(children: [
                const Icon(Icons.mark_email_read_rounded,
                    color: Color(0xFF16A34A), size: 18),
                const SizedBox(width: 8),
                Expanded(child: Text(
                  "Check your inbox to verify your email.",
                  style: TextStyle(color: Colors.grey.shade700,
                      fontSize: 12, height: 1.3),
                )),
              ]),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: double.infinity, height: 50,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [Color(0xFF22C55E), Color(0xFF15803D)]),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [BoxShadow(
                      color: const Color(0xFF22C55E).withOpacity(0.4),
                      blurRadius: 12, offset: const Offset(0, 4))],
                ),
                child: const Center(child: Text("Go to Sign In →",
                    style: TextStyle(color: Colors.white,
                        fontWeight: FontWeight.w800, fontSize: 15))),
              ),
            ),
          ]),
        ),
      ),
    );
    if (mounted) Navigator.pop(context);
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
              opacity: CurvedAnimation(parent: _anim, curve: Curves.easeOut),
              child: Column(children: [
                const SizedBox(height: 20),
                Row(children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 42, height: 42,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withOpacity(0.2)),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: Colors.white, size: 16),
                    ),
                  ),
                ]),
                const SizedBox(height: 24),

                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.elasticOut,
                  builder: (_, v, child) => Transform.scale(scale: v, child: child),
                  child: Stack(alignment: Alignment.center, children: [
                    Container(width: 90, height: 90,
                        decoration: BoxDecoration(shape: BoxShape.circle,
                            color: const Color(0xFF22C55E).withOpacity(0.15))),
                    Container(
                      width: 72, height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF86EFAC), Color(0xFF16A34A)],
                          begin: Alignment.topLeft, end: Alignment.bottomRight,
                        ),
                        boxShadow: [BoxShadow(
                            color: const Color(0xFF22C55E).withOpacity(0.45),
                            blurRadius: 20, spreadRadius: 2)],
                      ),
                      child: const Center(child: Text("🌱", style: TextStyle(fontSize: 32))),
                    ),
                  ]),
                ),

                const SizedBox(height: 14),
                const Text("Join the club!", style: TextStyle(
                    color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text("Set up your account in seconds",
                    style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 13)),
                const SizedBox(height: 28),

                Container(
                  decoration: BoxDecoration(
                    color: Colors.white, borderRadius: BorderRadius.circular(28),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2),
                        blurRadius: 40, offset: const Offset(0, 12))],
                  ),
                  padding: const EdgeInsets.all(26),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: const Color(0xFFDCFCE7),
                            borderRadius: BorderRadius.circular(10)),
                        child: const Icon(Icons.person_add_rounded,
                            color: Color(0xFF16A34A), size: 18),
                      ),
                      const SizedBox(width: 10),
                      const Text("Create your account", style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF14532D))),
                    ]),
                    const SizedBox(height: 22),

                    _Field(ctrl: _nameCtrl, label: "Full Name 🙋", hint: "Your name",
                        icon: Icons.badge_rounded),
                    const SizedBox(height: 14),
                    _Field(ctrl: _emailCtrl, label: "Email 📬", hint: "you@example.com",
                        icon: Icons.alternate_email_rounded, type: TextInputType.emailAddress),
                    const SizedBox(height: 14),
                    _Field(
                      ctrl: _passCtrl, label: "Password 🔑", hint: "Min. 6 characters",
                      icon: Icons.lock_rounded, obscure: _obscureP,
                      onChanged: (_) => setState(() {}),
                      suffix: GestureDetector(
                        onTap: () => setState(() => _obscureP = !_obscureP),
                        child: Icon(_obscureP ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                            color: const Color(0xFF16A34A), size: 20),
                      ),
                    ),

                    if (_passCtrl.text.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Row(children: [
                        Expanded(child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: _strength,
                            backgroundColor: Colors.grey.shade200,
                            valueColor: AlwaysStoppedAnimation<Color>(_strengthColor),
                            minHeight: 5,
                          ),
                        )),
                        const SizedBox(width: 10),
                        Text(_strengthLabel, style: TextStyle(
                            fontSize: 11, color: _strengthColor, fontWeight: FontWeight.w700)),
                      ]),
                    ],

                    const SizedBox(height: 14),
                    _Field(
                      ctrl: _confirmCtrl, label: "Confirm Password ✅",
                      hint: "Repeat password", icon: Icons.lock_clock_rounded,
                      obscure: _obscureC,
                      suffix: GestureDetector(
                        onTap: () => setState(() => _obscureC = !_obscureC),
                        child: Icon(_obscureC ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                            color: const Color(0xFF16A34A), size: 20),
                      ),
                    ),

                    const SizedBox(height: 18),

                    if (_error != null) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50, borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Row(children: [
                          Icon(Icons.warning_amber_rounded, color: Colors.red.shade400, size: 16),
                          const SizedBox(width: 8),
                          Expanded(child: Text(_error!,
                              style: TextStyle(color: Colors.red.shade600, fontSize: 12))),
                        ]),
                      ),
                      const SizedBox(height: 14),
                    ],

                    GestureDetector(
                      onTap: _loading ? null : _signup,
                      child: Container(
                        height: 54,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                              colors: [Color(0xFF22C55E), Color(0xFF052E16)]),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [BoxShadow(
                              color: const Color(0xFF22C55E).withOpacity(0.4),
                              blurRadius: 14, offset: const Offset(0, 6))],
                        ),
                        child: Center(child: _loading
                            ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5)
                            : const Row(mainAxisSize: MainAxisSize.min, children: [
                                Text("Let's start! ", style: TextStyle(color: Colors.white,
                                    fontSize: 16, fontWeight: FontWeight.w800)),
                                Text("🎉", style: TextStyle(fontSize: 16)),
                              ])),
                      ),
                    ),

                    const SizedBox(height: 16),
                    Center(child: Text("Already have an account? ",
                        style: TextStyle(color: Colors.grey.shade500, fontSize: 13))),
                    Center(child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text("Sign In →",
                          style: TextStyle(color: Color(0xFF16A34A),
                              fontWeight: FontWeight.w700, fontSize: 13)),
                    )),
                  ]),
                ),
                const SizedBox(height: 36),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final TextEditingController ctrl;
  final String label, hint;
  final IconData icon;
  final bool obscure;
  final Widget? suffix;
  final TextInputType? type;
  final void Function(String)? onChanged;
  const _Field({required this.ctrl, required this.label, required this.hint,
      required this.icon, this.obscure = false, this.suffix, this.type, this.onChanged});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(fontSize: 12,
          fontWeight: FontWeight.w700, color: Color(0xFF374151))),
      const SizedBox(height: 6),
      TextField(
        controller: ctrl, obscureText: obscure,
        keyboardType: type, onChanged: onChanged,
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
