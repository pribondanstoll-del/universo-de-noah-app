import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';

class PerfilScreen extends StatefulWidget {
  final bool primeiroAcesso;
  const PerfilScreen({super.key, this.primeiroAcesso = false});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  final TextEditingController _nomeController = TextEditingController();
  String _avatarSelecionado = '🦁';
  bool _salvando = false;

  final List<String> _avatares = [
    '🦁', '🐯', '🐻', '🦊', '🐼', '🐨',
    '🦋', '🐬', '🦄', '🐸', '🐧', '🦉',
    '🐶', '🐱', '🐰', '🐹', '🦝', '🐺',
  ];

  @override
  void initState() {
    super.initState();
    if (!widget.primeiroAcesso) {
      _carregarPerfil();
    }
  }

  Future<void> _carregarPerfil() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nomeController.text = prefs.getString('nome_crianca') ?? '';
      _avatarSelecionado = prefs.getString('avatar_crianca') ?? '🦁';
    });
  }

  Future<void> _salvarPerfil() async {
    if (_nomeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Digite o nome da criança!'),
          backgroundColor: Color(0xFFE53935),
        ),
      );
      return;
    }

    setState(() => _salvando = true);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('nome_crianca', _nomeController.text.trim());
    await prefs.setString('avatar_crianca', _avatarSelecionado);
    await prefs.setBool('perfil_criado', true);
    setState(() => _salvando = false);

    if (!mounted) return;

    if (widget.primeiroAcesso) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      Navigator.pop(context, true);
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B4B),
      appBar: widget.primeiroAcesso
          ? null
          : AppBar(
              backgroundColor: const Color(0xFF0D1B4B),
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              title: const Text('✏️ Editar Perfil',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (widget.primeiroAcesso) ...[
                const SizedBox(height: 20),
                const Text('🌌', style: TextStyle(fontSize: 48)),
                const SizedBox(height: 16),
                const Text(
                  'Bem-vindo ao\nUniverso de Noah!',
                  style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Vamos criar seu perfil de explorador!',
                  style: TextStyle(color: Color(0xFF8BB4F8), fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
              ],

              // Avatar selecionado
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A73E8),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1A73E8).withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(_avatarSelecionado,
                      style: const TextStyle(fontSize: 60)),
                ),
              ),
              const SizedBox(height: 8),
              const Text('Escolha seu avatar',
                  style: TextStyle(color: Color(0xFF8BB4F8), fontSize: 14)),
              const SizedBox(height: 16),

              // Grade de avatares
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E2D5A),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: _avatares.length,
                  itemBuilder: (context, index) {
                    final avatar = _avatares[index];
                    final selecionado = avatar == _avatarSelecionado;
                    return GestureDetector(
                      onTap: () => setState(() => _avatarSelecionado = avatar),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: selecionado
                              ? const Color(0xFF1A73E8)
                              : const Color(0xFF0D1B4B),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: selecionado ? Colors.white : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(avatar,
                              style: const TextStyle(fontSize: 28)),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Nome
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Nome do explorador',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _nomeController,
                style: const TextStyle(color: Colors.white, fontSize: 18),
                maxLength: 20,
                decoration: InputDecoration(
                  hintText: 'Ex: Ana, Pedro, Sofia...',
                  hintStyle: const TextStyle(color: Colors.white38),
                  filled: true,
                  fillColor: const Color(0xFF1E2D5A),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFF1A73E8), width: 2),
                  ),
                  counterStyle: const TextStyle(color: Colors.white38),
                  prefixIcon: const Icon(Icons.person, color: Color(0xFF8BB4F8)),
                ),
              ),
              const SizedBox(height: 32),

              // Botão salvar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A73E8),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: _salvando ? null : _salvarPerfil,
                  child: _salvando
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          widget.primeiroAcesso
                              ? 'Começar a aventura! 🚀'
                              : 'Salvar perfil ✅',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}