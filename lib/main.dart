// Copyright (c) 2026 Mohamed Jlidi. All Rights Reserved.
// Unauthorized use, copying, or distribution is strictly prohibited.
// Contact: mohamedjlidi210@gmail.com

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_config.dart';
import 'services/auth_service.dart';
import 'services/irrigation_service.dart';
import 'services/settings_service.dart';
import 'services/notification_service.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/schedule_screen.dart';
import 'screens/history_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/onboarding_screen.dart';
import 'theme/app_theme.dart';
import 'l10n/strings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey:            firebaseApiKey,
      authDomain:        firebaseAuthDomain,
      projectId:         firebaseProjectId,
      storageBucket:     firebaseStorageBucket,
      messagingSenderId: firebaseMessagingSenderId,
      appId:             firebaseAppId,
    ),
  );
  final settings = SettingsService();
  await settings.load();
  final prefs = await SharedPreferences.getInstance();
  final onboardingDone = prefs.getBool('onboarding_done') ?? false;

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: settings),
      ChangeNotifierProvider(create: (_) => AuthService()),
      ChangeNotifierProvider(create: (_) => IrrigationService()),
    ],
    child: IrrigationApp(showOnboarding: !onboardingDone),
  ));
}

class IrrigationApp extends StatelessWidget {
  final bool showOnboarding;
  const IrrigationApp({super.key, required this.showOnboarding});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsService>();
    return MaterialApp(
      title: 'Smart Irrigation',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: settings.themeMode,
      // AuthGate is ALWAYS home â€” it decides what to show
      home: AuthGate(showOnboarding: showOnboarding),
    );
  }
}

// â”€â”€ AuthGate â€” single source of truth for routing â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// Always lives at the root. Decides: Onboarding â†’ Login â†’ MainShell
class AuthGate extends StatefulWidget {
  final bool showOnboarding;
  const AuthGate({super.key, required this.showOnboarding});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late bool _onboardingDone;

  @override
  void initState() {
    super.initState();
    _onboardingDone = !widget.showOnboarding;
  }

  void _completeOnboarding() {
    setState(() => _onboardingDone = true);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();

    // â”€â”€ Logged in â†’ MainShell â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
    if (auth.isLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final svc      = context.read<IrrigationService>();
        final settings = context.read<SettingsService>();
        svc.setUser(auth.user!.uid);
        svc.updateAutoSettings(
            settings.autoIrrigationEnabled, settings.autoIrrigationThreshold);
        svc.setWeeklyGoal(settings.weeklyWaterGoal);
        if (settings.notificationsEnabled) {
          NotificationService.requestPermission();
        }
      });
      return const MainShell();
    }

    // â”€â”€ Not logged in â†’ clear Firestore connection â”€â”€â”€â”€â”€â”€â”€â”€â”€
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<IrrigationService>().clearUser();
    });

    // â”€â”€ Onboarding not done â†’ show onboarding â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
    if (!_onboardingDone) {
      return OnboardingScreen(onDone: _completeOnboarding);
    }

    // â”€â”€ Default â†’ Login â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
    return const LoginScreen();
  }
}

// â”€â”€ Main app shell with bottom navigation â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _idx = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    ScheduleScreen(),
    HistoryScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _idx, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _idx,
        onDestinationSelected: (i) => setState(() => _idx = i),
        backgroundColor: context.navBg,
        indicatorColor: const Color(0xFF2D6A4F).withOpacity(0.15),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.dashboard_outlined),
            selectedIcon: const Icon(Icons.dashboard, color: Color(0xFF2D6A4F)),
            label: context.tr('dashboard'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.schedule_outlined),
            selectedIcon: const Icon(Icons.schedule, color: Color(0xFF2D6A4F)),
            label: context.tr('schedule'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.bar_chart_outlined),
            selectedIcon: const Icon(Icons.bar_chart, color: Color(0xFF2D6A4F)),
            label: context.tr('history'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline_rounded),
            selectedIcon: const Icon(Icons.person_rounded, color: Color(0xFF2D6A4F)),
            label: context.tr('profile'),
          ),
        ],
      ),
    );
  }
}

