import 'package:shared_preferences/shared_preferences.dart';

class ProgressoService {
  // Versão atual dos dados — incrementar quando mudar a estrutura
  static const int _versaoDados = 1;
  static const String _chaveVersao = 'versao_dados';

  // ============================================================
  // INICIALIZAÇÃO — verifica e migra dados se necessário
  // ============================================================
  static Future<void> inicializar() async {
    final prefs = await SharedPreferences.getInstance();
    final versaoSalva = prefs.getInt(_chaveVersao) ?? 0;

    if (versaoSalva < _versaoDados) {
      await _migrar(prefs, versaoSalva, _versaoDados);
      await prefs.setInt(_chaveVersao, _versaoDados);
    }
  }

  static Future<void> _migrar(
      SharedPreferences prefs, int deVersao, int paraVersao) async {
    // Versão 0 → 1: primeira instalação, nada a migrar
    if (deVersao == 0 && paraVersao >= 1) {
      // Sem migração necessária na primeira versão
    }

    // Versão 1 → 2 (exemplo para o futuro):
    // if (deVersao == 1 && paraVersao >= 2) {
    //   // migrar formato antigo para novo
    // }
  }

  // ============================================================
  // ESTRELAS DAS LIÇÕES
  // ============================================================
  static Future<void> salvarEstrelas({
    required int nivel,
    required int fase,
    required int licao,
    required int estrelas,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final chave = 'v${_versaoDados}_estrelas_${nivel}_${fase}_$licao';
    final atual = prefs.getInt(chave) ?? 0;
    if (estrelas > atual) {
      await prefs.setInt(chave, estrelas);
    }
  }

  static Future<int> buscarEstrelas({
    required int nivel,
    required int fase,
    required int licao,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final chave = 'v${_versaoDados}_estrelas_${nivel}_${fase}_$licao';
    return prefs.getInt(chave) ?? 0;
  }

  static Future<Map<int, Map<int, int>>> buscarProgressoNivel(int nivel) async {
    final prefs = await SharedPreferences.getInstance();
    Map<int, Map<int, int>> progresso = {};

    for (int f = 0; f < 10; f++) {
      for (int l = 0; l < 10; l++) {
        final chave = 'v${_versaoDados}_estrelas_${nivel}_${f}_$l';
        final estrelas = prefs.getInt(chave);
        if (estrelas != null) {
          progresso[f] ??= {};
          progresso[f]![l] = estrelas;
        }
      }
    }
    return progresso;
  }

  // ============================================================
  // BOSS DO NÍVEL
  // ============================================================
  static Future<bool> bossCompleto(int nivel) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('v${_versaoDados}_boss_$nivel') ?? false;
  }

  static Future<void> salvarBossCompleto(int nivel) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('v${_versaoDados}_boss_$nivel', true);
  }

  // ============================================================
  // PERFIL DA CRIANÇA
  // ============================================================
  static Future<Map<String, String>> buscarPerfil() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'nome': prefs.getString('nome_crianca') ?? '',
      'avatar': prefs.getString('avatar_crianca') ?? '🦁',
    };
  }

  // ============================================================
  // ESTATÍSTICAS GERAIS
  // ============================================================
  static Future<Map<String, int>> buscarEstatisticas() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'total_licoes': prefs.getInt('v${_versaoDados}_total_licoes') ?? 0,
      'total_estrelas': prefs.getInt('v${_versaoDados}_total_estrelas') ?? 0,
      'dias_seguidos': prefs.getInt('v${_versaoDados}_dias_seguidos') ?? 0,
    };
  }

  static Future<void> incrementarLicoes() async {
    final prefs = await SharedPreferences.getInstance();
    final chave = 'v${_versaoDados}_total_licoes';
    final atual = prefs.getInt(chave) ?? 0;
    await prefs.setInt(chave, atual + 1);
  }

  // ============================================================
  // CONTROLE DE VERSÃO — para atualizações futuras
  // ============================================================

  // Como usar quando mudar a estrutura dos dados:
  //
  // 1. Incrementa _versaoDados de 1 para 2
  // 2. Adiciona o bloco de migração em _migrar():
  //    if (deVersao == 1 && paraVersao >= 2) {
  //      final valorAntigo = prefs.getString('chave_antiga');
  //      await prefs.setString('v2_chave_nova', valorAntigo ?? '');
  //      await prefs.remove('chave_antiga');
  //    }
  // 3. Publica a atualização — o progresso é migrado automaticamente
  //
  // Regras de ouro:
  // - NUNCA remover dados sem migrar
  // - SEMPRE testar a migração antes de publicar
  // - SEMPRE incrementar a versão ao mudar estrutura

  // ============================================================
  // LIMPAR PROGRESSO (apenas para testes)
  // ============================================================
  static Future<void> limparProgresso() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    for (final key in keys) {
      if (key.startsWith('v${_versaoDados}_')) {
        await prefs.remove(key);
      }
    }
  }
}