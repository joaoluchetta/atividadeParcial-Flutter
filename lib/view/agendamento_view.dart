import 'package:flutter/material.dart';
import 'package:flutter_atividade_parcial/components/agendamento_card.dart';
import 'package:flutter_atividade_parcial/models/agendamento_model.dart';

class AgendamentoView extends StatefulWidget {
  const AgendamentoView({super.key});

  @override
  State<AgendamentoView> createState() => _AgendamentoViewState();
}

class _AgendamentoViewState extends State<AgendamentoView> {
  final List<Agendamento> _listaAgendamentos = [
    Agendamento(
      tipo: 'Cardiology Check-up',
      nomeCliente: 'Helena Silvera',
      horario: '09:00 AM',
      data: '24 Oct, 2023',
      status: 'CONFIRMED',
      corBorda: const Color(0xFF003280), // Azul Escuro
    ),
    Agendamento(
      tipo: 'General Consultation',
      nomeCliente: 'Arthur Pendragon',
      horario: '10:30 AM',
      data: '24 Oct, 2023',
      status: 'PENDING',
      corBorda: Colors.blue, // Azul Claro
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Agendamentos',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF003280),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Gerencie seus horários e clientes de forma simples.',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 20),

            // O ListView.builder precisa estar dentro de um Expanded
            // para preencher o espaço restante da tela sem dar erro.
            Expanded(
              child: ListView.builder(
                itemCount:
                    _listaAgendamentos.length, // Quantos itens existem na lista
                itemBuilder: (context, index) {
                  // Passamos o dado específico (index) para o componente desenhar
                  return AgendamentoCard(
                    agendamento: _listaAgendamentos[index],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
