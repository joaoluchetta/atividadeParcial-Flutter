import 'package:flutter/material.dart';

class Agendamento {
  final String tipo;
  final String nomeCliente;
  final String cpf;
  final String telefone;
  final String horario;
  final String data;
  String status;
  final Color corBorda;

  Agendamento({
    required this.tipo,
    required this.nomeCliente,
    required this.cpf,
    required this.telefone,
    required this.horario,
    required this.data,
    required this.status,
    required this.corBorda,
  });
}
