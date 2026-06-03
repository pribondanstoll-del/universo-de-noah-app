import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Usuário atual
  static User? get usuarioAtual => _auth.currentUser;
  static bool get estaLogado => _auth.currentUser != null;

  // Stream de mudanças de autenticação
  static Stream<User?> get mudancasAuth => _auth.authStateChanges();

  // Cadastro com e-mail e senha
  static Future<String?> cadastrar({
    required String email,
    required String senha,
    required String nomeResponsavel,
  }) async {
    try {
      final resultado = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: senha,
      );

      // Salva o nome do responsável
      await resultado.user?.updateDisplayName(nomeResponsavel);

      // Salva localmente
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('nome_responsavel', nomeResponsavel);
      await prefs.setString('email_responsavel', email.trim());

      return null; // sucesso
    } on FirebaseAuthException catch (e) {
      return _traduzirErro(e.code);
    }
  }

  // Login com e-mail e senha
  static Future<String?> login({
    required String email,
    required String senha,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: senha,
      );
      return null; // sucesso
    } on FirebaseAuthException catch (e) {
      return _traduzirErro(e.code);
    }
  }

  // Logout
  static Future<void> logout() async {
    await _auth.signOut();
  }

  // Redefinir senha
  static Future<String?> redefinirSenha(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      return null;
    } on FirebaseAuthException catch (e) {
      return _traduzirErro(e.code);
    }
  }

  // Traduz erros do Firebase para português
  static String _traduzirErro(String codigo) {
    switch (codigo) {
      case 'email-already-in-use':
        return 'Este e-mail já está cadastrado.';
      case 'invalid-email':
        return 'E-mail inválido.';
      case 'weak-password':
        return 'Senha muito fraca. Use pelo menos 6 caracteres.';
      case 'user-not-found':
        return 'E-mail não encontrado.';
      case 'wrong-password':
        return 'Senha incorreta.';
      case 'too-many-requests':
        return 'Muitas tentativas. Tente novamente mais tarde.';
      case 'network-request-failed':
        return 'Sem conexão com a internet.';
      default:
        return 'Erro ao acessar. Tente novamente.';
    }
  }
}