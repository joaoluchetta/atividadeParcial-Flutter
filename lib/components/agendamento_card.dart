import 'package:flutter/material.dart';
import 'package:flutter_atividade_parcial/models/agendamento_model.dart';


class AgendamentoCard extends StatelessWidget {
  final Agendamento agendamento;

  const AgendamentoCard({super.key, required this.agendamento});

  @override
  Widget build(BuildContext context) {
    // Definimos a cor da pílula de status baseado no texto
    Color corFundoStatus = agendamento.status == 'CONFIRMED'
        ? const Color(0xFFE0F7FA)
        : Colors.grey.shade200;
    Color corTextoStatus = agendamento.status == 'CONFIRMED'
        ? const Color(0xFF00796B)
        : Colors.grey.shade700;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: agendamento.corBorda, width: 6),
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Linha Superior: Categoria e Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    agendamento.tipo.toUpperCase(),
                    style: const TextStyle(
                      color: Color(0xFF003280),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      letterSpacing: 1,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: corFundoStatus,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      agendamento.status,
                      style: TextStyle(
                        color: corTextoStatus,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Nome do Cliente
              Text(
                agendamento.nomeCliente,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),

              // Horário e Data
              Row(
                children: [
                  _buildIconeTexto(
                    Icons.access_time_filled,
                    'TIME',
                    agendamento.horario,
                  ),
                  const SizedBox(width: 30),
                  _buildIconeTexto(
                    Icons.calendar_month,
                    'DATE',
                    agendamento.data,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Botões
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF003280),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Details',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.more_vert, color: Colors.black54),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Componente interno para economizar código
  Widget _buildIconeTexto(IconData icone, String label, String valor) {
    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: Colors.blue.shade50,
          child: Icon(icone, size: 18, color: const Color(0xFF003280)),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              valor,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
