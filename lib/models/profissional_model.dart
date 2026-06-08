import 'package:cloud_firestore/cloud_firestore.dart';

class Profissional {
  final String? id;
  final String nome;
  final String especialidade;
  final String telefone;
  final String email;
  final bool ativo;

  Profissional({
    this.id,
    required this.nome,
    required this.especialidade,
    required this.telefone,
    required this.email,
    this.ativo = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'nomeBusca': nome.toLowerCase(),
      'especialidade': especialidade,
      'telefone': telefone,
      'email': email,
      'ativo': ativo,
    };
  }

  factory Profissional.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return Profissional(
      id: doc.id,
      nome: data['nome'] ?? '',
      especialidade: data['especialidade'] ?? '',
      telefone: data['telefone'] ?? '',
      email: data['email'] ?? '',
      ativo: data['ativo'] ?? true,
    );
  }
}
