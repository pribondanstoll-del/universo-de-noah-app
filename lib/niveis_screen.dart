import 'package:flutter/material.dart';
import 'dados_conteudo.dart';
import 'fases_screen.dart';

class NiveisScreen extends StatelessWidget {
  const NiveisScreen({super.key});

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
          '🌍 Níveis',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: todosOsNiveis.length + 1,
        itemBuilder: (context, index) {
          if (index == todosOsNiveis.length) {
            return _cardEmBreve();
          }
          final nivel = todosOsNiveis[index];
          final desbloqueado = index == 0;
          return _cardNivel(context, nivel, desbloqueado);
        },
      ),
    );
  }

  Widget _cardNivel(BuildContext context, Nivel nivel, bool desbloqueado) {
    final cores = [
      const Color(0xFF1A73E8),
      const Color(0xFF7B2FBE),
      const Color(0xFF34A853),
      const Color(0xFFF9A825),
      const Color(0xFFE53935),
    ];
    final cor = cores[(nivel.numero - 1) % cores.length];

    return GestureDetector(
      onTap: desbloqueado
          ? () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FasesScreen(nivel: nivel),
                ),
              )
          : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: desbloqueado ? cor : const Color(0xFF1E2D5A),
          borderRadius: BorderRadius.circular(24),
          boxShadow: desbloqueado
              ? [BoxShadow(color: cor.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 6))]
              : [],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Text(
                desbloqueado ? nivel.emoji : '🔒',
                style: const TextStyle(fontSize: 40),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nível ${nivel.numero}',
                      style: TextStyle(
                        color: desbloqueado ? Colors.white70 : Colors.white24,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      nivel.titulo,
                      style: TextStyle(
                        color: desbloqueado ? Colors.white : Colors.white38,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      nivel.descricao,
                      style: TextStyle(
                        color: desbloqueado ? Colors.white70 : Colors.white24,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      children: [
                        Text(
                          '${nivel.fases.length} fases',
                          style: TextStyle(
                            color: desbloqueado ? Colors.white70 : Colors.white24,
                            fontSize: 11,
                          ),
                        ),
                        Text(
                          '🏆 ${nivel.medalha}',
                          style: TextStyle(
                            color: desbloqueado ? Colors.white70 : Colors.white24,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                desbloqueado ? Icons.arrow_forward_ios : Icons.lock,
                color: desbloqueado ? Colors.white : Colors.white24,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cardEmBreve() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2D5A),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white12),
      ),
      child: const Padding(
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            Text('🚀', style: TextStyle(fontSize: 40)),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mais níveis chegando!',
                  style: TextStyle(color: Colors.white38, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Novos conteúdos em breve...',
                  style: TextStyle(color: Colors.white24, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}