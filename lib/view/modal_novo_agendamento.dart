import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_atividade_parcial/models/cliente_model.dart';
import 'package:flutter_atividade_parcial/models/agendamento_model.dart';
import 'package:flutter_atividade_parcial/repository/dados_repository.dart';

class ModalNovoAgendamento extends StatefulWidget {
  const ModalNovoAgendamento({super.key});

  @override
  State<ModalNovoAgendamento> createState() => _ModalNovoAgendamentoState();
}

class _ModalNovoAgendamentoState extends State<ModalNovoAgendamento> {
  final List<Cliente> _clientesDisponiveis = DadosRepository().listarClientes();

  Cliente? _clienteSelecionado;
  final _dataController = TextEditingController();
  final _horarioController = TextEditingController();

  Color _sortearCor() {
    List<Color> cores = [
      const Color(0xFF003280),
      Colors.blue,
      const Color(0xFF80E5E5),
    ];
    return cores[Random().nextInt(cores.length)];
  }

  Future<void> _selecionarData(BuildContext context) async {
    final DateTime? dataEscolhida = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (dataEscolhida != null) {
      setState(() {
        String dia = dataEscolhida.day.toString().padLeft(2, '0');
        String mes = dataEscolhida.month.toString().padLeft(2, '0');
        String ano = dataEscolhida.year.toString();
        _dataController.text = "$dia/$mes/$ano";
      });
    }
  }

  Future<void> _selecionarHorario(BuildContext context) async {
    final TimeOfDay? horarioEscolhido = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (horarioEscolhido != null) {
      setState(() {
        _horarioController.text = horarioEscolhido.format(context);
      });
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

            if (_clientesDisponiveis.isEmpty)
              const Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Text(
                  'Nenhum cliente cadastrado.',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            else
              DropdownButtonFormField<Cliente>(
                decoration: InputDecoration(
                  labelText: 'Selecione o Cliente',
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: _clientesDisponiveis.map((cliente) {
                  return DropdownMenuItem(
                    value: cliente,
                    child: Text(cliente.nome),
                  );
                }).toList(),
                onChanged: (Cliente? valor) {
                  setState(() {
                    _clienteSelecionado = valor;
                  });
                },
              ),

            const SizedBox(height: 15),

            TextField(
              controller: _dataController,
              readOnly: true,
              onTap: () => _selecionarData(context),
              decoration: InputDecoration(
                labelText: 'Data da Consulta',
                prefixIcon: const Icon(
                  Icons.calendar_today,
                  color: Color(0xFF003280),
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 15),

            TextField(
              controller: _horarioController,
              readOnly: true,
              onTap: () => _selecionarHorario(context),
              decoration: InputDecoration(
                labelText: 'Horário',
                prefixIcon: const Icon(
                  Icons.access_time,
                  color: Color(0xFF003280),
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 25),

            // BOTÃO DE SALVAR
            ElevatedButton(
              onPressed: () {
                if (_clienteSelecionado != null &&
                    _dataController.text.isNotEmpty &&
                    _horarioController.text.isNotEmpty) {
                  final novoAgendamento = Agendamento(
                    tipo: 'Consulta Geral',
                    nomeCliente: _clienteSelecionado!.nome,
                    horario: _horarioController.text,
                    data: _dataController.text,
                    status: 'PENDENTE',
                    corBorda: _sortearCor(),
                    cpf: '',
                    telefone: '',
                  );

                  DadosRepository().adicionarAgendamento(novoAgendamento);

                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF003280),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'CONFIRMAR AGENDAMENTO',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
