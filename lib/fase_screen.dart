import 'package:flutter/material.dart';

class FaseScreen extends StatefulWidget {
  final int numeroFase;
  final String titulo;
  final String emoji;
  final Color cor;
  final List<String> temas;

  const FaseScreen({
    super.key,
    required this.numeroFase,
    required this.titulo,
    required this.emoji,
    required this.cor,
    required this.temas,
  });

  @override
  State<FaseScreen> createState() => _FaseScreenState();
}

class _FaseScreenState extends State<FaseScreen>
    with SingleTickerProviderStateMixin {
  int _atual = 0;
  int _pontos = 0;
  String? _respostaSelecionada;
  bool _respondido = false;
  bool _mostrandoCelebracao = false;
  late AnimationController _celebracaoController;
  late Animation<double> _celebracaoScale;

  final Map<String, List<Map<String, dynamic>>> _banco = {
    'Saudações': [
      {'pergunta': 'O que significa "Hello"?', 'resposta': 'Olá', 'opcoes': ['Olá', 'Tchau', 'Obrigado', 'Por favor']},
      {'pergunta': 'O que significa "Goodbye"?', 'resposta': 'Tchau', 'opcoes': ['Olá', 'Tchau', 'Desculpe', 'Sim']},
      {'pergunta': 'O que significa "Thank you"?', 'resposta': 'Obrigado', 'opcoes': ['De nada', 'Por favor', 'Obrigado', 'Sim']},
      {'pergunta': 'O que significa "Please"?', 'resposta': 'Por favor', 'opcoes': ['Obrigado', 'Por favor', 'Olá', 'Não']},
    ],
    'Cores': [
      {'pergunta': 'O que significa "Red"?', 'resposta': 'Vermelho', 'opcoes': ['Azul', 'Verde', 'Vermelho', 'Amarelo']},
      {'pergunta': 'O que significa "Blue"?', 'resposta': 'Azul', 'opcoes': ['Azul', 'Verde', 'Vermelho', 'Rosa']},
      {'pergunta': 'O que significa "Green"?', 'resposta': 'Verde', 'opcoes': ['Azul', 'Verde', 'Roxo', 'Laranja']},
      {'pergunta': 'O que significa "Yellow"?', 'resposta': 'Amarelo', 'opcoes': ['Branco', 'Preto', 'Amarelo', 'Rosa']},
    ],
    'Números': [
      {'pergunta': 'O que significa "One"?', 'resposta': 'Um', 'opcoes': ['Um', 'Dois', 'Três', 'Quatro']},
      {'pergunta': 'O que significa "Two"?', 'resposta': 'Dois', 'opcoes': ['Um', 'Dois', 'Cinco', 'Dez']},
      {'pergunta': 'O que significa "Three"?', 'resposta': 'Três', 'opcoes': ['Seis', 'Sete', 'Três', 'Nove']},
      {'pergunta': 'O que significa "Five"?', 'resposta': 'Cinco', 'opcoes': ['Quatro', 'Cinco', 'Oito', 'Dois']},
    ],
    'Animais': [
      {'pergunta': 'O que significa "Cat"?', 'resposta': 'Gato', 'opcoes': ['Gato', 'Cachorro', 'Pássaro', 'Peixe']},
      {'pergunta': 'O que significa "Dog"?', 'resposta': 'Cachorro', 'opcoes': ['Gato', 'Cachorro', 'Coelho', 'Leão']},
      {'pergunta': 'O que significa "Bird"?', 'resposta': 'Pássaro', 'opcoes': ['Peixe', 'Cobra', 'Pássaro', 'Urso']},
      {'pergunta': 'O que significa "Fish"?', 'resposta': 'Peixe', 'opcoes': ['Gato', 'Peixe', 'Tigre', 'Macaco']},
    ],
    'Frutas': [
      {'pergunta': 'O que significa "Apple"?', 'resposta': 'Maçã', 'opcoes': ['Banana', 'Maçã', 'Uva', 'Pera']},
      {'pergunta': 'O que significa "Banana"?', 'resposta': 'Banana', 'opcoes': ['Maçã', 'Banana', 'Laranja', 'Morango']},
      {'pergunta': 'O que significa "Orange"?', 'resposta': 'Laranja', 'opcoes': ['Limão', 'Uva', 'Laranja', 'Abacaxi']},
      {'pergunta': 'O que significa "Grape"?', 'resposta': 'Uva', 'opcoes': ['Uva', 'Pêssego', 'Melão', 'Kiwi']},
    ],
    'Família': [
      {'pergunta': 'O que significa "Mom"?', 'resposta': 'Mãe', 'opcoes': ['Pai', 'Mãe', 'Irmão', 'Avó']},
      {'pergunta': 'O que significa "Dad"?', 'resposta': 'Pai', 'opcoes': ['Mãe', 'Pai', 'Irmã', 'Avô']},
      {'pergunta': 'O que significa "Brother"?', 'resposta': 'Irmão', 'opcoes': ['Irmão', 'Irmã', 'Primo', 'Tio']},
      {'pergunta': 'O que significa "Sister"?', 'resposta': 'Irmã', 'opcoes': ['Irmão', 'Irmã', 'Tia', 'Avó']},
    ],
  };

  late List<Map<String, dynamic>> _perguntas;

  @override
  void initState() {
    super.initState();
    _celebracaoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _celebracaoScale = CurvedAnimation(
      parent: _celebracaoController,
      curve: Curves.elasticOut,
    );
    _gerarPerguntas();
  }

  void _gerarPerguntas() {
    List<Map<String, dynamic>> todasPerguntas = [];
    for (final tema in widget.temas) {
      if (_banco.containsKey(tema)) {
        todasPerguntas.addAll(_banco[tema]!);
      }
    }
    todasPerguntas.shuffle();
    _perguntas = todasPerguntas.take(6).toList();
  }

  @override
  void dispose() {
    _celebracaoController.dispose();
    super.dispose();
  }

  void _responder(String opcao) {
    if (_respondido) return;
    setState(() {
      _respostaSelecionada = opcao;
      _respondido = true;
      if (opcao == _perguntas[_atual]['resposta']) {
        _pontos++;
      }
    });
  }

  void _proximo() {
    if (_atual < _perguntas.length - 1) {
      setState(() {
        _atual++;
        _respostaSelecionada = null;
        _respondido = false;
      });
    } else {
      _mostrarCelebracao();
    }
  }

int _calcularEstrelas() {
    final total = _perguntas.length;
    if (_pontos == total) return 3;
    if (_pontos >= (total * 0.7).ceil()) return 2;
    if (_pontos >= (total * 0.4).ceil()) return 1;
    return 0;
  }

  void _mostrarCelebracao() {
    final estrelas = _calcularEstrelas();
    setState(() => _mostrandoCelebracao = true);
    _celebracaoController.forward();

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black87,
      builder: (_) => ScaleTransition(
        scale: _celebracaoScale,
        child: AlertDialog(
          backgroundColor: const Color(0xFF1E2D5A),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Text(
                estrelas == 3 ? '🏆' : estrelas == 2 ? '🥈' : estrelas == 1 ? '🥉' : '💪',
                style: const TextStyle(fontSize: 72),
              ),
              const SizedBox(height: 16),
              Text(
                estrelas == 3
                    ? 'INCRÍVEL!'
                    : estrelas == 2
                        ? 'MUITO BOM!'
                        : estrelas == 1
                            ? 'CONTINUE ASSIM!'
                            : 'TENTE DE NOVO!',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (i) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      i < estrelas ? '⭐' : '☆',
                      style: const TextStyle(fontSize: 36),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 8),
              Text(
                '$_pontos de ${_perguntas.length} acertos',
                style: const TextStyle(color: Color(0xFF8BB4F8), fontSize: 16),
              ),
              const SizedBox(height: 24),
              if (estrelas > 0)
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
                      Navigator.pop(context, estrelas);
                    },
                    child: const Text(
                      'Próxima fase! 🚀',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      _atual = 0;
                      _pontos = 0;
                      _respostaSelecionada = null;
                      _respondido = false;
                      _mostrandoCelebracao = false;
                    });
                    _celebracaoController.reset();
                    _gerarPerguntas();
                  },
                  child: const Text(
                    'Tentar de novo',
                    style: TextStyle(color: Color(0xFF8BB4F8), fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_perguntas.isEmpty) {
      return const Scaffold(
        backgroundColor: Color(0xFF0D1B4B),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final pergunta = _perguntas[_atual];
    final progresso = (_atual + 1) / _perguntas.length;

    return Scaffold(
      backgroundColor: const Color(0xFF0D1B4B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1B4B),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Text(widget.emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 8),
            Text(
              'Fase ${widget.numeroFase} — ${widget.titulo}',
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          ],
        ),
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
                valueColor: AlwaysStoppedAnimation(widget.cor),
                minHeight: 10,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Pergunta ${_atual + 1} de ${_perguntas.length}',
              style: const TextStyle(color: Color(0xFF8BB4F8), fontSize: 14),
            ),
            const SizedBox(height: 32),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2D5A),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: widget.cor.withOpacity(0.3), width: 2),
              ),
              child: Text(
                pergunta['pergunta'],
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.8,
                children: (pergunta['opcoes'] as List<String>).map((opcao) {
                  Color corFundo = const Color(0xFF1E2D5A);
                  if (_respondido) {
                    if (opcao == pergunta['resposta']) {
                      corFundo = const Color(0xFF34A853);
                    } else if (opcao == _respostaSelecionada) {
                      corFundo = const Color(0xFFE53935);
                    }
                  }
                  return GestureDetector(
                    onTap: () => _responder(opcao),
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
                        child: Text(
                          opcao,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
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
                    backgroundColor: widget.cor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: _proximo,
                  child: Text(
                    _atual < _perguntas.length - 1
                        ? 'Próxima →'
                        : 'Ver resultado! 🌟',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}