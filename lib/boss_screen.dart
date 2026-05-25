import 'package:flutter/material.dart';
import 'dados_conteudo.dart';

class BossScreen extends StatefulWidget {
  final Nivel nivel;
  const BossScreen({super.key, required this.nivel});

  @override
  State<BossScreen> createState() => _BossScreenState();
}

class _BossScreenState extends State<BossScreen>
    with SingleTickerProviderStateMixin {
  int _etapa = 0; // 0=video, 1=quiz, 2=celebracao
  int _indexAtual = 0;
  int _pontos = 0;
  String? _respostaSelecionada;
  bool _respondido = false;
  late AnimationController _animController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.elasticOut,
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _responder(String opcao) {
    if (_respondido) return;
    setState(() {
      _respostaSelecionada = opcao;
      _respondido = true;
      if (opcao == widget.nivel.quizBoss[_indexAtual]['resposta']) {
        _pontos++;
      }
    });
  }

  void _proximo() {
    if (_indexAtual < widget.nivel.quizBoss.length - 1) {
      setState(() {
        _indexAtual++;
        _respostaSelecionada = null;
        _respondido = false;
      });
    } else {
      setState(() => _etapa = 2);
      _animController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (_etapa) {
      case 0:
        return _telaVideo();
      case 1:
        return _telaQuiz();
      case 2:
        return _telaCelebracao();
      default:
        return _telaVideo();
    }
  }

  // ============================================================
  // ETAPA 1 — VÍDEO DO NOAH
  // ============================================================
  Widget _telaVideo() {
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
          '🏆 Boss — Nível ${widget.nivel.numero}',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFF9A825), Color(0xFFE53935)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Text('🏆', style: TextStyle(fontSize: 40)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Boss do Nível ${widget.nivel.numero}',
                          style: const TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                        Text(
                          widget.nivel.titulo,
                          style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Vídeo placeholder
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E2D5A),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFF9A825), width: 2),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('🎬', style: TextStyle(fontSize: 72)),
                    const SizedBox(height: 16),
                    const Text(
                      'Vídeo Especial do Noah',
                      style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        'Aqui entrará o vídeo do canal\nUniverso de Noah resumindo\ntudo que você aprendeu! 🌟',
                        style: const TextStyle(color: Color(0xFF8BB4F8), fontSize: 15),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9A825).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFF9A825)),
                      ),
                      child: const Text(
                        '📹 Vídeo em produção',
                        style: TextStyle(color: Color(0xFFF9A825), fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Botão
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF9A825),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: () => setState(() => _etapa = 1),
                child: const Text(
                  'Ir para o Quiz Final! 📝',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ETAPA 2 — QUIZ GERAL
  // ============================================================
  Widget _telaQuiz() {
    final pergunta = widget.nivel.quizBoss[_indexAtual];
    final progresso = (_indexAtual + 1) / widget.nivel.quizBoss.length;
    final opcoes = ['a', 'b', 'c', 'd'].map((k) => pergunta[k]!).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0D1B4B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1B4B),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => setState(() => _etapa = 0),
        ),
        title: const Text('📝 Quiz Final do Nível',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text('⭐ $_pontos',
                  style: const TextStyle(color: Colors.white, fontSize: 18)),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progresso,
                backgroundColor: const Color(0xFF1E2D5A),
                valueColor: const AlwaysStoppedAnimation(Color(0xFFF9A825)),
                minHeight: 10,
              ),
            ),
            const SizedBox(height: 8),
            Text('Pergunta ${_indexAtual + 1} de ${widget.nivel.quizBoss.length}',
                style: const TextStyle(color: Color(0xFF8BB4F8), fontSize: 14)),
            const SizedBox(height: 24),

            // Feedback
            if (_respondido)
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _respostaSelecionada == pergunta['resposta']
                      ? const Color(0xFF1B5E20)
                      : const Color(0xFF7F0000),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  _respostaSelecionada == pergunta['resposta']
                      ? "You're on fire! 🔥\nVocê está arrasando!"
                      : "Almost! So close! 🎯\nQuase! Tão pertinho!",
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),

            // Pergunta
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2D5A),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFF9A825).withOpacity(0.3), width: 2),
              ),
              child: Text(pergunta['pergunta']!,
                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
            ),
            const SizedBox(height: 20),

            // Opções
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.8,
                children: opcoes.map((opcao) {
                  Color corFundo = const Color(0xFF1E2D5A);
                  if (_respondido) {
                    if (opcao == pergunta['resposta']) {
                      corFundo = const Color(0xFF34A853);
                    } else if (opcao == _respostaSelecionada) {
                      corFundo = const Color(0xFFE53935);
                    }
                  }
                  return GestureDetector(
                    onTap: _respondido ? null : () => _responder(opcao),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        color: corFundo,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _respostaSelecionada == opcao ? Colors.white : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(opcao,
                            style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            if (_respondido)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF9A825),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: _proximo,
                  child: Text(
                    _indexAtual < widget.nivel.quizBoss.length - 1
                        ? 'Próxima →'
                        : 'Ver resultado! 🌟',
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ETAPA 3 — CELEBRAÇÃO FINAL
  // ============================================================
  Widget _telaCelebracao() {
    final total = widget.nivel.quizBoss.length;
    final percentual = _pontos / total;

    return Scaffold(
      backgroundColor: const Color(0xFF0D1B4B),
      body: Center(
        child: ScaleTransition(
          scale: _scaleAnim,
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('🎊', style: TextStyle(fontSize: 40)),
                const SizedBox(height: 16),
                const Text('👑', style: TextStyle(fontSize: 80)),
                const SizedBox(height: 16),
                const Text(
                  'NÍVEL COMPLETO!',
                  style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 2),
                ),
                const SizedBox(height: 8),
                Text(
                  'The Noah Universe is proud of you! 🌟\nO Universo de Noah está orgulhoso de você!',
                  style: const TextStyle(color: Color(0xFF8BB4F8), fontSize: 15),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Medalha
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFF9A825), Color(0xFFE53935)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(color: Color(0x66F9A825), blurRadius: 20, spreadRadius: 4),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text('🏅', style: TextStyle(fontSize: 48)),
                      const SizedBox(height: 8),
                      const Text('Medalha Desbloqueada!',
                          style: TextStyle(color: Colors.white70, fontSize: 13)),
                      Text(
                        widget.nivel.medalha,
                        style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '$_pontos de $total acertos no quiz final',
                  style: const TextStyle(color: Color(0xFF8BB4F8), fontSize: 15),
                ),
                const SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF34A853),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Continuar a aventura! 🚀',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}