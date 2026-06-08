import 'package:cloud_firestore/cloud_firestore.dart';

class Cliente {
  final String? id; // id do documento no Firestore (null antes de salvar)
  final String nome;
  final String cpf;
  final String telefone;
  final String email;
  final String cep;
  final String endereco;

  Cliente({
    this.id,
    required this.nome,
    required this.cpf,
    required this.telefone,
    this.email = '',
    this.cep = '',
    this.endereco = '',
  });

  /// Converte para o formato gravado no Firestore.
  /// `nomeBusca` (minúsculo) viabiliza a pesquisa case-insensitive (RF006).
  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'nomeBusca': nome.toLowerCase(),
      'cpf': cpf,
      'telefone': telefone,
      'email': email,
      'cep': cep,
      'endereco': endereco,
    };
  }

  /// Reconstrói o objeto a partir de um documento do Firestore.
  factory Cliente.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return Cliente(
      id: doc.id,
      nome: data['nome'] ?? '',
      cpf: data['cpf'] ?? '',
      telefone: data['telefone'] ?? '',
      email: data['email'] ?? '',
      cep: data['cep'] ?? '',
      endereco: data['endereco'] ?? '',
    );
  }
}
