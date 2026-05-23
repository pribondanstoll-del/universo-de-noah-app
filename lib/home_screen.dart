import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B4B),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Saudação
              const Text(
                'Olá, explorador! 👋',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'O que vamos aprender hoje?',
                style: TextStyle(
                  color: Color(0xFF8BB4F8),
                  fontSize: 16,
                ),
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
                      onTap: () {},
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
                      onTap: () {},
                    ),
                    _MenuCard(
                      emoji: '⭐',
                      titulo: 'Progresso',
                      subtitulo: 'Ver conquistas',
                      cor: const Color(0xFFF9A825),
                      onTap: () {},
                    ),
                  ],
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