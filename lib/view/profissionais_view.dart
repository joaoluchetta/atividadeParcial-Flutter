import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_atividade_parcial/models/profissional_model.dart';
import 'package:flutter_atividade_parcial/services/firestore_service.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class ProfissionaisView extends StatelessWidget {
  ProfissionaisView({super.key});

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
              'Profissionais',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF003280),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Gerencie a equipe de profissionais.',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: _firestore.stream('profissionais'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Erro ao carregar profissionais.'),
                    );
                  }

                  final profissionais = (snapshot.data?.docs ?? [])
                      .map((d) => Profissional.fromDoc(d))
                      .toList()
                    ..sort((a, b) =>
                        a.nome.toLowerCase().compareTo(b.nome.toLowerCase()));

                  if (profissionais.isEmpty) {
                    return const Center(
                      child: Text(
                        'Nenhum profissional cadastrado.\nToque no + para adicionar.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.only(bottom: 100),
                    itemCount: profissionais.length,
                    itemBuilder: (context, index) =>
                        _buildCard(context, profissionais[index]),
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

  Widget _buildCard(BuildContext context, Profissional p) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor:
              p.ativo ? const Color(0xFFE5F0FA) : Colors.grey.shade200,
          child: Icon(
            Icons.badge,
            color: p.ativo ? const Color(0xFF003280) : Colors.grey,
          ),
        ),
        title: Text(
          p.nome,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${p.especialidade} • ${p.telefone}'
          '${p.ativo ? '' : ' • Inativo'}',
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (valor) async {
            if (valor == 'editar') {
              _abrirFormulario(context, profissional: p);
            } else if (valor == 'deletar') {
              await _firestore.remover('profissionais', p.id!);
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
        onTap: () => _abrirFormulario(context, profissional: p),
      ),
    );
  }

  void _abrirFormulario(BuildContext context, {Profissional? profissional}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _ProfissionalForm(profissional: profissional),
    );
  }
}

class _ProfissionalForm extends StatefulWidget {
  final Profissional? profissional;
  const _ProfissionalForm({this.profissional});

  @override
  State<_ProfissionalForm> createState() => _ProfissionalFormState();
}

class _ProfissionalFormState extends State<_ProfissionalForm> {
  final _firestore = FirestoreService();
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nomeController;
  late final TextEditingController _especialidadeController;
  late final TextEditingController _telefoneController;
  late final TextEditingController _emailController;
  late bool _ativo;
  bool _salvando = false;

  final _telefoneFormatter = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  bool get _editando => widget.profissional != null;

  @override
  void initState() {
    super.initState();
    final p = widget.profissional;
    _nomeController = TextEditingController(text: p?.nome ?? '');
    _especialidadeController =
        TextEditingController(text: p?.especialidade ?? '');
    _telefoneController = TextEditingController(text: p?.telefone ?? '');
    _emailController = TextEditingController(text: p?.email ?? '');
    _ativo = p?.ativo ?? true;
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _especialidadeController.dispose();
    _telefoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    final profissional = Profissional(
      nome: _nomeController.text.trim(),
      especialidade: _especialidadeController.text.trim(),
      telefone: _telefoneController.text.trim(),
      email: _emailController.text.trim(),
      ativo: _ativo,
    );

    setState(() => _salvando = true);
    try {
      if (_editando) {
        await _firestore.atualizar(
            'profissionais', widget.profissional!.id!, profissional.toMap());
      } else {
        await _firestore.adicionar('profissionais', profissional.toMap());
      }
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              _editando ? 'Profissional atualizado!' : 'Profissional cadastrado!'),
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
              _editando ? 'Editar Profissional' : 'Novo Profissional',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF003280),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _nomeController,
              decoration: _input('Nome completo', Icons.person),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Informe o nome' : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _especialidadeController,
              decoration: _input('Especialidade', Icons.work),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Informe a especialidade'
                  : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _telefoneController,
              keyboardType: TextInputType.phone,
              inputFormatters: [_telefoneFormatter],
              decoration: _input('Telefone', Icons.phone),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Informe o telefone';
                if (v.length < 15) return 'Telefone incompleto';
                return null;
              },
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: _input('E-mail', Icons.email),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Informe o e-mail';
                if (!v.contains('@') || !v.contains('.')) {
                  return 'E-mail inválido';
                }
                return null;
              },
            ),
            const SizedBox(height: 6),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Profissional ativo'),
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
                      _editando
                          ? 'SALVAR ALTERAÇÕES'
                          : 'CADASTRAR PROFISSIONAL',
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
