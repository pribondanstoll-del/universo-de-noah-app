import 'perfil_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dados_conteudo.dart';
import 'progresso_service.dart';
import 'pin_screen.dart';

class PaisScreen extends StatefulWidget {
  const PaisScreen({super.key});

  @override
  State<PaisScreen> createState() => _PaisScreenState();
}

class _PaisScreenState extends State<PaisScreen> {
  String _nome = '';
  String _avatar = '🦁';
  Map<int, Map<int, int>> _progresso = {};
  bool _carregando = true;
  bool _pinVerificado = false;

  @override
  void initState() {
    super.initState();
    _verificarPin();
  }

  Future<void> _verificarPin() async {
    final prefs = await SharedPreferences.getInstance();
    final pinSalvo = prefs.getString('pin_pais') ?? '';

    if (pinSalvo.isEmpty) {
      // Ainda não tem PIN — pede para criar
      final resultado = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const PinScreen(configurando: true),
        ),
      );
      if (resultado == true) {
        setState(() => _pinVerificado = true);
        _carregarDados();
      } else {
        if (mounted) Navigator.pop(context);
      }
    } else {
      // Já tem PIN — pede para verificar
      final resultado = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const PinScreen(configurando: false),
        ),
      );
      if (resultado == true) {
        setState(() => _pinVerificado = true);
        _carregarDados();
      } else {
        if (mounted) Navigator.pop(context);
      }
    }
  }

  Future<void> _carregarDados() async {
    final prefs = await SharedPreferences.getInstance();
    final progresso = await ProgressoService.buscarProgressoNivel(1);
    setState(() {
      _nome = prefs.getString('nome_crianca') ?? 'Explorador';
      _avatar = prefs.getString('avatar_crianca') ?? '🦁';
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

  int _totalLicoes() {
    int total = 0;
    for (final fase in _progresso.values) {
      for (final estrelas in fase.values) {
        if (estrelas > 0) total++;
      }
    }
    return total;
  }

  int _totalFases() {
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

  int _totalLicoesApp() {
    int total = 0;
    for (final fase in nivel1.fases) {
      total += fase.licoes.length;
    }
    return total;
  }

  double _percentualGeral() {
    final total = _totalLicoesApp();
    if (total == 0) return 0;
    return _totalLicoes() / total;
  }

  @override
  Widget build(BuildContext context) {
    if (!_pinVerificado || _carregando) {
      return const Scaffold(
        backgroundColor: Color(0xFF0D1B4B),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF8BB4F8)),
        ),
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
        title: const Text(
          '👨‍👩‍👧 Painel dos Pais',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Perfil da criança
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1A73E8),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1A73E8).withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(_avatar, style: const TextStyle(fontSize: 40)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _nome,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'Explorador do Universo de Noah',
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Nível 1 — Primeiros Passos 🌱',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Progresso geral
          const Text(
            'Progresso Geral',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1E2D5A),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _statCard('⭐', '${_totalEstrelas()}', 'Estrelas'),
                    _statCard('📖', '${_totalLicoes()}/${_totalLicoesApp()}', 'Lições'),
                    _statCard('🏆', '${_totalFases()}/${nivel1.fases.length}', 'Fases'),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Conclusão do Nível 1',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    Text(
                      '${(_percentualGeral() * 100).toStringAsFixed(0)}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: _percentualGeral(),
                    backgroundColor: const Color(0xFF0D1B4B),
                    valueColor: const AlwaysStoppedAnimation(Color(0xFF34A853)),
                    minHeight: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Detalhes por fase
          const Text(
            'Detalhes por Fase',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
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
            int licoesCompletas = 0;
            int estrelasTotal = 0;
            for (int l = 0; l < fase.licoes.length; l++) {
              final e = _progresso[faseIndex]?[l] ?? 0;
              if (e > 0) licoesCompletas++;
              estrelasTotal += e;
            }
            final percentual = licoesCompletas / fase.licoes.length;

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2D5A),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: licoesCompletas == fase.licoes.length
                      ? cor
                      : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(fase.emoji, style: const TextStyle(fontSize: 24)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Fase ${fase.numero} — ${fase.titulo}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '$licoesCompletas de ${fase.licoes.length} lições • $estrelasTotal ⭐',
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (licoesCompletas == fase.licoes.length)
                        const Text('✅', style: TextStyle(fontSize: 20)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: percentual,
                      backgroundColor: const Color(0xFF0D1B4B),
                      valueColor: AlwaysStoppedAnimation(cor),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 24),

          // Configurações
          const Text(
            'Configurações',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1E2D5A),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                _itemConfig(
                  icone: '🔒',
                  titulo: 'Alterar PIN',
                  subtitulo: 'Mude o PIN do painel dos pais',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PinScreen(configurando: true),
                    ),
                  ),
                ),
                const Divider(color: Colors.white12, height: 1),
               _itemConfig(
  icone: '👤',
  titulo: 'Perfil da criança',
  subtitulo: 'Editar nome e avatar',
  onTap: () async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PerfilScreen()),
    );
    _carregarDados();
  },
), 
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Dica para os pais
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1E2D5A),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFF9A825), width: 1),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '💡 Dica para os pais',
                  style: TextStyle(
                    color: Color(0xFFF9A825),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Sessões de 15 a 20 minutos por dia são ideais para crianças de 3 a 9 anos. '
                  'Evite sessões longas — o cérebro infantil aprende melhor em blocos curtos e frequentes. '
                  'Celebre cada conquista junto com seu filho! 🎉',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _itemConfig({
    required String icone,
    required String titulo,
    required String subtitulo,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Text(icone, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(titulo,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold)),
                  Text(subtitulo,
                      style: const TextStyle(
                          color: Colors.white54, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios,
                color: Colors.white38, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String emoji, String valor, String label) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 28)),
        const SizedBox(height: 4),
        Text(
          valor,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Color(0xFF8BB4F8), fontSize: 12),
        ),
      ],
    );
  }
}