import 'package:flutter/material.dart';

void main() {
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
        fontFamily: 'Nunito',
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
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

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
          opacity: _fadeIn,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Estrelas decorativas
              const Text('✨', style: TextStyle(fontSize: 32)),
              const SizedBox(height: 16),
              // Logo placeholder
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
              // Nome do app
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
              // Loading indicator
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