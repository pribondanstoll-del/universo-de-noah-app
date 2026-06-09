import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'home_screen.dart';
import 'perfil_screen.dart';
import 'login_screen.dart';
import 'onboarding_screen.dart';
import 'auth_service.dart';
import 'progresso_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await ProgressoService.inicializar();
  runApp(const UniversoDeNoahApp());
}

class UniversoDeNoahApp extends StatelessWidget {
  const UniversoDeNoahApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Universo de Noah',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A73E8),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();

    Future.delayed(const Duration(seconds: 3), () async {
      if (!mounted) return;

      final prefs = await SharedPreferences.getInstance();
      final onboardingVisto = prefs.getBool('onboarding_visto') ?? false;

      // Primeira vez — mostra onboarding
      if (!onboardingVisto) {
        await prefs.setBool('onboarding_visto', true);
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const OnboardingScreen()),
        );
        return;
      }

      // Verifica se está logado (Firebase persiste automaticamente)
      if (!AuthService.estaLogado) {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
        return;
      }

      // Está logado — verifica perfil da criança
      final perfilCriado = prefs.getBool('perfil_criado') ?? false;
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => perfilCriado
              ? const HomeScreen()
              : const PerfilScreen(primeiroAcesso: true),
        ),
      );
    });
  }

  late Animation<double> _fadeAnim;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B4B),
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('✨', style: TextStyle(fontSize: 32)),
              const SizedBox(height: 16),
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A73E8),
                  borderRadius: BorderRadius.circular(35),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1A73E8).withOpacity(0.5),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Center(
                  child: Text('🌌', style: TextStyle(fontSize: 72)),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Universo de Noah',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Aprender é uma aventura! 🚀',
                style: TextStyle(
                  color: Color(0xFF8BB4F8),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 48),
              const CircularProgressIndicator(
                color: Color(0xFF8BB4F8),
                strokeWidth: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}