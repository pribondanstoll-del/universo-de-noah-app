import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'niveis_screen.dart';
import 'perfil_screen.dart';
import 'progresso_screen.dart';
import 'pais_screen.dart';
import 'videos_screen.dart';
import 'musicas_screen.dart';

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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'O que vamos aprender hoje?',
                          style: TextStyle(
                            color: Color(0xFF8BB4F8),
                            fontSize: 14,
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
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A73E8),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF1A73E8).withOpacity(0.4),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(_avatar, style: const TextStyle(fontSize: 28)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Cards de navegação
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.1,
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
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const MusicasScreen()),
                      ),
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
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PaisScreen()),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
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
              const SizedBox(height: 8),
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
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: cor.withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 40)),
              const SizedBox(height: 8),
              Text(
                titulo,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitulo,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}