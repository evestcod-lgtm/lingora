import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'models.dart';
import 'services/services.dart';
import 'screens/onboarding_screens.dart';
import 'screens/home_screen.dart';

/// Глобальное состояние приложения: настройки + прогресс пользователя.
/// Простой ChangeNotifier-синглтон — без лишних зависимостей, легко читается.
class AppState extends ChangeNotifier {
  AppState._();
  static final AppState I = AppState._();

  AppSettings settings = AppSettings();
  UserProgress progress = UserProgress();
  String userName = 'Странник';
  bool loaded = false;

  Future<void> load() async {
    settings = await StorageService.loadSettings();
    progress = await StorageService.loadProgress();
    userName = await StorageService.loadUserName();
    SoundService.enabled = settings.soundOn;
    SoundService.vibrationEnabled = settings.vibrationOn;
    loaded = true;
    notifyListeners();
  }

  Future<void> saveSettings() async {
    SoundService.enabled = settings.soundOn;
    SoundService.vibrationEnabled = settings.vibrationOn;
    await StorageService.saveSettings(settings);
    notifyListeners();
  }

  Future<void> saveProgress() async {
    await StorageService.saveProgress(progress);
    notifyListeners();
  }

  Future<void> saveUserName(String name) async {
    userName = name;
    await StorageService.saveUserName(name);
    notifyListeners();
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const LingoraApp());
}

class LingoraApp extends StatefulWidget {
  const LingoraApp({super.key});

  @override
  State<LingoraApp> createState() => _LingoraAppState();
}

class _LingoraAppState extends State<LingoraApp> {
  bool? _onboarded;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    await AppState.I.load();
    final onboarded = await StorageService.isOnboarded();
    if (mounted) setState(() => _onboarded = onboarded);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lingora',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: _onboarded == null
          ? const _SplashScreen()
          : (_onboarded! ? const HomeScreen() : const OnboardingFlow()),
    );
  }
}

class _SplashScreen extends StatefulWidget {
  const _SplashScreen();

  @override
  State<_SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<_SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))
      ..forward();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.background),
        child: Center(
          child: AnimatedBuilder(
            animation: _c,
            builder: (context, child) {
              final scale = 0.7 + Curves.easeOutBack.transform(_c.value) * 0.3;
              return Opacity(
                opacity: _c.value.clamp(0, 1),
                child: Transform.scale(scale: scale, child: child),
              );
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.primaryButton,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.teal.withOpacity(0.5),
                        blurRadius: 40,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text('L', style: TextStyle(fontSize: 46, fontWeight: FontWeight.w900)),
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Lingora',
                    style: TextStyle(
                        fontSize: 30, fontWeight: FontWeight.w800, letterSpacing: 1)),
                const SizedBox(height: 6),
                const Text('мир языков ждёт тебя',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
