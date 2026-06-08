import 'package:cloud_firestore/cloud_firestore.dart';

class Servico {
  final String? id;
  final String nome;
  final String descricao;
  final int duracaoMinutos;
  final double preco;
  final bool ativo;

  Servico({
    this.id,
    required this.nome,
    required this.descricao,
    required this.duracaoMinutos,
    required this.preco,
    this.ativo = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'nomeBusca': nome.toLowerCase(),
      'descricao': descricao,
      'duracaoMinutos': duracaoMinutos,
      'preco': preco,
      'ativo': ativo,
    };
  }

  factory Servico.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return Servico(
      id: doc.id,
      nome: data['nome'] ?? '',
      descricao: data['descricao'] ?? '',
      duracaoMinutos: (data['duracaoMinutos'] ?? 0) as int,
      preco: (data['preco'] ?? 0).toDouble(),
      ativo: data['ativo'] ?? true,
    );
  }
}
