import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Camada responsável por toda a comunicação com o Firebase Authentication
/// e pela gravação dos dados do usuário na coleção `usuarios` do Firestore.
///
/// Os métodos lançam [Exception] com mensagens já traduzidas para PT-BR,
/// permitindo que as telas apenas capturem e exibam o texto ao usuário.
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Usuário atualmente logado (ou null).
  User? get usuarioAtual => _auth.currentUser;

  /// Stream do estado de autenticação (útil para o RF005 / AuthGate).
  Stream<User?> get mudancasDeAutenticacao => _auth.authStateChanges();

  // --- LOGIN (RF001) ---
  Future<void> entrar({
    required String email,
    required String senha,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: senha,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(_traduzErro(e.code));
    }
  }

  // --- REGISTRO (RF002) ---
  /// Cria o usuário no Authentication e grava os campos adicionais
  /// (nome, telefone) na coleção `usuarios`, indexados pelo uid.
  Future<void> registrar({
    required String nome,
    required String email,
    required String telefone,
    required String senha,
  }) async {
    try {
      final credencial = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: senha,
      );

      final uid = credencial.user!.uid;

      await _db.collection('usuarios').doc(uid).set({
        'uid': uid,
        'nome': nome.trim(),
        'email': email.trim(),
        'telefone': telefone.trim(),
        'criadoEm': FieldValue.serverTimestamp(),
      });
    } on FirebaseAuthException catch (e) {
      throw Exception(_traduzErro(e.code));
    }
  }

  // --- RECUPERAÇÃO DE SENHA (RF001) ---
  Future<void> recuperarSenha({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw Exception(_traduzErro(e.code));
    }
  }

  // --- LOGOUT ---
  Future<void> sair() async {
    await _auth.signOut();
  }

  /// Traduz os códigos de erro do Firebase Auth para mensagens amigáveis.
  String _traduzErro(String code) {
    switch (code) {
      case 'invalid-email':
        return 'O endereço de e-mail é inválido.';
      case 'user-disabled':
        return 'Esta conta foi desativada.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'E-mail ou senha incorretos.';
      case 'email-already-in-use':
        return 'Este e-mail já está cadastrado.';
      case 'weak-password':
        return 'A senha é muito fraca.';
      case 'too-many-requests':
        return 'Muitas tentativas. Tente novamente mais tarde.';
      case 'network-request-failed':
        return 'Falha de conexão. Verifique sua internet.';
      default:
        return 'Ocorreu um erro inesperado. Tente novamente.';
    }
  }
}
