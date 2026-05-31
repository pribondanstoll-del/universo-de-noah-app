import 'package:flutter/material.dart';
import 'dados_conteudo.dart';

class JogoMemoriaScreen extends StatefulWidget {
  final List<Palavra> palavras;
  final Color cor;
  final String titulo;

  const JogoMemoriaScreen({
    super.key,
    required this.palavras,
    required this.cor,
    required this.titulo,
  });

  @override
  State<JogoMemoriaScreen> createState() => _JogoMemoriaScreenState();
}

class _JogoMemoriaScreenState extends State<JogoMemoriaScreen> {
  late List<_Carta> _cartas;
  int? _primeiraCartaIndex;
  bool _verificando = false;
  int _pares = 0;
  int _tentativas = 0;
  bool _jogoCompleto = false;

  @override
  void initState() {
    super.initState();
    _iniciarJogo();
  }

  void _iniciarJogo() {
    List<_Carta> cartas = [];
    final palavras = widget.palavras.take(4).toList();

    for (int i = 0; i < palavras.length; i++) {
      cartas.add(_Carta(
        id: i,
        conteudo: palavras[i].ingles,
        tipo: 'palavra',
        parId: i,
      ));
      cartas.add(_Carta(
        id: i + palavras.length,
        conteudo: palavras[i].emoji,
        tipo: 'emoji',
        parId: i,
      ));
    }

    cartas.shuffle();
    setState(() {
      _cartas = cartas;
      _primeiraCartaIndex = null;
      _verificando = false;
      _pares = 0;
      _tentativas = 0;
      _jogoCompleto = false;
    });
  }

  void _tocarCarta(int index) {
    if (_verificando) return;
    if (_cartas[index].virada) return;
    if (_cartas[index].acertada) return;
    if (_primeiraCartaIndex == index) return;

    setState(() => _cartas[index].virada = true);

    if (_primeiraCartaIndex == null) {
      _primeiraCartaIndex = index;
    } else {
      _tentativas++;
      _verificando = true;

      final primeira = _cartas[_primeiraCartaIndex!];
      final segunda = _cartas[index];

      if (primeira.parId == segunda.parId) {
        setState(() {
          _cartas[_primeiraCartaIndex!].acertada = true;
          _cartas[index].acertada = true;
          _pares++;
          _primeiraCartaIndex = null;
          _verificando = false;
        });

        if (_pares == widget.palavras.take(4).length) {
          Future.delayed(const Duration(milliseconds: 500), () {
            setState(() => _jogoCompleto = true);
            _mostrarVitoria();
          });
        }
      } else {
        Future.delayed(const Duration(milliseconds: 800), () {
          setState(() {
            _cartas[_primeiraCartaIndex!].virada = false;
            _cartas[index].virada = false;
            _primeiraCartaIndex = null;
            _verificando = false;
          });
        });
      }
    }
  }

  String _calcularEstrelas() {
    if (_tentativas <= _pares + 2) return '⭐⭐⭐';
    if (_tentativas <= _pares + 5) return '⭐⭐';
    return '⭐';
  }

  void _mostrarVitoria() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1E2D5A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🏆', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 12),
            const Text(
              'PARABÉNS!',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2),
            ),
            const SizedBox(height: 8),
            const Text(
              'You found all the pairs!\nVocê encontrou todos os pares!',
              style: TextStyle(color: Color(0xFF8BB4F8), fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              _calcularEstrelas(),
              style: const TextStyle(fontSize: 40),
            ),
            const SizedBox(height: 8),
            Text(
              '$_tentativas tentativas',
              style: const TextStyle(color: Colors.white54, fontSize: 14),
            ),
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
                _iniciarJogo();
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
          '🃏 ${widget.titulo}',
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '$_pares/${widget.palavras.take(4).length} pares',
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          child: Column(
            children: [
              // Info
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _infoCard('🎯', '$_tentativas', 'Tentativas'),
                  _infoCard('✅', '$_pares', 'Pares'),
                  _infoCard('❓', '${widget.palavras.take(4).length - _pares}', 'Restam'),
                ],
              ),
              const SizedBox(height: 20),

              // Grade de cartas — maior e mais espaçada
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: _cartas.length,
                  itemBuilder: (context, index) {
                    final carta = _cartas[index];
                    return GestureDetector(
                      onTap: () => _tocarCarta(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color: carta.acertada
                              ? const Color(0xFF34A853)
                              : carta.virada
                                  ? widget.cor
                                  : const Color(0xFF1E2D5A),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: carta.virada || carta.acertada
                              ? [
                                  BoxShadow(
                                    color: (carta.acertada
                                            ? const Color(0xFF34A853)
                                            : widget.cor)
                                        .withOpacity(0.4),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  )
                                ]
                              : [],
                        ),
                        child: Center(
                          child: carta.virada || carta.acertada
                              ? Text(
                                  carta.conteudo,
                                  style: TextStyle(
                                    fontSize: carta.tipo == 'emoji' ? 28 : 13,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                )
                              : const Text('❓',
                                  style: TextStyle(fontSize: 24)),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Botão reiniciar
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: widget.cor),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: _iniciarJogo,
                  icon: const Icon(Icons.refresh, color: Colors.white70),
                  label: const Text('Reiniciar',
                      style: TextStyle(color: Colors.white70, fontSize: 15)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoCard(String emoji, String valor, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2D5A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          Text(valor,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
          Text(label,
              style: const TextStyle(color: Colors.white38, fontSize: 10)),
        ],
      ),
    );
  }
}

class _Carta {
  final int id;
  final String conteudo;
  final String tipo;
  final int parId;
  bool virada;
  bool acertada;

  _Carta({
    required this.id,
    required this.conteudo,
    required this.tipo,
    required this.parId,
    this.virada = false,
    this.acertada = false,
  });
}