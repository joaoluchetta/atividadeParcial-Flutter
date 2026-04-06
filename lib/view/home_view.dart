import 'package:flutter/material.dart';
import 'package:flutter_atividade_parcial/view/agendamento_view.dart';
import 'package:flutter_atividade_parcial/view/cadastro_cliente_view.dart';
import 'package:flutter_atividade_parcial/view/sobre_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  // Váriavel para controlar qual aba está aberta
  int _abaAtual = 0;

  final List<Widget> _telas = [
    //Placeholder para a tela de listagem
    const AgendamentoView(),

    // Índice 1: Placeholder para a tela de Clientes (para não dar erro de limite)
    const CadastroClienteView(),

    const SobreView(),
  ];

  void _mudarAba(int abaClicada) {
    setState(() {
      _abaAtual = abaClicada;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 20,

        leading: IconButton(
          icon: const Icon(Icons.logout, color: Color(0xFF003280)),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  title: const Text(
                    'Sair do App',
                    style: TextStyle(color: Color(0xFF003280)),
                  ),
                  content: const Text(
                    'Você deseja realmente realizar o logout?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text(
                        'Sair',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),

        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Color(0xFF003280),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.edit_calendar,
                color: Colors.white,
                size: 24,
              ),
            ),
            SizedBox(width: 12),
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
        actions: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.blue.shade100,
            child: const Icon(Icons.person, color: Color(0xFF003280), size: 20),
          ),

          const SizedBox(width: 10),

          // Se der tempo quero implementar as notificações
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.grey),
            onPressed: () {
              print("Abrir notificações");
            },
          ),
          const SizedBox(width: 10),
        ],
      ),

      body: _telas[_abaAtual],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Adiciona um novo card
        },
        backgroundColor: const Color(0xFF003280),
        child: Icon(Icons.add, color: Colors.white, size: 40),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color(0xFF003280),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),

        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),

          BottomNavigationBarItem(
            icon: Icon(Icons.person_add),
            label: 'Clientes',
          ),

          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Sobre'),
        ],

        currentIndex: _abaAtual,
        onTap: _mudarAba, // chamo a função de mudar a aba
      ),
    );
  }
}
