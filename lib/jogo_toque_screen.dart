import 'package:flutter/material.dart';
import 'dados_conteudo.dart';

class JogoToqueScreen extends StatefulWidget {
  final List<Palavra> palavras;
  final Color cor;
  final String titulo;

  const JogoToqueScreen({
    super.key,
    required this.palavras,
    required this.cor,
    required this.titulo,
  });

  @override
  State<JogoToqueScreen> createState() => _JogoToqueScreenState();
}

class _JogoToqueScreenState extends State<JogoToqueScreen>
    with SingleTickerProviderStateMixin {
  int _rodadaAtual = 0;
  int _acertos = 0;
  int _erros = 0;
  String? _respostaSelecionada;
  bool _respondido = false;
  late AnimationController _animController;
  late Animation<double> _scaleAnim;
  late List<_Rodada> _rodadas;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.elasticOut,
    );
    _animController.value = 1.0;
    _gerarRodadas();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _gerarRodadas() {
    final palavras = widget.palavras.toList()..shuffle();
    _rodadas = palavras.map((palavra) {
      final outras = widget.palavras
          .where((p) => p.ingles != palavra.ingles)
          .toList()
        ..shuffle();
      final opcoes = [palavra, ...outras.take(3).toList()]..shuffle();
      return _Rodada(palavraCorreta: palavra, opcoes: opcoes);
    }).toList();
  }

  void _responder(Palavra opcao) {
    if (_respondido) return;
    final correta = _rodadas[_rodadaAtual].palavraCorreta;
    setState(() {
      _respostaSelecionada = opcao.ingles;
      _respondido = true;
      if (opcao.ingles == correta.ingles) {
        _acertos++;
      } else {
        _erros++;
      }
    });
  }

  Future<void> _proxima() async {
    await _animController.reverse();
    setState(() {
      if (_rodadaAtual < _rodadas.length - 1) {
        _rodadaAtual++;
        _respostaSelecionada = null;
        _respondido = false;
      } else {
        _mostrarResultado();
        return;
      }
    });
    _animController.forward();
  }

  void _mostrarResultado() {
    final total = _rodadas.length;
    String estrelas;
    if (_acertos == total) {
      estrelas = '⭐⭐⭐';
    } else if (_acertos >= total * 0.7) {
      estrelas = '⭐⭐';
    } else {
      estrelas = '⭐';
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1E2D5A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _acertos == total ? '🏆' : _acertos >= total * 0.7 ? '🥈' : '💪',
              style: const TextStyle(fontSize: 64),
            ),
            const SizedBox(height: 12),
            Text(
              _acertos == total
                  ? 'PERFEITO!'
                  : _acertos >= total * 0.7
                      ? 'MUITO BOM!'
                      : 'CONTINUE ASSIM!',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '$_acertos de $total acertos',
              style: const TextStyle(color: Color(0xFF8BB4F8), fontSize: 16),
            ),
            const SizedBox(height: 12),
            Text(estrelas, style: const TextStyle(fontSize: 36)),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF34A853),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context, true);
                },
                child: const Text('Continuar! 🚀',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _rodadaAtual = 0;
                  _acertos = 0;
                  _erros = 0;
                  _respostaSelecionada = null;
                  _respondido = false;
                  _gerarRodadas();
                });
              },
              child: const Text('Jogar de novo',
                  style: TextStyle(color: Color(0xFF8BB4F8))),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rodada = _rodadas[_rodadaAtual];
    final correta = rodada.palavraCorreta;
    final progresso = (_rodadaAtual + 1) / _rodadas.length;

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
          '👆 ${widget.titulo}',
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text('✅ $_acertos  ❌ $_erros',
                  style: const TextStyle(color: Colors.white, fontSize: 14)),
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            children: [
              // Barra de progresso
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: progresso,
                  backgroundColor: const Color(0xFF1E2D5A),
                  valueColor: AlwaysStoppedAnimation(widget.cor),
                  minHeight: 10,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Rodada ${_rodadaAtual + 1} de ${_rodadas.length}',
                style: const TextStyle(color: Color(0xFF8BB4F8), fontSize: 14),
              ),
              const SizedBox(height: 16),

              // Pergunta
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: widget.cor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: widget.cor.withOpacity(0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      '🔊 Toque na imagem correta!',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      correta.ingles,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '/${correta.pronuncia}/',
                      style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),

              // Feedback
              if (_respondido)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _respostaSelecionada == correta.ingles
                        ? const Color(0xFF1B5E20)
                        : const Color(0xFF7F0000),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _respostaSelecionada == correta.ingles
                        ? "${MensagensNoah.acerto[_acertos % MensagensNoah.acerto.length]}\n${MensagensNoah.acertoTrad[_acertos % MensagensNoah.acertoTrad.length]}"
                        : "${MensagensNoah.erro[_erros % MensagensNoah.erro.length]}\n${MensagensNoah.erroTrad[_erros % MensagensNoah.erroTrad.length]}",
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ),

              const SizedBox(height: 12),

              // Grade de opções
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: rodada.opcoes.map((opcao) {
                    Color corFundo = const Color(0xFF1E2D5A);
                    if (_respondido) {
                      if (opcao.ingles == correta.ingles) {
                        corFundo = const Color(0xFF34A853);
                      } else if (opcao.ingles == _respostaSelecionada) {
                        corFundo = const Color(0xFFE53935);
                      }
                    }

                    return GestureDetector(
                      onTap: _respondido ? null : () => _responder(opcao),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color: corFundo,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _respostaSelecionada == opcao.ingles
                                ? Colors.white
                                : Colors.transparent,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: corFundo.withOpacity(0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(opcao.emoji,
                                style: const TextStyle(fontSize: 44)),
                            const SizedBox(height: 6),
                            Text(
                              opcao.portugues,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              // Botão próxima
              if (_respondido)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.cor,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: _proxima,
                      child: Text(
                        _rodadaAtual < _rodadas.length - 1
                            ? 'Próxima →'
                            : 'Ver resultado! 🌟',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      ),
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

class _Rodada {
  final Palavra palavraCorreta;
  final List<Palavra> opcoes;

  _Rodada({required this.palavraCorreta, required this.opcoes});
}