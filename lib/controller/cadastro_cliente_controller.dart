import 'package:flutter_atividade_parcial/models/cliente_model.dart';
import 'package:flutter_atividade_parcial/services/firestore_service.dart';

class CadastroClienteController {
  final FirestoreService _firestore = FirestoreService();

  /// Salva um novo cliente na coleção `clientes` do Firestore (RF003).
  /// Lança Exception em caso de falha (a view captura e exibe).
  Future<void> salvarNovoCliente({
    required String nome,
    required String cpf,
    required String telefone,
    String email = '',
    String cep = '',
    String endereco = '',
  }) async {
    final novoCliente = Cliente(
      nome: nome.trim(),
      cpf: cpf.trim(),
      telefone: telefone.trim(),
      email: email.trim(),
      cep: cep.trim(),
      endereco: endereco.trim(),
    );

    await _firestore.adicionar('clientes', novoCliente.toMap());
  }

  /// Atualiza um cliente existente (RF004).
  Future<void> atualizarCliente(String id, Cliente cliente) async {
    await _firestore.atualizar('clientes', id, cliente.toMap());
  }
}
