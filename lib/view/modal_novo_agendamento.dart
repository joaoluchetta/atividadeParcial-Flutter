import 'package:flutter/material.dart';
import 'package:flutter_atividade_parcial/models/cliente_model.dart';
import 'package:flutter_atividade_parcial/models/servico_model.dart';
import 'package:flutter_atividade_parcial/models/profissional_model.dart';
import 'package:flutter_atividade_parcial/models/agendamento_model.dart';
import 'package:flutter_atividade_parcial/services/firestore_service.dart';

class ModalNovoAgendamento extends StatefulWidget {
  const ModalNovoAgendamento({super.key});

  @override
  State<ModalNovoAgendamento> createState() => _ModalNovoAgendamentoState();
}

class _ModalNovoAgendamentoState extends State<ModalNovoAgendamento> {
  final _firestore = FirestoreService();

  List<Cliente> _clientesDisponiveis = [];
  List<Servico> _servicosDisponiveis = [];
  List<Profissional> _profissionaisDisponiveis = [];
  bool _carregando = true;
  bool _salvando = false;

  Cliente? _clienteSelecionado;
  Servico? _servicoSelecionado;
  Profissional? _profissionalSelecionado;
  final _dataController = TextEditingController();
  final _horarioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    try {
      final results = await Future.wait([
        _firestore.buscarUmaVez('clientes'),
        _firestore.buscarUmaVez('servicos'),
        _firestore.buscarUmaVez('profissionais'),
      ]);
      if (!mounted) return;

      final clientes = results[0].docs.map((d) => Cliente.fromDoc(d)).toList()
        ..sort((a, b) =>
            a.nome.toLowerCase().compareTo(b.nome.toLowerCase()));
      final servicos = results[1].docs.map((d) => Servico.fromDoc(d)).toList()
        ..sort((a, b) =>
            a.nome.toLowerCase().compareTo(b.nome.toLowerCase()));
      final profissionais =
          results[2].docs.map((d) => Profissional.fromDoc(d)).toList()
            ..sort((a, b) =>
                a.nome.toLowerCase().compareTo(b.nome.toLowerCase()));

      setState(() {
        _clientesDisponiveis = clientes;
        _servicosDisponiveis = servicos;
        _profissionaisDisponiveis = profissionais;
        _carregando = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _carregando = false);
    }
  }

  Future<void> _selecionarData() async {
    final DateTime? dataEscolhida = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (dataEscolhida != null) {
      String dia = dataEscolhida.day.toString().padLeft(2, '0');
      String mes = dataEscolhida.month.toString().padLeft(2, '0');
      String ano = dataEscolhida.year.toString();
      _dataController.text = "$dia/$mes/$ano";
    }
  }

  Future<void> _selecionarHorario() async {
    final TimeOfDay? horarioEscolhido = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (horarioEscolhido == null) return;
    if (!mounted) return;
    _horarioController.text = horarioEscolhido.format(context);
  }

  Future<void> _salvarAgendamento() async {
    if (_clienteSelecionado == null ||
        _servicoSelecionado == null ||
        _dataController.text.isEmpty ||
        _horarioController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione cliente, serviço, data e horário.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _salvando = true);
    try {
      final novoAgendamento = Agendamento(
        servico: _servicoSelecionado!.nome,
        profissional: _profissionalSelecionado?.nome ?? '',
        nomeCliente: _clienteSelecionado!.nome,
        cpf: _clienteSelecionado!.cpf,
        telefone: _clienteSelecionado!.telefone,
        horario: _horarioController.text,
        data: _dataController.text,
        status: 'PENDENTE',
      );

      await _firestore.adicionar('agendamentos', novoAgendamento.toMap());
      if (!mounted) return;
      Navigator.pop(context);
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
  void dispose() {
    _dataController.dispose();
    _horarioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: bottomInset + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Novo Agendamento',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF003280),
              ),
            ),
            const SizedBox(height: 20),

            if (_carregando)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: Center(child: CircularProgressIndicator()),
              )
            else ...[
              if (_clientesDisponiveis.isEmpty)
                _aviso('Nenhum cliente cadastrado. Cadastre um cliente primeiro.')
              else
                DropdownButtonFormField<Cliente>(
                  value: _clienteSelecionado,
                  isExpanded: true,
                  decoration: _dropDecoration('Cliente', Icons.person),
                  items: _clientesDisponiveis
                      .map((c) => DropdownMenuItem(
                            value: c,
                            child: Text(c.nome),
                          ))
                      .toList(),
                  onChanged: (valor) =>
                      setState(() => _clienteSelecionado = valor),
                ),
              const SizedBox(height: 15),

              if (_servicosDisponiveis.isEmpty)
                _aviso('Nenhum serviço cadastrado. Cadastre um serviço primeiro.')
              else
                DropdownButtonFormField<Servico>(
                  value: _servicoSelecionado,
                  isExpanded: true,
                  decoration:
                      _dropDecoration('Serviço', Icons.medical_services),
                  items: _servicosDisponiveis
                      .map((s) => DropdownMenuItem(
                            value: s,
                            child: Text(
                              '${s.nome}  •  R\$ ${s.preco.toStringAsFixed(2)}',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ))
                      .toList(),
                  onChanged: (valor) =>
                      setState(() => _servicoSelecionado = valor),
                ),
              const SizedBox(height: 15),

              // Profissional é opcional
              DropdownButtonFormField<Profissional>(
                value: _profissionalSelecionado,
                isExpanded: true,
                decoration: _dropDecoration(
                  'Profissional (opcional)',
                  Icons.badge,
                ),
                items: _profissionaisDisponiveis
                    .map((p) => DropdownMenuItem(
                          value: p,
                          child: Text(
                            '${p.nome} (${p.especialidade})',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ))
                    .toList(),
                onChanged: (valor) =>
                    setState(() => _profissionalSelecionado = valor),
              ),
              const SizedBox(height: 15),

              TextField(
                controller: _dataController,
                readOnly: true,
                onTap: _selecionarData,
                decoration:
                    _dropDecoration('Data da Consulta', Icons.calendar_today),
              ),
              const SizedBox(height: 15),

              TextField(
                controller: _horarioController,
                readOnly: true,
                onTap: _selecionarHorario,
                decoration: _dropDecoration('Horário', Icons.access_time),
              ),
              const SizedBox(height: 25),

              ElevatedButton(
                onPressed: _salvando ? null : _salvarAgendamento,
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
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                    : const Text(
                        'CONFIRMAR AGENDAMENTO',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _aviso(String texto) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Text(
          texto,
          style: const TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

  InputDecoration _dropDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: const Color(0xFF003280)),
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}
