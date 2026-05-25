import 'package:flutter/material.dart';
import 'dados_conteudo.dart';
import 'licao_screen.dart';
import 'boss_screen.dart';

class FasesScreen extends StatefulWidget {
  final Nivel nivel;
  const FasesScreen({super.key, required this.nivel});

  @override
  State<FasesScreen> createState() => _FasesScreenState();
}

class _FasesScreenState extends State<FasesScreen> {
  int _faseAtual = 0;
  Map<int, Map<int, int>> _progresso = {};

  bool _faseCompleta(int faseIndex) {
    final fase = widget.nivel.fases[faseIndex];
    for (int i = 0; i < fase.licoes.length; i++) {
      if ((_progresso[faseIndex]?[i] ?? 0) == 0) return false;
    }
    return true;
  }

  bool _faseDesbloqueada(int faseIndex) {
    if (faseIndex == 0) return true;
    return _faseCompleta(faseIndex - 1);
  }

  bool _bossDesbloqueado() {
    for (int i = 0; i < widget.nivel.fases.length; i++) {
      if (!_faseCompleta(i)) return false;
    }
    return true;
  }

  final List<Color> _cores = [
    const Color(0xFF1A73E8),
    const Color(0xFF7B2FBE),
    const Color(0xFF34A853),
    const Color(0xFFF9A825),
    const Color(0xFFE53935),
  ];

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
        title: Text(
          '${widget.nivel.emoji} Nível ${widget.nivel.numero} — ${widget.nivel.titulo}',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Fases
          ...List.generate(widget.nivel.fases.length, (faseIndex) {
            final fase = widget.nivel.fases[faseIndex];
            final desbloqueada = _faseDesbloqueada(faseIndex);
            final completa = _faseCompleta(faseIndex);
            final cor = _cores[faseIndex % _cores.length];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header da fase
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    children: [
                      Text(
                        desbloqueada ? fase.emoji : '🔒',
                        style: const TextStyle(fontSize: 28),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Fase ${fase.numero} — ${fase.titulo}',
                            style: TextStyle(
                              color: desbloqueada ? Colors.white : Colors.white38,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            fase.descricao,
                            style: TextStyle(
                              color: desbloqueada ? Colors.white54 : Colors.white24,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      if (completa)
                        const Text('✅', style: TextStyle(fontSize: 20)),
                    ],
                  ),
                ),

                // Lições da fase
                ...List.generate(fase.licoes.length, (licaoIndex) {
                  final licao = fase.licoes[licaoIndex];
                  final licaoDesbloqueada = desbloqueada &&
                      (licaoIndex == 0 ||
                          (_progresso[faseIndex]?[licaoIndex - 1] ?? 0) > 0);
                  final estrelas = _progresso[faseIndex]?[licaoIndex] ?? 0;

                  return GestureDetector(
                    onTap: licaoDesbloqueada
                        ? () async {
                            final resultado = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => LicaoScreen(
                                  licao: licao,
                                  cor: cor,
                                  faseEmoji: fase.emoji,
                                  faseTitulo: fase.titulo,
                                ),
                              ),
                            );
                            if (resultado != null) {
                              setState(() {
                                _progresso[faseIndex] ??= {};
                                if ((resultado as int) >
                                    (_progresso[faseIndex]![licaoIndex] ?? 0)) {
                                  _progresso[faseIndex]![licaoIndex] = resultado;
                                }
                              });
                            }
                          }
                        : null,
                    child: Container(
                      margin: const EdgeInsets.only(left: 20, bottom: 10),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: licaoDesbloqueada ? cor : const Color(0xFF1E2D5A),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: licaoDesbloqueada
                            ? [BoxShadow(color: cor.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))]
                            : [],
                      ),
                      child: Row(
                        children: [
                          Text(
                            licaoDesbloqueada ? '📖' : '🔒',
                            style: const TextStyle(fontSize: 28),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Lição ${licaoIndex + 1} — ${licao.titulo}',
                                  style: TextStyle(
                                    color: licaoDesbloqueada ? Colors.white : Colors.white38,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${licao.palavrasNovas.length} palavras novas',
                                  style: TextStyle(
                                    color: licaoDesbloqueada ? Colors.white70 : Colors.white24,
                                    fontSize: 12,
                                  ),
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
                    ),
                  );
                }),

                const SizedBox(height: 8),
              ],
            );
          }),

          // Boss do nível
          const Divider(color: Colors.white12, height: 32),
          GestureDetector(
            onTap: _bossDesbloqueado()
                ? () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BossScreen(nivel: widget.nivel),
                      ),
                    )
                : null,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: _bossDesbloqueado()
                    ? const LinearGradient(
                        colors: [Color(0xFFF9A825), Color(0xFFE53935)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: _bossDesbloqueado() ? null : const Color(0xFF1E2D5A),
                borderRadius: BorderRadius.circular(24),
                boxShadow: _bossDesbloqueado()
                    ? [const BoxShadow(color: Color(0x66F9A825), blurRadius: 16, offset: Offset(0, 6))]
                    : [],
              ),
              child: Row(
                children: [
                  Text(
                    _bossDesbloqueado() ? '🏆' : '🔒',
                    style: const TextStyle(fontSize: 48),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Boss do Nível ${widget.nivel.numero}',
                          style: TextStyle(
                            color: _bossDesbloqueado() ? Colors.white : Colors.white24,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Vídeo Noah + Quiz Geral',
                          style: TextStyle(
                            color: _bossDesbloqueado() ? Colors.white : Colors.white38,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _bossDesbloqueado()
                              ? 'Complete todas as fases para desbloquear!'
                              : 'Complete todas as fases para desbloquear!',
                          style: TextStyle(
                            color: _bossDesbloqueado() ? Colors.white70 : Colors.white24,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}