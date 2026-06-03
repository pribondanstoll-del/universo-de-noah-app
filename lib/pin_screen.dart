import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PinScreen extends StatefulWidget {
  final bool configurando;
  final VoidCallback? aoConfirmar;

  const PinScreen({
    super.key,
    this.configurando = false,
    this.aoConfirmar,
  });

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  String _pin = '';
  String _pinConfirmacao = '';
  bool _confirmando = false;
  String? _erro;

  void _apertarTecla(String valor) {
    if (_pin.length >= 4) return;
    setState(() {
      _pin += valor;
      _erro = null;
    });

    if (_pin.length == 4) {
      Future.delayed(const Duration(milliseconds: 200), () => _verificar());
    }
  }

  void _apagar() {
    if (_pin.isEmpty) return;
    setState(() => _pin = _pin.substring(0, _pin.length - 1));
  }

  Future<void> _verificar() async {
    if (widget.configurando) {
      if (!_confirmando) {
        setState(() {
          _pinConfirmacao = _pin;
          _pin = '';
          _confirmando = true;
        });
      } else {
        if (_pin == _pinConfirmacao) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('pin_pais', _pin);
          if (mounted) {
            widget.aoConfirmar?.call();
            Navigator.pop(context, true);
          }
        } else {
          setState(() {
            _pin = '';
            _pinConfirmacao = '';
            _confirmando = false;
            _erro = 'PINs não coincidem. Tente novamente.';
          });
        }
      }
    } else {
      final prefs = await SharedPreferences.getInstance();
      final pinSalvo = prefs.getString('pin_pais') ?? '';
      if (_pin == pinSalvo) {
        if (mounted) {
          widget.aoConfirmar?.call();
          Navigator.pop(context, true);
        }
      } else {
        setState(() {
          _pin = '';
          _erro = 'PIN incorreto. Tente novamente.';
        });
      }
    }
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
          widget.configurando
              ? (_confirmando ? '🔒 Confirme o PIN' : '🔒 Criar PIN')
              : '🔒 Painel dos Pais',
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Ícone
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A73E8),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Center(
                  child: Text('👨‍👩‍👧', style: TextStyle(fontSize: 40)),
                ),
              ),
              const SizedBox(height: 20),

              // Título
              Text(
                widget.configurando
                    ? (_confirmando
                        ? 'Confirme seu PIN de 4 dígitos'
                        : 'Crie um PIN de 4 dígitos\npara proteger esta área')
                    : 'Digite o PIN dos pais',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Apenas os responsáveis devem saber o PIN',
                style: TextStyle(color: Color(0xFF8BB4F8), fontSize: 13),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Indicadores do PIN
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (i) {
                  final preenchido = i < _pin.length;
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: preenchido
                          ? const Color(0xFF1A73E8)
                          : const Color(0xFF1E2D5A),
                      border: Border.all(
                        color: preenchido
                            ? const Color(0xFF1A73E8)
                            : Colors.white24,
                        width: 2,
                      ),
                    ),
                  );
                }),
              ),

              // Erro
              if (_erro != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    _erro!,
                    style: const TextStyle(
                        color: Color(0xFFE53935), fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),

              const SizedBox(height: 40),

              // Teclado numérico
              SizedBox(
                width: 280,
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.3,
                  children: [
                    ...[1, 2, 3, 4, 5, 6, 7, 8, 9].map((n) => _tecla('$n')),
                    _teclaEspecial('', vazia: true),
                    _tecla('0'),
                    _teclaEspecial('⌫', onTap: _apagar),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tecla(String valor) {
    return GestureDetector(
      onTap: () => _apertarTecla(valor),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E2D5A),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Text(
            valor,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _teclaEspecial(String label,
      {VoidCallback? onTap, bool vazia = false}) {
    if (vazia) return const SizedBox();
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E2D5A),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
      ),
    );
  }
}