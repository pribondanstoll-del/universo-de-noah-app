import 'package:flutter/material.dart';
import 'fase_screen.dart';

class MapaFasesScreen extends StatefulWidget {
  const MapaFasesScreen({super.key});

  @override
  State<MapaFasesScreen> createState() => _MapaFasesScreenState();
}

class _MapaFasesScreenState extends State<MapaFasesScreen> {
  int _faseAtual = 0;
  List<int> _estrelas = List.filled(12, 0);

  final List<Map<String, dynamic>> _fases = [
    {'titulo': 'Saudações', 'emoji': '👋', 'cor': Color(0xFF1A73E8), 'temas': ['Saudações']},
    {'titulo': 'Cores', 'emoji': '🎨', 'cor': Color(0xFF7B2FBE), 'temas': ['Cores']},
    {'titulo': 'Revisão 1', 'emoji': '🔄', 'cor': Color(0xFF34A853), 'temas': ['Saudações', 'Cores']},
    {'titulo': 'Números', 'emoji': '🔢', 'cor': Color(0xFFF9A825), 'temas': ['Números']},
    {'titulo': 'Saudações+', 'emoji': '🌟', 'cor': Color(0xFF1A73E8), 'temas': ['Saudações', 'Números']},
    {'titulo': 'Animais', 'emoji': '🐾', 'cor': Color(0xFFE53935), 'temas': ['Animais']},
    {'titulo': 'Revisão 2', 'emoji': '🔄', 'cor': Color(0xFF00ACC1), 'temas': ['Cores', 'Números']},
    {'titulo': 'Frutas', 'emoji': '🍎', 'cor': Color(0xFFE53935), 'temas': ['Frutas']},
    {'titulo': 'Família', 'emoji': '👨‍👩‍👧', 'cor': Color(0xFF7B2FBE), 'temas': ['Família']},
    {'titulo': 'Revisão 3', 'emoji': '🏆', 'cor': Color(0xFFF9A825), 'temas': ['Animais', 'Frutas']},
    {'titulo': 'Desafio!', 'emoji': '⚡', 'cor': Color(0xFFE53935), 'temas': ['Saudações', 'Cores', 'Números']},
    {'titulo': 'Mestre!', 'emoji': '👑', 'cor': Color(0xFFF9A825), 'temas': ['Animais', 'Frutas', 'Família']},
  ];

  void _aoCompletarFase(int fase, int estrelasConcluidas) {
    setState(() {
      if (estrelasConcluidas > _estrelas[fase]) {
        _estrelas[fase] = estrelasConcluidas;
      }
      if (fase == _faseAtual && estrelasConcluidas > 0) {
        if (_faseAtual < _fases.length - 1) {
          _faseAtual = fase + 1;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B4B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1B4B),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '🗺️ Mapa de Fases',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.85,
          ),
          itemCount: _fases.length,
          itemBuilder: (context, index) {
            final fase = _fases[index];
            final desbloqueada = index <= _faseAtual;
            final estrelas = _estrelas[index];
            final cor = fase['cor'] as Color;

            return GestureDetector(
              onTap: desbloqueada
                  ? () async {
                      final resultado = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FaseScreen(
                            numeroFase: index + 1,
                            titulo: fase['titulo'],
                            emoji: fase['emoji'],
                            cor: cor,
                            temas: List<String>.from(fase['temas']),
                          ),
                        ),
                      );
                      if (resultado != null) {
                        _aoCompletarFase(index, resultado as int);
                      }
                    }
                  : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  color: desbloqueada ? cor : const Color(0xFF1E2D5A),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: desbloqueada
                      ? [BoxShadow(color: cor.withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 4))]
                      : [],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      desbloqueada ? fase['emoji'] : '🔒',
                      style: TextStyle(fontSize: desbloqueada ? 36 : 28),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Fase ${index + 1}',
                      style: TextStyle(
                        color: desbloqueada ? Colors.white : Colors.white24,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      fase['titulo'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: desbloqueada ? Colors.white70 : Colors.white24,
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (i) {
                        return Text(
                          i < estrelas ? '⭐' : '☆',
                          style: const TextStyle(fontSize: 12),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}