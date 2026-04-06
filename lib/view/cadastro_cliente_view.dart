import 'package:flutter/material.dart';

class CadastroClienteView extends StatefulWidget {
  const CadastroClienteView({super.key});

  @override
  State<CadastroClienteView> createState() => _CadastroClienteViewState();
}

class _CadastroClienteViewState extends State<CadastroClienteView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      body: SingleChildScrollView(
        // Adicionamos um padding geral para a tela toda não encostar nas bordas
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Alinha o cabeçalho à esquerda
          children: [
            // --- CABEÇALHO ---
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

            const SizedBox(height: 20), // Espaço entre o cabeçalho e o Card
            // --- O SEU CARD COMEÇA AQUI ---
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.edit_calendar,
                          color: Color(0xFF003280),
                        ),
                        const SizedBox(width: 10),
                        const Text(
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
                    TextField(
                      keyboardType: TextInputType.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Nome completo',
                        hintText: 'Ex: José Silva',
                        prefixIcon: const Icon(Icons.person),
                        filled: true,
                        fillColor: const Color(0xFFE0E3E5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      keyboardType: TextInputType
                          .number, // Ajustado de 'none' para 'number'
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        labelText: 'CPF',
                        hintText: '000.000.000-00',
                        prefixIcon: const Icon(Icons.document_scanner),
                        filled: true,
                        fillColor: const Color(0xFFE0E3E5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Telefone',
                        hintText: '(16) 99999-9999',
                        prefixIcon: const Icon(Icons.phone),
                        filled: true,
                        fillColor: const Color(0xFFE0E3E5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // BOTÃO DE CADASTRAR
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                          0xFF003280,
                        ), // Azul escuro do Schedly
                        foregroundColor: Colors.white, // Cor do texto
                        minimumSize: const Size(
                          double.infinity,
                          50,
                        ), // Botão largo
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 2,
                      ),
                      child: const Text(
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
          ],
        ),
      ),
    );
  }
}
