import 'package:flutter/material.dart';

class Agendamento {
  final String tipo; // Ex: CARDIOLOGY CHECK-UP
  final String nomeCliente; // Ex: Helena Silvera
  final String horario; // Ex: 09:00 AM
  final String data; // Ex: 24 Oct, 2023
  final String status; // Ex: CONFIRMED
  final Color corBorda; // Para a faixinha lateral esquerda

  Agendamento({
    required this.tipo,
    required this.nomeCliente,
    required this.horario,
    required this.data,
    required this.status,
    required this.corBorda,
  });
}