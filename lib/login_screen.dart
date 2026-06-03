import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'cadastro_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _carregando = false;
  bool _mostrarSenha = false;
  String? _erro;

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() {
      _erro = null;
      _carregando = true;
    });

    final erro = await AuthService.login(
      email: _emailController.text,
      senha: _senhaController.text,
    );

    if (!mounted) return;

    if (erro != null) {
      setState(() {
        _erro = erro;
        _carregando = false;
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  Future<void> _redefinirSenha() async {
    if (_emailController.text.trim().isEmpty) {
      setState(() => _erro = 'Digite seu e-mail para redefinir a senha.');
      return;
    }

    final erro = await AuthService.redefinirSenha(_emailController.text);
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(erro ?? 'E-mail de redefinição enviado!'),
        backgroundColor:
            erro != null ? const Color(0xFFE53935) : const Color(0xFF34A853),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B4B),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              const Text('🌌', style: TextStyle(fontSize: 64)),
              const SizedBox(height: 16),
              const Text(
                'Universo de Noah',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Entre na sua conta',
                style: TextStyle(color: Color(0xFF8BB4F8), fontSize: 15),
              ),
              const SizedBox(height: 40),

              // Erro
              if (_erro != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7F0000),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline,
                          color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(_erro!,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 14)),
                      ),
                    ],
                  ),
                ),

              // Email
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'E-mail',
                  labelStyle: const TextStyle(color: Colors.white54),
                  prefixIcon: const Icon(Icons.email,
                      color: Color(0xFF8BB4F8)),
                  filled: true,
                  fillColor: const Color(0xFF1E2D5A),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                        color: Color(0xFF1A73E8), width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Senha
              TextField(
                controller: _senhaController,
                obscureText: !_mostrarSenha,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Senha',
                  labelStyle: const TextStyle(color: Colors.white54),
                  prefixIcon: const Icon(Icons.lock,
                      color: Color(0xFF8BB4F8)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _mostrarSenha
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.white38,
                    ),
                    onPressed: () =>
                        setState(() => _mostrarSenha = !_mostrarSenha),
                  ),
                  filled: true,
                  fillColor: const Color(0xFF1E2D5A),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                        color: Color(0xFF1A73E8), width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Esqueceu a senha
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: _redefinirSenha,
                  child: const Text(
                    'Esqueceu a senha?',
                    style: TextStyle(
                        color: Color(0xFF8BB4F8), fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Botão entrar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A73E8),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: _carregando ? null : _login,
                  child: _carregando
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Entrar',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 16),

              // Criar conta
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Não tem conta? ',
                      style: TextStyle(color: Colors.white54)),
                  GestureDetector(
                    onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const CadastroScreen()),
                    ),
                    child: const Text('Criar conta',
                        style: TextStyle(
                            color: Color(0xFF1A73E8),
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}