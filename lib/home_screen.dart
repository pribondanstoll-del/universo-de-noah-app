import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'niveis_screen.dart';
import 'perfil_screen.dart';
import 'progresso_screen.dart';
import 'pais_screen.dart';
import 'videos_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _nome = '';
  String _avatar = '🦁';
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarPerfil();
  }

  Future<void> _carregarPerfil() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nome = prefs.getString('nome_crianca') ?? '';
      _avatar = prefs.getString('avatar_crianca') ?? '🦁';
      _carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_carregando) {
      return const Scaffold(
        backgroundColor: Color(0xFF0D1B4B),
        body: Center(child: CircularProgressIndicator(color: Color(0xFF8BB4F8))),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0D1B4B),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header com perfil
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _nome.isEmpty ? 'Olá, explorador! 👋' : 'Olá, $_nome! 👋',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'O que vamos aprender hoje?',
                          style: TextStyle(
                            color: Color(0xFF8BB4F8),
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const PerfilScreen()),
                      );
                      _carregarPerfil();
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A73E8),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF1A73E8).withOpacity(0.4),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(_avatar, style: const TextStyle(fontSize: 32)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Cards de navegação
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _MenuCard(
                      emoji: '📚',
                      titulo: 'Lições',
                      subtitulo: 'Aprender inglês',
                      cor: const Color(0xFF1A73E8),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const NiveisScreen()),
                      ),
                    ),
                    _MenuCard(
                      emoji: '🎵',
                      titulo: 'Músicas',
                      subtitulo: 'Cantar e aprender',
                      cor: const Color(0xFF7B2FBE),
                      onTap: () {},
                    ),
                    _MenuCard(
                      emoji: '🎬',
                      titulo: 'Vídeos',
                      subtitulo: 'Assistir e aprender',
                      cor: const Color(0xFFE53935),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const VideosScreen()),
                      ),
                    ),
                    _MenuCard(
                      emoji: '⭐',
                      titulo: 'Progresso',
                      subtitulo: 'Ver conquistas',
                      cor: const Color(0xFFF9A825),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ProgressoScreen()),
                      ),
                    ),
                  ],
                ),
              ),

              // Botão Painel dos Pais
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PaisScreen()),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E2D5A),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('👨‍👩‍👧', style: TextStyle(fontSize: 20)),
                      SizedBox(width: 8),
                      Text('Painel dos Pais',
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 15,
                              fontWeight: FontWeight.bold)),
                    ],
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

class _MenuCard extends StatelessWidget {
  final String emoji;
  final String titulo;
  final String subtitulo;
  final Color cor;
  final VoidCallback onTap;

  const _MenuCard({
    required this.emoji,
    required this.titulo,
    required this.subtitulo,
    required this.cor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: cor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: cor.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 48)),
              const SizedBox(height: 12),
              Text(
                titulo,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitulo,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}