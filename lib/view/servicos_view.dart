import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_atividade_parcial/models/servico_model.dart';
import 'package:flutter_atividade_parcial/services/firestore_service.dart';

class ServicosView extends StatelessWidget {
  ServicosView({super.key});

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
              'Serviços',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF003280),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Cadastre e gerencie os serviços oferecidos.',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: _firestore.stream('servicos'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Erro ao carregar serviços.'),
                    );
                  }

                  final servicos = (snapshot.data?.docs ?? [])
                      .map((d) => Servico.fromDoc(d))
                      .toList()
                    ..sort((a, b) =>
                        a.nome.toLowerCase().compareTo(b.nome.toLowerCase()));

                  if (servicos.isEmpty) {
                    return const Center(
                      child: Text(
                        'Nenhum serviço cadastrado.\nToque no + para adicionar.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.only(bottom: 100),
                    itemCount: servicos.length,
                    itemBuilder: (context, index) =>
                        _buildCard(context, servicos[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF003280),
        onPressed: () => _abrirFormulario(context),
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
    );
  }

  Widget _buildCard(BuildContext context, Servico servico) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: servico.ativo
              ? const Color(0xFFE5F0FA)
              : Colors.grey.shade200,
          child: Icon(
            Icons.medical_services,
            color: servico.ativo ? const Color(0xFF003280) : Colors.grey,
          ),
        ),
        title: Text(
          servico.nome,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${servico.duracaoMinutos} min • R\$ ${servico.preco.toStringAsFixed(2)}'
          '${servico.ativo ? '' : ' • Inativo'}',
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (valor) async {
            if (valor == 'editar') {
              _abrirFormulario(context, servico: servico);
            } else if (valor == 'deletar') {
              await _firestore.remover('servicos', servico.id!);
            }
          },
          itemBuilder: (context) => const [
            PopupMenuItem(value: 'editar', child: Text('Editar')),
            PopupMenuItem(
              value: 'deletar',
              child: Text('Deletar', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
        onTap: () => _abrirFormulario(context, servico: servico),
      ),
    );
  }

  void _abrirFormulario(BuildContext context, {Servico? servico}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _ServicoForm(servico: servico),
    );
  }
}

/// Formulário de criação/edição de serviço (reaproveitado para ambos).
class _ServicoForm extends StatefulWidget {
  final Servico? servico;
  const _ServicoForm({this.servico});

  @override
  State<_ServicoForm> createState() => _ServicoFormState();
}

class _ServicoFormState extends State<_ServicoForm> {
  final _firestore = FirestoreService();
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nomeController;
  late final TextEditingController _descricaoController;
  late final TextEditingController _duracaoController;
  late final TextEditingController _precoController;
  late bool _ativo;
  bool _salvando = false;

  bool get _editando => widget.servico != null;

  @override
  void initState() {
    super.initState();
    final s = widget.servico;
    _nomeController = TextEditingController(text: s?.nome ?? '');
    _descricaoController = TextEditingController(text: s?.descricao ?? '');
    _duracaoController =
        TextEditingController(text: s != null ? '${s.duracaoMinutos}' : '');
    _precoController = TextEditingController(
        text: s != null ? s.preco.toStringAsFixed(2) : '');
    _ativo = s?.ativo ?? true;
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    _duracaoController.dispose();
    _precoController.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    final servico = Servico(
      nome: _nomeController.text.trim(),
      descricao: _descricaoController.text.trim(),
      duracaoMinutos: int.tryParse(_duracaoController.text) ?? 0,
      preco: double.tryParse(_precoController.text.replaceAll(',', '.')) ?? 0,
      ativo: _ativo,
    );

    setState(() => _salvando = true);
    try {
      if (_editando) {
        await _firestore.atualizar('servicos', widget.servico!.id!,
            servico.toMap());
      } else {
        await _firestore.adicionar('servicos', servico.toMap());
      }
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              _editando ? 'Serviço atualizado!' : 'Serviço cadastrado!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _salvando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(
          left: 20, right: 20, top: 20, bottom: bottomInset + 20),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _editando ? 'Editar Serviço' : 'Novo Serviço',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF003280),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _nomeController,
              decoration: _input('Nome do serviço', Icons.medical_services),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Informe o nome' : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _descricaoController,
              decoration: _input('Descrição', Icons.description),
              maxLines: 2,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Informe a descrição' : null,
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _duracaoController,
                    keyboardType: TextInputType.number,
                    decoration: _input('Duração (min)', Icons.timer),
                    validator: (v) {
                      final n = int.tryParse(v ?? '');
                      if (n == null || n <= 0) return 'Inválido';
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _precoController,
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: true),
                    decoration: _input('Preço (R\$)', Icons.attach_money),
                    validator: (v) {
                      final n =
                          double.tryParse((v ?? '').replaceAll(',', '.'));
                      if (n == null || n < 0) return 'Inválido';
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Serviço ativo'),
              activeColor: const Color(0xFF003280),
              value: _ativo,
              onChanged: (v) => setState(() => _ativo = v),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _salvando ? null : _salvar,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF003280),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _salvando
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 3),
                    )
                  : Text(
                      _editando ? 'SALVAR ALTERAÇÕES' : 'CADASTRAR SERVIÇO',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _input(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}
