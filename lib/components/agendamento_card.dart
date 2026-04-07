import 'package:flutter/material.dart';
import 'package:flutter_atividade_parcial/components/linha_detalhe.dart';
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
      corFundoStatus = const Color(0xFFE5F0FA);
      corTextoStatus = const Color(0xFF005EB8);
    } else if (agendamento.status == 'DESMARCADO') {
      corFundoStatus = Color(0xFFFFEBEE);
      corTextoStatus = Color(0xFFC62828);
    } else {
      corFundoStatus = Color(0xFFE1BEE7);
      corTextoStatus = Color(0xFF4A148C);
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

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.shade50,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.person,
                                          color: Color(0xFF003280),
                                          size: 28,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Text(
                                          agendamento.nomeCliente,
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF003280),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 20),
                                    child: Divider(thickness: 1),
                                  ),

                                  LinhaDetalhe(
                                    icone: Icons.badge,
                                    titulo: "CPF",
                                    valor: agendamento.cpf.isNotEmpty
                                        ? agendamento.cpf
                                        : 'Não informado',
                                  ),
                                  const SizedBox(height: 16),
                                  LinhaDetalhe(
                                    icone: Icons.phone,
                                    titulo: "Telefone",
                                    valor: agendamento.telefone.isNotEmpty
                                        ? agendamento.telefone
                                        : 'Não informado',
                                  ),
                                  const SizedBox(height: 16),
                                  LinhaDetalhe(
                                    icone: Icons.info_outline,
                                    titulo: "Status",
                                    valor: agendamento.status,
                                  ),

                                  const SizedBox(height: 30),

                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () => Navigator.pop(context),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFF003280,
                                        ),
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 14,
                                        ),
                                        elevation: 0,
                                      ),
                                      child: const Text(
                                        'FECHAR',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
                        'Detalhes',
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
