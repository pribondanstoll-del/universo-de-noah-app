import 'package:shared_preferences/shared_preferences.dart';

class ProgressoService {
  static const String _chaveProgresso = 'progresso_licoes';
  static const String _chaveNivelAtual = 'nivel_atual';
  static const String _chaveFaseAtual = 'fase_atual';

  // Salva estrelas de uma lição específica
  static Future<void> salvarEstrelas({
    required int nivel,
    required int fase,
    required int licao,
    required int estrelas,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final chave = 'estrelas_${nivel}_${fase}_$licao';
    final atual = prefs.getInt(chave) ?? 0;
    if (estrelas > atual) {
      await prefs.setInt(chave, estrelas);
    }
  }

  // Busca estrelas de uma lição específica
  static Future<int> buscarEstrelas({
    required int nivel,
    required int fase,
    required int licao,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final chave = 'estrelas_${nivel}_${fase}_$licao';
    return prefs.getInt(chave) ?? 0;
  }

  // Salva o nível e fase atual desbloqueados
  static Future<void> salvarPosicaoAtual({
    required int nivel,
    required int fase,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_chaveNivelAtual, nivel);
    await prefs.setInt(_chaveFaseAtual, fase);
  }

  // Busca toda a progressão de um nível
  static Future<Map<int, Map<int, int>>> buscarProgressoNivel(int nivel) async {
    final prefs = await SharedPreferences.getInstance();
    Map<int, Map<int, int>> progresso = {};

    // Percorre até 10 fases com até 10 lições cada
    for (int f = 0; f < 10; f++) {
      for (int l = 0; l < 10; l++) {
        final chave = 'estrelas_${nivel}_${f}_$l';
        final estrelas = prefs.getInt(chave);
        if (estrelas != null) {
          progresso[f] ??= {};
          progresso[f]![l] = estrelas;
        }
      }
    }
    return progresso;
  }

  // Verifica se o boss de um nível foi completado
  static Future<bool> bossCompleto(int nivel) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('boss_$nivel') ?? false;
  }

  // Salva que o boss foi completado
  static Future<void> salvarBossCompleto(int nivel) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('boss_$nivel', true);
  }

  // Limpa todo o progresso (para testes)
  static Future<void> limparProgresso() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}