import 'package:flutter_atividade_parcial/models/cliente_model.dart';
import '../models/agendamento_model.dart';

class DadosRepository {
  static final DadosRepository _instance = DadosRepository._internal();
  factory DadosRepository() => _instance;
  DadosRepository._internal();

  final List<Cliente> _clientes = [];
  final List<Agendamento> _agendamentos = [];

  // --- MÉTODOS PARA CLIENTES ---
  void adicionarCliente(Cliente novo) {
    _clientes.add(novo);
  }

  List<Cliente> listarClientes() {
    return _clientes;
  }

  // --- MÉTODOS PARA AGENDAMENTOS ---
  void adicionarAgendamento(Agendamento novo) {
    _agendamentos.add(novo);
  }

  List<Agendamento> listarAgendamentos() {
    return _agendamentos;
  }

  void removerAgendamento(Agendamento agendamento) =>
      _agendamentos.remove(agendamento);
}
