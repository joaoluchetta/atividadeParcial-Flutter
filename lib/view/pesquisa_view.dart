import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_atividade_parcial/models/cliente_model.dart';
import 'package:flutter_atividade_parcial/services/firestore_service.dart';

/// Tela EXCLUSIVA de pesquisa (RF006).
/// Busca clientes de forma case-insensitive e permite ordenar A-Z / Z-A.
class PesquisaView extends StatefulWidget {
  const PesquisaView({super.key});

  @override
  State<PesquisaView> createState() => _PesquisaViewState();
}

class _PesquisaViewState extends State<PesquisaView> {
  final _firestore = FirestoreService();
  final _termoController = TextEditingController();

  String _termo = '';
  bool _ordemCrescente = true; // A-Z por padrão

  @override
  void dispose() {
    _termoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF003280),
        elevation: 0,
        title: const Text(
          'Pesquisar Clientes',
          style: TextStyle(
            color: Color(0xFF003280),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Campo de busca
            TextField(
              controller: _termoController,
              autofocus: true,
              onChanged: (valor) => setState(() => _termo = valor),
              decoration: InputDecoration(
                hintText: 'Digite o nome do cliente...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _termo.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _termoController.clear();
                          setState(() => _termo = '');
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Controle de ordenação
            Row(
              children: [
                const Icon(Icons.sort, size: 20, color: Colors.grey),
                const SizedBox(width: 8),
                const Text('Ordenar:'),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('A-Z'),
                  selected: _ordemCrescente,
                  selectedColor: const Color(0xFF80E5E5),
                  onSelected: (_) => setState(() => _ordemCrescente = true),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Z-A'),
                  selected: !_ordemCrescente,
                  selectedColor: const Color(0xFF80E5E5),
                  onSelected: (_) => setState(() => _ordemCrescente = false),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: _firestore.stream('clientes'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(child: Text('Erro na pesquisa.'));
                  }

                  final termoBusca = _termo.trim().toLowerCase();

                  // Filtro case-insensitive usando o campo nomeBusca
                  final resultados = (snapshot.data?.docs ?? [])
                      .map((d) => Cliente.fromDoc(d))
                      .where((c) =>
                          termoBusca.isEmpty ||
                          c.nome.toLowerCase().contains(termoBusca))
                      .toList()
                    ..sort((a, b) {
                      final cmp = a.nome
                          .toLowerCase()
                          .compareTo(b.nome.toLowerCase());
                      return _ordemCrescente ? cmp : -cmp;
                    });

                  if (resultados.isEmpty) {
                    return Center(
                      child: Text(
                        termoBusca.isEmpty
                            ? 'Nenhum cliente cadastrado.'
                            : 'Nenhum cliente encontrado para "$_termo".',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.grey, fontSize: 16),
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: resultados.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final c = resultados[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Color(0xFFE5F0FA),
                            child: Icon(Icons.person,
                                color: Color(0xFF003280)),
                          ),
                          title: Text(
                            c.nome,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '${c.telefone}'
                            '${c.endereco.isNotEmpty ? '\n${c.endereco}' : ''}',
                          ),
                          isThreeLine: c.endereco.isNotEmpty,
                        ),
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
}
