import 'package:flutter/material.dart';
import 'package:flutter_atividade_parcial/controller/cadastro_cliente_controller.dart';
import 'package:flutter_atividade_parcial/services/cep_service.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CadastroClienteView extends StatefulWidget {
  const CadastroClienteView({super.key});

  @override
  State<CadastroClienteView> createState() => _CadastroClienteViewState();
}

class _CadastroClienteViewState extends State<CadastroClienteView> {
  final _controller = CadastroClienteController();
  final _cepService = CepService();
  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _cpfController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _cepController = TextEditingController();
  final _enderecoController = TextEditingController();

  bool _carregando = false;
  bool _buscandoCep = false;

  var telefoneFormatter = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );
  var cpfFormatter = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')},
  );
  var cepFormatter = MaskTextInputFormatter(
    mask: '#####-###',
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  void dispose() {
    _nomeController.dispose();
    _cpfController.dispose();
    _telefoneController.dispose();
    _emailController.dispose();
    _cepController.dispose();
    _enderecoController.dispose();
    super.dispose();
  }

  Future<void> _buscarCep() async {
    FocusScope.of(context).unfocus();
    setState(() => _buscandoCep = true);
    try {
      final endereco = await _cepService.buscarPorCep(_cepController.text);
      _enderecoController.text = endereco.completo;
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _buscandoCep = false);
    }
  }

  Future<void> _salvarCliente() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _carregando = true);
    try {
      await _controller.salvarNovoCliente(
        nome: _nomeController.text,
        cpf: _cpfController.text,
        telefone: _telefoneController.text,
        email: _emailController.text,
        cep: _cepController.text,
        endereco: _enderecoController.text,
      );
      if (!mounted) return;
      _nomeController.clear();
      _cpfController.clear();
      _telefoneController.clear();
      _emailController.clear();
      _cepController.clear();
      _enderecoController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cliente cadastrado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Novo Cliente',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1D1D1D),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Cadastre um novo cliente para organizar seus agendamentos e manter sua base de contatos atualizada.',
              style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.5),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.edit_calendar, color: Color(0xFF003280)),
                          SizedBox(width: 10),
                          Text(
                            'Schedly',
                            style: TextStyle(
                              color: Color(0xFF003280),
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _nomeController,
                        keyboardType: TextInputType.name,
                        decoration: _input('Nome completo', Icons.person,
                            hint: 'Ex: José Silva'),
                        validator: (value) =>
                            (value == null || value.trim().isEmpty)
                                ? 'Informe o nome do cliente'
                                : null,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _cpfController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [cpfFormatter],
                        decoration: _input('CPF', Icons.badge,
                            hint: '000.000.000-00'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Informe o CPF';
                          }
                          if (value.length < 14) return 'CPF incompleto';
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _telefoneController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [telefoneFormatter],
                        decoration: _input('Telefone', Icons.phone,
                            hint: '(16) 99999-9999'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Informe o telefone';
                          }
                          if (value.length < 15) return 'Telefone incompleto';
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: _input('E-mail', Icons.email,
                            hint: 'cliente@email.com'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Informe o e-mail';
                          }
                          if (!value.contains('@') || !value.contains('.')) {
                            return 'E-mail inválido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      // CEP + botão de busca via ViaCEP (RF007)
                      TextFormField(
                        controller: _cepController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [cepFormatter],
                        decoration: _input('CEP', Icons.location_on,
                            hint: '00000-000').copyWith(
                          suffixIcon: _buscandoCep
                              ? const Padding(
                                  padding: EdgeInsets.all(12),
                                  child: SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                )
                              : IconButton(
                                  icon: const Icon(Icons.search,
                                      color: Color(0xFF003280)),
                                  onPressed: _buscarCep,
                                ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _enderecoController,
                        decoration: _input('Endereço', Icons.home,
                            hint: 'Preenchido pelo CEP'),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _carregando ? null : _salvarCliente,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF003280),
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 2,
                        ),
                        child: _carregando
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ),
                              )
                            : const Text(
                                'CADASTRAR CLIENTE',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _input(String label, IconData icon, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: const Color(0xFFE0E3E5),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
    );
  }
}
