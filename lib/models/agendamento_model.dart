import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Agendamento {
  final String? id; // id do documento no Firestore
  final String servico; // serviço que o cliente vai realizar
  final String profissional; // profissional responsável (opcional)
  final String nomeCliente;
  final String cpf;
  final String telefone;
  final String horario;
  final String data;
  final String status;

  Agendamento({
    this.id,
    required this.servico,
    this.profissional = '',
    required this.nomeCliente,
    required this.cpf,
    required this.telefone,
    required this.horario,
    required this.data,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'servico': servico,
      'profissional': profissional,
      'nomeCliente': nomeCliente,
      'nomeBusca': nomeCliente.toLowerCase(),
      'cpf': cpf,
      'telefone': telefone,
      'horario': horario,
      'data': data,
      'status': status,
    };
  }

  factory Agendamento.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return Agendamento(
      id: doc.id,
      // 'tipo' é mantido como fallback para agendamentos antigos
      servico: data['servico'] ?? data['tipo'] ?? 'Consulta',
      profissional: data['profissional'] ?? '',
      nomeCliente: data['nomeCliente'] ?? '',
      cpf: data['cpf'] ?? '',
      telefone: data['telefone'] ?? '',
      horario: data['horario'] ?? '',
      data: data['data'] ?? '',
      status: data['status'] ?? 'PENDENTE',
    );
  }

  /// Cor da borda lateral derivada do status (substitui a cor aleatória antiga).
  Color get corBorda {
    switch (status.toUpperCase()) {
      case 'CONFIRMADO':
        return const Color(0xFF00796B);
      case 'DESMARCADO':
        return const Color(0xFFC62828);
      case 'REPOSIÇÃO':
        return const Color(0xFF4A148C);
      case 'PENDENTE':
      default:
        return const Color(0xFF003280);
    }
  }
}
