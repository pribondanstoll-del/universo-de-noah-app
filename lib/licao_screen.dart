import 'package:flutter/material.dart';
import 'dados_conteudo.dart';
import 'jogo_memoria_screen.dart';
import 'jogo_toque_screen.dart';

enum EtapaLicao { revisao, apresentacao, minijogo, quiz, recompensa }

class LicaoScreen extends StatefulWidget {
  final Licao licao;
  final Color cor;
  final String faseEmoji;
  final String faseTitulo;

  const LicaoScreen({
    super.key,
    required this.licao,
    required this.cor,
    required this.faseEmoji,
    required this.faseTitulo,
  });

  @override
  State<LicaoScreen> createState() => _LicaoScreenState();
}

class _LicaoScreenState extends State<LicaoScreen>
    with SingleTickerProviderStateMixin {
  EtapaLicao _etapa = EtapaLicao.revisao;
  int _indexAtual = 0;
  int _pontos = 0;
  String? _respostaSelecionada;
  bool _respondido = false;
  int _errosConsecutivos = 0;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeIn);
    _animController.forward();

    if (widget.licao.primeiraLicao || widget.licao.palavrasRevisao.isEmpty) {
      _etapa = EtapaLicao.apresentacao;
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  String _mensagemAcerto() {
    final msgs = MensagensNoah.acerto;
    final trads = MensagensNoah.acertoTrad;
    final idx = _pontos % msgs.length;
    return '${msgs[idx]}\n${trads[idx]}';
  }

  String _mensagemErro() {
    final msgs = MensagensNoah.erro;
    final trads = MensagensNoah.erroTrad;
    final idx = _errosConsecutivos.clamp(0, msgs.length - 1);
    return '${msgs[idx]}\n${trads[idx]}';
  }

  Future<void> _avancar() async {
    await _animController.reverse();
    setState(() {
      _indexAtual++;
      _respostaSelecionada = null;
      _respondido = false;
    });
    _animController.forward();
  }

  void _proximaEtapa() {
    setState(() {
      _indexAtual = 0;
      _respostaSelecionada = null;
      _respondido = false;
      switch (_etapa) {
        case EtapaLicao.revisao:
          _etapa = EtapaLicao.apresentacao;
          break;
        case EtapaLicao.apresentacao:
          _etapa = EtapaLicao.minijogo;
          break;
        case EtapaLicao.minijogo:
          _etapa = EtapaLicao.quiz;
          break;
        case EtapaLicao.quiz:
          _etapa = EtapaLicao.recompensa;
          break;
        case EtapaLicao.recompensa:
          break;
      }
    });
    _animController.forward();
  }

  void _reiniciarLicao() {
    setState(() {
      _etapa = EtapaLicao.apresentacao;
      _indexAtual = 0;
      _pontos = 0;
      _respostaSelecionada = null;
      _respondido = false;
      _errosConsecutivos = 0;
    });
  }

  int _calcularEstrelas() {
    final total = widget.licao.quiz.length;
    if (_pontos == total) return 3;
    if (_pontos >= (total * 0.7).ceil()) return 2;
    if (_pontos >= (total * 0.4).ceil()) return 1;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    switch (_etapa) {
      case EtapaLicao.revisao:
        return _telaRevisao();
      case EtapaLicao.apresentacao:
        return _telaApresentacao();
      case EtapaLicao.minijogo:
        return _telaMiniJogo();
      case EtapaLicao.quiz:
        return _telaQuiz();
      case EtapaLicao.recompensa:
        return _telaRecompensa();
    }
  }

  Widget _telaRevisao() {
    final palavras = widget.licao.palavrasRevisao;
    if (_indexAtual >= palavras.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _proximaEtapa());
      return const SizedBox();
    }
    final palavra = palavras[_indexAtual];
    final revisaoMsg = MensagensNoah.revisao[_indexAtual % MensagensNoah.revisao.length];
    final revisaoTrad = MensagensNoah.revisaoTrad[_indexAtual % MensagensNoah.revisaoTrad.length];

    return _scaffoldBase(
      titulo: '⚡ Revisão Relâmpago',
      body: FadeTransition(
        opacity: _fadeAnim,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E2D5A),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(revisaoMsg,
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center),
                    Text(revisaoTrad,
                        style: const TextStyle(color: Color(0xFF8BB4F8), fontSize: 13),
                        textAlign: TextAlign.center),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: widget.cor,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [BoxShadow(color: widget.cor.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 8))],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(palavra.emoji, style: const TextStyle(fontSize: 80)),
                      const SizedBox(height: 16),
                      Text(palavra.ingles,
                          style: const TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(palavra.portugues,
                            style: const TextStyle(color: Colors.white, fontSize: 22)),
                      ),
                      const SizedBox(height: 8),
                      Text('🔊 ${palavra.pronuncia}',
                          style: const TextStyle(color: Colors.white60, fontSize: 14)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _botaoAvancar('Próxima →', _avancar),
            ],
          ),
        ),
      ),
    );
  }

  Widget _telaApresentacao() {
    final palavras = widget.licao.palavrasNovas;
    if (_indexAtual >= palavras.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _proximaEtapa());
      return const SizedBox();
    }
    final palavra = palavras[_indexAtual];
    final progresso = (_indexAtual + 1) / palavras.length;

    return _scaffoldBase(
      titulo: '📖 Palavras Novas',
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _barraProgresso(progresso),
            const SizedBox(height: 8),
            Text('Palavra ${_indexAtual + 1} de ${palavras.length}',
                style: const TextStyle(color: Color(0xFF8BB4F8), fontSize: 14)),
            const SizedBox(height: 24),
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnim,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: widget.cor,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [BoxShadow(color: widget.cor.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 8))],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(palavra.emoji, style: const TextStyle(fontSize: 80)),
                      const SizedBox(height: 16),
                      Text(palavra.ingles,
                          style: const TextStyle(color: Colors.white, fontSize: 44, fontWeight: FontWeight.bold, letterSpacing: 2)),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(palavra.portugues,
                            style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w500)),
                      ),
                      const SizedBox(height: 12),
                      Text('🔊 ${palavra.pronuncia}',
                          style: const TextStyle(color: Colors.white70, fontSize: 15)),
                      const SizedBox(height: 8),
                      const Text('Toque para ouvir',
                          style: TextStyle(color: Colors.white54, fontSize: 13)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
SafeArea(
  top: false,
  child: _botaoAvancar(
    _indexAtual < palavras.length - 1 ? 'Próxima palavra →' : 'Vamos praticar! 🎮',
    _avancar,
  ),
),
          ],
        ),
      ),
    );
  }

  Widget _telaMiniJogo() {
    final jogos = widget.licao.miniJogos;
    if (_indexAtual >= jogos.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _proximaEtapa());
      return const SizedBox();
    }
    final jogo = jogos[_indexAtual];

    return _scaffoldBase(
      titulo: '🎮 Mini-Jogo',
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text('Jogo ${_indexAtual + 1} de ${jogos.length}',
                style: const TextStyle(color: Color(0xFF8BB4F8), fontSize: 14)),
            const SizedBox(height: 24),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E2D5A),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: widget.cor.withOpacity(0.4), width: 2),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(jogo.emoji, style: const TextStyle(fontSize: 72)),
                    const SizedBox(height: 20),
                    Text(jogo.titulo,
                        style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(jogo.descricao,
                          style: const TextStyle(color: Color(0xFF8BB4F8), fontSize: 16),
                          textAlign: TextAlign.center),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (jogo.tipo == 'memoria')
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.cor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => JogoMemoriaScreen(
                          palavras: widget.licao.palavrasNovas,
                          cor: widget.cor,
                          titulo: jogo.titulo,
                        ),
                      ),
                    );
                    _avancar();
                  },
                  child: const Text('🃏 Jogar Memória!',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold)),
                ),
              )
            else if (jogo.tipo == 'toque')
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.cor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => JogoToqueScreen(
                          palavras: widget.licao.palavrasNovas,
                          cor: widget.cor,
                          titulo: jogo.titulo,
                        ),
                      ),
                    );
                    _avancar();
                  },
                  child: const Text('👆 Jogar Toque!',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold)),
                ),
              )
            else
              _botaoAvancar(
                _indexAtual < jogos.length - 1 ? 'Próximo jogo →' : 'Ir para o Quiz! 📝',
                _avancar,
              ),
          ],
        ),
      ),
    );
  }

  Widget _telaQuiz() {
    final perguntas = widget.licao.quiz;
    if (_indexAtual >= perguntas.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _proximaEtapa());
      return const SizedBox();
    }
    final pergunta = perguntas[_indexAtual];
    final progresso = (_indexAtual + 1) / perguntas.length;
    final opcoes = ['a', 'b', 'c', 'd'].map((k) => pergunta[k]!).toList();

    return _scaffoldBase(
      titulo: '📝 Quiz',
      acoes: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Center(
            child: Text('⭐ $_pontos',
                style: const TextStyle(color: Colors.white, fontSize: 18)),
          ),
        ),
      ],
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _barraProgresso(progresso),
            const SizedBox(height: 8),
            Text('Pergunta ${_indexAtual + 1} de ${perguntas.length}',
                style: const TextStyle(color: Color(0xFF8BB4F8), fontSize: 14)),
            const SizedBox(height: 16),
            if (_respondido)
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _respostaSelecionada == pergunta['resposta']
                      ? const Color(0xFF1B5E20)
                      : const Color(0xFF7F0000),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  _respostaSelecionada == pergunta['resposta']
                      ? _mensagemAcerto()
                      : _mensagemErro(),
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2D5A),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: widget.cor.withOpacity(0.3), width: 2),
              ),
              child: Text(pergunta['pergunta']!,
                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
            ),
            const SizedBox(height: 16),
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
                    onTap: _respondido ? null : () {
                      setState(() {
                        _respostaSelecionada = opcao;
                        _respondido = true;
                        if (opcao == pergunta['resposta']) {
                          _pontos++;
                          _errosConsecutivos = 0;
                        } else {
                          _errosConsecutivos++;
                        }
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        color: corFundo,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _respostaSelecionada == opcao
                              ? Colors.white
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(opcao,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            if (_respondido)
              _botaoAvancar(
                _indexAtual < perguntas.length - 1 ? 'Próxima →' : 'Ver resultado! 🌟',
                _avancar,
              ),
          ],
        ),
      ),
    );
  }

  Widget _telaRecompensa() {
    final estrelas = _calcularEstrelas();
    final aprovado = estrelas >= 2;

    return _scaffoldBase(
      titulo: '🏆 Resultado',
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                aprovado ? (estrelas == 3 ? '🏆' : '🥈') : '💪',
                style: const TextStyle(fontSize: 80),
              ),
              const SizedBox(height: 16),
              Text(
                aprovado
                    ? (estrelas == 3 ? 'INCRÍVEL!' : 'MUITO BOM!')
                    : 'VAMOS TENTAR DE NOVO!',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5),
              ),
              const SizedBox(height: 8),
              Text(
                aprovado
                    ? "Lesson complete! You're incredible! 🏆\nLição completa! Você é incrível!"
                    : "Don't give up! Noah believes in you! 🌟\nNão desista! Noah acredita em você!\n\nVamos repetir para aprender melhor! 💪",
                style: const TextStyle(color: Color(0xFF8BB4F8), fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (i) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Text(i < estrelas ? '⭐' : '☆',
                      style: const TextStyle(fontSize: 40)),
                )),
              ),
              const SizedBox(height: 8),
              Text('$_pontos de ${widget.licao.quiz.length} acertos',
                  style: const TextStyle(color: Color(0xFF8BB4F8), fontSize: 16)),
              const SizedBox(height: 32),
              if (aprovado)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF34A853),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: () => Navigator.pop(context, estrelas),
                    child: const Text('Próxima lição! 🚀',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              if (!aprovado)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF9A825),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: _reiniciarLicao,
                    child: const Text('Vamos tentar de novo! 💪',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _scaffoldBase({
    required String titulo,
    required Widget body,
    List<Widget>? acoes,
  }) {
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
          '${widget.faseEmoji} ${widget.faseTitulo} — ${widget.licao.titulo}',
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
        ),
        actions: acoes,
      ),
      body: SafeArea(top: false, child: body),
    );
  }

  Widget _barraProgresso(double valor) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: LinearProgressIndicator(
        value: valor,
        backgroundColor: const Color(0xFF1E2D5A),
        valueColor: AlwaysStoppedAnimation(widget.cor),
        minHeight: 10,
      ),
    );
  }

  Widget _botaoAvancar(String texto, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.cor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        onPressed: onTap,
        child: Text(texto,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold)),
      ),
    );
  }
}