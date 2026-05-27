import 'package:flutter/material.dart';
import 'dados_conteudo.dart';
import 'progresso_service.dart';

class ProgressoScreen extends StatefulWidget {
  const ProgressoScreen({super.key});

  @override
  State<ProgressoScreen> createState() => _ProgressoScreenState();
}

class _ProgressoScreenState extends State<ProgressoScreen> {
  Map<int, Map<int, int>> _progresso = {};
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarProgresso();
  }

  Future<void> _carregarProgresso() async {
    final progresso = await ProgressoService.buscarProgressoNivel(1);
    setState(() {
      _progresso = progresso;
      _carregando = false;
    });
  }

  int _totalEstrelas() {
    int total = 0;
    for (final fase in _progresso.values) {
      for (final estrelas in fase.values) {
        total += estrelas;
      }
    }
    return total;
  }

  int _totalLicoesCompletas() {
    int total = 0;
    for (final fase in _progresso.values) {
      for (final estrelas in fase.values) {
        if (estrelas > 0) total++;
      }
    }
    return total;
  }

  int _totalFasesCompletas() {
    int total = 0;
    for (int f = 0; f < nivel1.fases.length; f++) {
      final fase = nivel1.fases[f];
      bool completa = true;
      for (int l = 0; l < fase.licoes.length; l++) {
        if ((_progresso[f]?[l] ?? 0) == 0) {
          completa = false;
          break;
        }
      }
      if (completa) total++;
    }
    return total;
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
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1B4B),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('⭐ Meu Progresso',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Cards de resumo
          Row(
            children: [
              Expanded(child: _cardResumo('⭐', '${_totalEstrelas()}', 'Estrelas')),
              const SizedBox(width: 12),
              Expanded(child: _cardResumo('📖', '${_totalLicoesCompletas()}', 'Lições')),
              const SizedBox(width: 12),
              Expanded(child: _cardResumo('🏆', '${_totalFasesCompletas()}', 'Fases')),
            ],
          ),
          const SizedBox(height: 24),

          // Progresso por fase
          const Text('Detalhes por fase',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          ...List.generate(nivel1.fases.length, (faseIndex) {
            final fase = nivel1.fases[faseIndex];
            final cores = [
              const Color(0xFF1A73E8),
              const Color(0xFF7B2FBE),
              const Color(0xFF34A853),
              const Color(0xFFF9A825),
              const Color(0xFFE53935),
            ];
            final cor = cores[faseIndex % cores.length];

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2D5A),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  // Header da fase
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cor,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: Row(
                      children: [
                        Text(fase.emoji, style: const TextStyle(fontSize: 28)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Fase ${fase.numero} — ${fase.titulo}',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Lições
                  ...List.generate(fase.licoes.length, (licaoIndex) {
                    final licao = fase.licoes[licaoIndex];
                    final estrelas = _progresso[faseIndex]?[licaoIndex] ?? 0;
                    final completa = estrelas > 0;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Row(
                        children: [
                          Text(completa ? '✅' : '⭕',
                              style: const TextStyle(fontSize: 20)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Lição ${licaoIndex + 1} — ${licao.titulo}',
                                  style: TextStyle(
                                    color: completa ? Colors.white : Colors.white38,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${licao.palavrasNovas.length} palavras',
                                  style: const TextStyle(
                                      color: Colors.white38, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: List.generate(3, (i) => Text(
                              i < estrelas ? '⭐' : '☆',
                              style: const TextStyle(fontSize: 16),
                            )),
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 8),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _cardResumo(String emoji, String valor, String label) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2D5A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 4),
          Text(valor,
              style: const TextStyle(
                  color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          Text(label,
              style: const TextStyle(color: Color(0xFF8BB4F8), fontSize: 12)),
        ],
      ),
    );
  }
}