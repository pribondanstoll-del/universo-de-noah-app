import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'cadastro_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _paginaAtual = 0;

  final List<_SlideDado> _slides = [
    _SlideDado(
      emoji: '🌌',
      titulo: 'Bem-vindo ao\nUniverso de Noah!',
      descricao: 'Um app educacional completo para crianças de 3 a 9 anos aprenderem inglês de forma divertida e segura.',
      cor: const Color(0xFF1A73E8),
    ),
    _SlideDado(
      emoji: '📚',
      titulo: 'Aprendizado\nde verdade!',
      descricao: 'Lições interativas, jogos, músicas e vídeos do canal Universo de Noah — tudo integrado para o melhor aprendizado.',
      cor: const Color(0xFF7B2FBE),
    ),
    _SlideDado(
      emoji: '🎮',
      titulo: 'Aprender\nbrincando!',
      descricao: 'Jogo da memória, quiz, escuta e toca — a criança aprende sem perceber que está estudando!',
      cor: const Color(0xFF34A853),
    ),
    _SlideDado(
      emoji: '👨‍👩‍👧',
      titulo: 'Você acompanha\ntudo!',
      descricao: 'O Painel dos Pais mostra o progresso da criança em tempo real — fases concluídas, estrelas conquistadas e muito mais.',
      cor: const Color(0xFFF9A825),
    ),
    _SlideDado(
      emoji: '🔒',
      titulo: 'Área protegida\npelos pais',
      descricao: 'O Painel dos Pais é protegido por um PIN de 4 dígitos.\n\n⚠️ Não compartilhe o PIN com as crianças — é a sua área exclusiva de configurações.',
      cor: const Color(0xFFE53935),
      destaque: true,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _proxima() {
    if (_paginaAtual < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B4B),
      body: SafeArea(
        child: Column(
          children: [
            // Botão pular
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _paginaAtual < _slides.length - 1
                    ? TextButton(
                        onPressed: () => _pageController.animateToPage(
                          _slides.length - 1,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        ),
                        child: const Text('Pular',
                            style: TextStyle(
                                color: Colors.white54, fontSize: 15)),
                      )
                    : const SizedBox(height: 44),
              ),
            ),

            // Slides
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (i) => setState(() => _paginaAtual = i),
                itemCount: _slides.length,
                itemBuilder: (context, index) {
                  final slide = _slides[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Ícone
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: slide.cor,
                            borderRadius: BorderRadius.circular(32),
                            boxShadow: [
                              BoxShadow(
                                color: slide.cor.withOpacity(0.5),
                                blurRadius: 24,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(slide.emoji,
                                style: const TextStyle(fontSize: 60)),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Título
                        Text(
                          slide.titulo,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            height: 1.3,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),

                        // Descrição
                        Container(
                          padding: slide.destaque
                              ? const EdgeInsets.all(16)
                              : EdgeInsets.zero,
                          decoration: slide.destaque
                              ? BoxDecoration(
                                  color: slide.cor.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                      color: slide.cor.withOpacity(0.4)),
                                )
                              : null,
                          child: Text(
                            slide.descricao,
                            style: const TextStyle(
                              color: Color(0xFF8BB4F8),
                              fontSize: 16,
                              height: 1.6,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Indicadores de página
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_slides.length, (i) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _paginaAtual == i ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _paginaAtual == i
                        ? _slides[_paginaAtual].cor
                        : Colors.white24,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
            const SizedBox(height: 32),

            // Botões
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _paginaAtual < _slides.length - 1
                  ? SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _slides[_paginaAtual].cor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                        ),
                        onPressed: _proxima,
                        child: const Text(
                          'Próximo →',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1A73E8),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                            ),
                            onPressed: () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const CadastroScreen()),
                            ),
                            child: const Text(
                              'Criar minha conta 🚀',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                  color: Colors.white24),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                            ),
                            onPressed: () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const LoginScreen()),
                            ),
                            child: const Text(
                              'Já tenho conta',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _SlideDado {
  final String emoji;
  final String titulo;
  final String descricao;
  final Color cor;
  final bool destaque;

  _SlideDado({
    required this.emoji,
    required this.titulo,
    required this.descricao,
    required this.cor,
    this.destaque = false,
  });
}