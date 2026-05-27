import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class VideosScreen extends StatelessWidget {
  const VideosScreen({super.key});

  final List<Map<String, dynamic>> _categorias = const [
    {
      'titulo': 'Temporadas',
      'emoji': '🎬',
      'videos': [
        {
          'titulo': 'Universo de Noah — Episódio 1',
          'descricao': 'A primeira aventura do Noah no universo das palavras!',
          'youtubeId': 'I6U3639spkU',
          'duracao': '3:24',
          'novo': true,
        },
      ],
    },
    {
      'titulo': 'Músicas Educativas',
      'emoji': '🎵',
      'videos': [
        {
          'titulo': 'Em breve!',
          'descricao': 'Músicas educativas do Universo de Noah chegando em breve...',
          'youtubeId': '',
          'duracao': '--:--',
          'novo': false,
        },
      ],
    },
    {
      'titulo': 'Histórias para Dormir',
      'emoji': '🌙',
      'videos': [
        {
          'titulo': 'Em breve!',
          'descricao': 'Histórias relaxantes do Noah chegando em breve...',
          'youtubeId': '',
          'duracao': '--:--',
          'novo': false,
        },
      ],
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
          '🎬 Vídeos do Noah',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _categorias.length,
        itemBuilder: (context, catIndex) {
          final categoria = _categorias[catIndex];
          final videos = categoria['videos'] as List<Map<String, dynamic>>;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header da categoria
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    Text(categoria['emoji'],
                        style: const TextStyle(fontSize: 24)),
                    const SizedBox(width: 8),
                    Text(
                      categoria['titulo'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Vídeos da categoria
              ...videos.map((video) {
                final temVideo = video['youtubeId'] != '';
                return GestureDetector(
                  onTap: temVideo
                      ? () => _mostrarPrevia(context, video)
                      : null,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E2D5A),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Thumbnail
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16)),
                          child: Stack(
                            children: [
                              temVideo
                                  ? Image.network(
                                      'https://img.youtube.com/vi/${video['youtubeId']}/hqdefault.jpg',
                                      width: double.infinity,
                                      height: 180,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) =>
                                          _thumbnailPlaceholder(),
                                    )
                                  : _thumbnailPlaceholder(),
                              if (temVideo)
                                Positioned.fill(
                                  child: Center(
                                    child: Container(
                                      width: 56,
                                      height: 56,
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(28),
                                      ),
                                      child: const Icon(Icons.play_arrow,
                                          color: Colors.white, size: 36),
                                    ),
                                  ),
                                ),
                              if (video['novo'] == true)
                                Positioned(
                                  top: 8,
                                  left: 8,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF34A853),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text('NOVO',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              if (temVideo)
                                Positioned(
                                  bottom: 8,
                                  right: 8,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.black87,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      video['duracao'],
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),

                        // Info do vídeo
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                video['titulo'],
                                style: TextStyle(
                                  color: temVideo ? Colors.white : Colors.white38,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                video['descricao'],
                                style: TextStyle(
                                  color: temVideo
                                      ? Colors.white54
                                      : Colors.white24,
                                  fontSize: 12,
                                ),
                              ),
                              if (temVideo) ...[
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                    onPressed: () =>
                                        _abrirYoutube(video['youtubeId']),
                                    icon: const Icon(Icons.play_circle_fill,
                                        color: Colors.white),
                                    label: const Text('Ver no YouTube',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 8),
            ],
          );
        },
      ),
    );
  }

  void _mostrarPrevia(BuildContext context, Map<String, dynamic> video) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E2D5A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              video['titulo'],
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              video['descricao'],
              style: const TextStyle(color: Colors.white70, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            const Text('🎬', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 8),
            const Text(
              'Prévia disponível em breve!\nPor enquanto, assista no YouTube.',
              style: TextStyle(color: Color(0xFF8BB4F8), fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
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
                  _abrirYoutube(video['youtubeId']);
                },
                icon: const Icon(Icons.play_circle_fill, color: Colors.white),
                label: const Text('Assistir no YouTube',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _thumbnailPlaceholder() {
    return Container(
      width: double.infinity,
      height: 180,
      color: const Color(0xFF0D1B4B),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('🎬', style: TextStyle(fontSize: 48)),
          SizedBox(height: 8),
          Text('Em breve',
              style: TextStyle(color: Colors.white38, fontSize: 14)),
        ],
      ),
    );
  }
}