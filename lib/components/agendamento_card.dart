import 'package:flutter/material.dart';
import 'package:flutter_atividade_parcial/models/agendamento_model.dart';
import 'package:flutter_atividade_parcial/repository/dados_repository.dart';

class AgendamentoCard extends StatelessWidget {
  final Agendamento agendamento;
  final VoidCallback onUpdate;

  const AgendamentoCard({
    super.key,
    required this.agendamento,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    Color corFundoStatus;
    Color corTextoStatus;

    if (agendamento.status == 'CONFIRMADO') {
      corFundoStatus = const Color(0xFFE0F7FA);
      corTextoStatus = const Color(0xFF00796B);
    } else if (agendamento.status == 'PENDENTE') {
      corFundoStatus = Colors.orange.shade100;
      corTextoStatus = Colors.orange.shade900;
    } else if (agendamento.status == 'DESMARCADO') {
      corFundoStatus = Colors.red.shade100;
      corTextoStatus = Colors.red.shade900;
    } else {
      corFundoStatus = Colors.purple.shade100;
      corTextoStatus = Colors.purple.shade900;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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

              Text(
                agendamento.nomeCliente,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),

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
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(agendamento.nomeCliente),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("CPF: ${agendamento.cpf}"),
                                Text("Telefone: ${agendamento.telefone}"),
                                Text("Status: ${agendamento.status}"),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Fechar"),
                              ),
                            ],
                          ),
                        );
                      },
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
                    child: PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, color: Colors.black54),
                      onSelected: (String valorSelecionado) {
                        if (valorSelecionado == 'Deletar') {
                          DadosRepository().removerAgendamento(agendamento);
                        } else {
                          agendamento.status = valorSelecionado;
                        }
                        onUpdate();
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                            const PopupMenuItem<String>(
                              value: 'CONFIRMADO',
                              child: Text('Marcar como Confirmado'),
                            ),
                            const PopupMenuItem<String>(
                              value: 'PENDENTE',
                              child: Text('Marcar como Pendente'),
                            ),
                            const PopupMenuItem<String>(
                              value: 'DESMARCADO',
                              child: Text('Marcar como Desmarcado'),
                            ),
                            const PopupMenuItem<String>(
                              value: 'REPOSIÇÃO',
                              child: Text('Marcar como Reposição'),
                            ),
                            const PopupMenuDivider(),
                            const PopupMenuItem<String>(
                              value: 'Deletar',
                              child: Text(
                                'Deletar Card',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
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
