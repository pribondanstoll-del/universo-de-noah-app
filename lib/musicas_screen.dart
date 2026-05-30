import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MusicasScreen extends StatefulWidget {
  const MusicasScreen({super.key});

  @override
  State<MusicasScreen> createState() => _MusicasScreenState();
}

class _MusicasScreenState extends State<MusicasScreen> {
  int? _tocandoIndex;

  final List<Map<String, dynamic>> _musicas = [
    {
      'titulo': 'Música do Universo de Noah',
      'descricao': 'A música tema do canal!',
      'youtubeId': 'CNH1_q5dYYc',
      'duracao': '2:30',
      'emoji': '🌌',
      'cor': const Color(0xFF1A73E8),
      'novo': true,
      'audioFile': '',
    },
    {
      'titulo': 'Em breve!',
      'descricao': 'Mais músicas educativas chegando...',
      'youtubeId': '',
      'duracao': '--:--',
      'emoji': '🎵',
      'cor': const Color(0xFF7B2FBE),
      'novo': false,
      'audioFile': '',
    },
    {
      'titulo': 'Em breve!',
      'descricao': 'Músicas de inglês chegando...',
      'youtubeId': '',
      'duracao': '--:--',
      'emoji': '🎶',
      'cor': const Color(0xFF34A853),
      'novo': false,
      'audioFile': '',
    },
  ];

  Future<void> _abrirYoutube(String youtubeId) async {
    final url = Uri.parse('https://www.youtube.com/watch?v=$youtubeId');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
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
        title: const Text(
          '🎵 Músicas do Noah',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // Header
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF7B2FBE), Color(0xFF1A73E8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Text('🎵', style: TextStyle(fontSize: 36)),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Músicas Educativas',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Ouça no app • Veja o clipe no YouTube',
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Lista de músicas
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _musicas.length,
              itemBuilder: (context, index) {
                final musica = _musicas[index];
                final temAudio = musica['youtubeId'] != '';
                final tocando = _tocandoIndex == index;

                return GestureDetector(
                  onTap: temAudio
                      ? () => _mostrarPlayer(context, index, musica)
                      : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: tocando
                          ? (musica['cor'] as Color)
                          : const Color(0xFF1E2D5A),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: tocando
                          ? [BoxShadow(
                              color: (musica['cor'] as Color).withOpacity(0.4),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            )]
                          : [],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          // Thumbnail / Emoji
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: temAudio
                                  ? (musica['cor'] as Color).withOpacity(0.3)
                                  : const Color(0xFF0D1B4B),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: temAudio
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.network(
                                      'https://img.youtube.com/vi/${musica['youtubeId']}/default.jpg',
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Center(
                                        child: Text(musica['emoji'],
                                            style: const TextStyle(fontSize: 32)),
                                      ),
                                    ),
                                  )
                                : Center(
                                    child: Text(musica['emoji'],
                                        style: const TextStyle(fontSize: 32)),
                                  ),
                          ),
                          const SizedBox(width: 16),

                          // Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (musica['novo'] == true)
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 4),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF34A853),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Text('NOVO',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                Text(
                                  musica['titulo'],
                                  style: TextStyle(
                                    color: temAudio ? Colors.white : Colors.white38,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  musica['descricao'],
                                  style: TextStyle(
                                    color: temAudio ? Colors.white70 : Colors.white24,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  musica['duracao'],
                                  style: TextStyle(
                                    color: temAudio
                                        ? Colors.white54
                                        : Colors.white24,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Botão play
                          if (temAudio)
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: musica['cor'] as Color,
                                borderRadius: BorderRadius.circular(22),
                              ),
                              child: Icon(
                                tocando ? Icons.pause : Icons.play_arrow,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarPlayer(BuildContext context, int index, Map<String, dynamic> musica) {
    setState(() => _tocandoIndex = index);

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E2D5A),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 24),

                // Thumbnail grande
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    'https://img.youtube.com/vi/${musica['youtubeId']}/hqdefault.jpg',
                    width: double.infinity,
                    height: 180,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: double.infinity,
                      height: 180,
                      color: const Color(0xFF0D1B4B),
                      child: Center(
                        child: Text(musica['emoji'],
                            style: const TextStyle(fontSize: 72)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Título
                Text(
                  musica['titulo'],
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  musica['descricao'],
                  style: const TextStyle(color: Colors.white54, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Info áudio
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D1B4B),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('🎵', style: TextStyle(fontSize: 24)),
                      SizedBox(width: 12),
                      Text(
                        'Áudio em produção!\nEm breve você poderá ouvir aqui.',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Botão YouTube
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      _abrirYoutube(musica['youtubeId']);
                    },
                    icon: const Icon(Icons.play_circle_fill, color: Colors.white),
                    label: const Text(
                      'Ver o clipe no YouTube 🎬',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    setState(() => _tocandoIndex = null);
                    Navigator.pop(context);
                  },
                  child: const Text('Fechar',
                      style: TextStyle(color: Colors.white54, fontSize: 15)),
                ),
                const SizedBox(height: 8),
              ],
            ),
          );
        },
      ),
    ).whenComplete(() => setState(() => _tocandoIndex = null));
  }
}