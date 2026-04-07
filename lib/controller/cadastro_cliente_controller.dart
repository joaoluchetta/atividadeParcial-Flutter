import 'package:flutter_atividade_parcial/models/cliente_model.dart';
import 'package:flutter_atividade_parcial/repository/dados_repository.dart';

class CadastroClienteController {
  final DadosRepository _repository = DadosRepository();

  bool salvarNovoCliente({
    required String nome,
    required String cpf,
    required String telefone,
  }) {
    if (nome.trim().isEmpty || cpf.trim().isEmpty) {
      return false;
    }

    final novoCliente = Cliente(
      nome: nome,
      cpf: cpf,
      telefone: telefone,
      // dataNascimento: nascimento,
    );
    _repository.adicionarCliente(novoCliente);

    return true;
  }
}
