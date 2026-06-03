import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'login_screen.dart';
import 'perfil_screen.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();
  bool _carregando = false;
  bool _mostrarSenha = false;
  String? _erro;

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  Future<void> _cadastrar() async {
    setState(() {
      _erro = null;
      _carregando = true;
    });

    if (_nomeController.text.trim().isEmpty) {
      setState(() {
        _erro = 'Digite seu nome.';
        _carregando = false;
      });
      return;
    }

    if (_senhaController.text != _confirmarSenhaController.text) {
      setState(() {
        _erro = 'As senhas não coincidem.';
        _carregando = false;
      });
      return;
    }

    if (_senhaController.text.length < 6) {
      setState(() {
        _erro = 'A senha deve ter pelo menos 6 caracteres.';
        _carregando = false;
      });
      return;
    }

    final erro = await AuthService.cadastrar(
      email: _emailController.text,
      senha: _senhaController.text,
      nomeResponsavel: _nomeController.text.trim(),
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
        MaterialPageRoute(
          builder: (_) => const PerfilScreen(primeiroAcesso: true),
        ),
      );
    }
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
              const SizedBox(height: 20),
              const Text('🌌', style: TextStyle(fontSize: 48)),
              const SizedBox(height: 16),
              const Text(
                'Criar conta',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Crie sua conta de responsável',
                style: TextStyle(color: Color(0xFF8BB4F8), fontSize: 15),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

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

              // Nome
              _campo(
                controller: _nomeController,
                label: 'Nome do responsável',
                icone: Icons.person,
              ),
              const SizedBox(height: 12),

              // Email
              _campo(
                controller: _emailController,
                label: 'E-mail',
                icone: Icons.email,
                teclado: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),

              // Senha
              _campo(
                controller: _senhaController,
                label: 'Senha',
                icone: Icons.lock,
                senha: true,
                mostrarSenha: _mostrarSenha,
                onToggleSenha: () =>
                    setState(() => _mostrarSenha = !_mostrarSenha),
              ),
              const SizedBox(height: 12),

              // Confirmar senha
              _campo(
                controller: _confirmarSenhaController,
                label: 'Confirmar senha',
                icone: Icons.lock_outline,
                senha: true,
                mostrarSenha: _mostrarSenha,
              ),
              const SizedBox(height: 32),

              // Botão cadastrar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A73E8),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: _carregando ? null : _cadastrar,
                  child: _carregando
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Criar conta',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 16),

              // Já tem conta
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Já tem conta? ',
                      style: TextStyle(color: Colors.white54)),
                  GestureDetector(
                    onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    ),
                    child: const Text('Entrar',
                        style: TextStyle(
                            color: Color(0xFF1A73E8),
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _campo({
    required TextEditingController controller,
    required String label,
    required IconData icone,
    bool senha = false,
    bool mostrarSenha = false,
    VoidCallback? onToggleSenha,
    TextInputType teclado = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: senha && !mostrarSenha,
      keyboardType: teclado,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white54),
        prefixIcon: Icon(icone, color: const Color(0xFF8BB4F8)),
        suffixIcon: senha && onToggleSenha != null
            ? IconButton(
                icon: Icon(
                  mostrarSenha ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white38,
                ),
                onPressed: onToggleSenha,
              )
            : null,
        filled: true,
        fillColor: const Color(0xFF1E2D5A),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide:
              const BorderSide(color: Color(0xFF1A73E8), width: 2),
        ),
      ),
    );
  }
}