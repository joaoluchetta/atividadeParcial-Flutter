import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_atividade_parcial/components/agendamento_card.dart';
import 'package:flutter_atividade_parcial/models/agendamento_model.dart';
import 'package:flutter_atividade_parcial/services/firestore_service.dart';

class AgendamentoView extends StatefulWidget {
  const AgendamentoView({super.key});

  @override
  State<AgendamentoView> createState() => _AgendamentoViewState();
}

class _AgendamentoViewState extends State<AgendamentoView> {
  String _buscaNome = '';
  String _statusSelecionado = 'Todos';

  final List<String> _opcoesStatus = [
    'Todos',
    'Confirmado',
    'Pendente',
    'Desmarcado',
    'Reposição',
  ];

  final _firestore = FirestoreService();

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

            _buildSessaoFiltros(),
            const SizedBox(height: 20),

            // --- LISTA DE AGENDAMENTOS EM TEMPO REAL (RF005) ---
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: _firestore.stream('agendamentos'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text(
                        'Erro ao carregar agendamentos.',
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    );
                  }

                  final docs = (snapshot.data?.docs ?? []).toList()
                    ..sort((a, b) {
                      final ta = a.data()['criadoEm'] as Timestamp?;
                      final tb = b.data()['criadoEm'] as Timestamp?;
                      if (ta == null) return 1;
                      if (tb == null) return -1;
                      return tb.compareTo(ta); // mais recentes primeiro
                    });

                  final todos =
                      docs.map((doc) => Agendamento.fromDoc(doc)).toList();

                  final listaParaExibir = todos.where((agendamento) {
                    final bateNome = agendamento.nomeCliente
                        .toLowerCase()
                        .contains(_buscaNome.toLowerCase());
                    final bateStatus = _statusSelecionado == 'Todos' ||
                        agendamento.status.toUpperCase() ==
                            _statusSelecionado.toUpperCase();
                    return bateNome && bateStatus;
                  }).toList();

                  if (listaParaExibir.isEmpty) {
                    return const Center(
                      child: Text(
                        "Nenhum agendamento encontrado.",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.only(bottom: 100),
                    itemCount: listaParaExibir.length,
                    itemBuilder: (context, index) {
                      return AgendamentoCard(
                        agendamento: listaParaExibir[index],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // COMPONENTE VISUAL DOS FILTROS
  // ==========================================
  Widget _buildSessaoFiltros() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            onChanged: (valorDigitado) {
              setState(() {
                _buscaNome = valorDigitado;
              });
            },
            decoration: InputDecoration(
              hintText: 'Procurar pacientes...',
              hintStyle: TextStyle(color: Colors.grey.shade400),
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: Colors.grey.shade50,
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Lista horizontal de Status
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: _opcoesStatus.map((status) {
                final bool isSelecionado = _statusSelecionado == status;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(
                      status,
                      style: TextStyle(
                        color: isSelecionado
                            ? const Color(0xFF005050)
                            : Colors.black87,
                        fontWeight: isSelecionado
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    selected: isSelecionado,
                    selectedColor: const Color(0xFF80E5E5),
                    backgroundColor: Colors.grey.shade100,
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    onSelected: (bool selecionado) {
                      setState(() {
                        if (selecionado) {
                          _statusSelecionado = status;
                        }
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
