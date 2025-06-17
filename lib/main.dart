import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easynotes_pro/core/database/database_helper.dart';
import 'package:easynotes_pro/core/theme/app_theme.dart';
import 'package:easynotes_pro/presentation/pages/home_page.dart';
import 'package:easynotes_pro/presentation/pages/lock_screen.dart';
import 'package:easynotes_pro/services/security_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar base de datos
  await DatabaseHelper.instance.database;

  runApp(
    const ProviderScope(
      child: EasyNotesApp(),
    ),
  );
}

class EasyNotesApp extends ConsumerStatefulWidget {
  const EasyNotesApp({super.key});

  @override
  ConsumerState<EasyNotesApp> createState() => _EasyNotesAppState();
}

class _EasyNotesAppState extends ConsumerState<EasyNotesApp> with WidgetsBindingObserver {
  bool _isLocked = false;
  bool _isCheckingLock = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkLockStatus();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      // App va al background
      _lockApp();
    } else if (state == AppLifecycleState.resumed) {
      // App regresa del background
      _checkLockStatus();
    }
  }

  Future<void> _checkLockStatus() async {
    final shouldLock = await SecurityService.instance.shouldLockApp();
    setState(() {
      _isLocked = shouldLock;
      _isCheckingLock = false;
    });
  }

  Future<void> _lockApp() async {
    final isAppLockEnabled = await SecurityService.instance.isAppLockEnabled();
    if (isAppLockEnabled) {
      setState(() {
        _isLocked = true;
      });
    }
  }

  void _unlockApp() {
    setState(() {
      _isLocked = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EasyNotes Pro',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: _isCheckingLock
          ? const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      )
          : _isLocked
          ? LockScreen(onUnlocked: _unlockApp)
          : const HomePage(),
    );
  }
}