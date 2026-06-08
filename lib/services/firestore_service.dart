import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Camada de acesso ao Cloud Firestore.
///
/// TODA operação é feita dentro do escopo do usuário logado (`uid`),
/// garantindo a separação de dados exigida pelo RF003: cada usuário só
/// enxerga e manipula os próprios documentos.
class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String get _uid {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('Nenhum usuário logado.');
    }
    return user.uid;
  }

  CollectionReference<Map<String, dynamic>> _col(String nome) =>
      _db.collection(nome);

  // ---------- INSERÇÃO (RF003) ----------
  /// Adiciona um documento na [colecao], injetando uid e criadoEm.
  Future<void> adicionar(String colecao, Map<String, dynamic> dados) async {
    await _col(colecao).add({
      ...dados,
      'uid': _uid,
      'criadoEm': FieldValue.serverTimestamp(),
    });
  }

  // ---------- ATUALIZAÇÃO (RF004) ----------
  Future<void> atualizar(
    String colecao,
    String id,
    Map<String, dynamic> dados,
  ) async {
    await _col(colecao).doc(id).update(dados);
  }

  // ---------- EXCLUSÃO ----------
  Future<void> remover(String colecao, String id) async {
    await _col(colecao).doc(id).delete();
  }

  /// Busca pontual (não-reativa) dos documentos da [colecao] do usuário.
  /// Útil para popular dropdowns. A ordenação é feita no app.
  Future<QuerySnapshot<Map<String, dynamic>>> buscarUmaVez(String colecao) {
    return _col(colecao).where('uid', isEqualTo: _uid).get();
  }

  // ---------- RECUPERAÇÃO EM TEMPO REAL (RF005) ----------
  /// Stream dos documentos da [colecao] pertencentes ao usuário logado.
  ///
  /// Consulta apenas por `uid` (índice automático) e deixa a ordenação a
  /// cargo de quem consome, evitando a necessidade de índices compostos.
  Stream<QuerySnapshot<Map<String, dynamic>>> stream(String colecao) {
    return _col(colecao).where('uid', isEqualTo: _uid).snapshots();
  }
}
