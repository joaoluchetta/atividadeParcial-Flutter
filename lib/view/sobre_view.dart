import 'package:flutter/material.dart';
import 'package:flutter_atividade_parcial/components/linha_icone_texto.dart';

class SobreView extends StatelessWidget {
  const SobreView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),      
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildCabecalho(),
            const SizedBox(height: 40),
            _buildCardSobreApp(),
            const SizedBox(height: 20),
            _buildCardDesenvolvimento(),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// Logo, Nome e Versão
// ==========================================
Widget _buildCabecalho() {
  return Column(
    children: [
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF003280),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: const Icon(Icons.edit_calendar, color: Colors.white, size: 40),
      ),
      const SizedBox(height: 20),

      const Text(
        'Schedly',
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Color(0xFF003280),
        ),
      ),
      const SizedBox(height: 10),

      const Text(
        'Sua jornada para a organização começa\nem um ambiente de inovação digital.',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.5),
      ),
      const SizedBox(height: 15),

      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF80E5E5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text(
          'Versão 1.0.0 (Alpha)',
          style: TextStyle(
            color: Color(0xFF005050),
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    ],
  );
}

// ==========================================
// CARD (Sobre o App)
// ==========================================
Widget _buildCardSobreApp() {
  return Card(
    elevation: 4,
    //color: Color(0xFFF2F4F6),
    shadowColor: Colors.black,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.business, color: Color(0xFF003280)),
          const SizedBox(height: 15),
          const Text(
            'O Aplicativo',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            'O Schedly foi projetado para facilitar o agendamento e o controle de horários. Oferecemos uma interface intuitiva focada em produtividade e bem-estar no seu dia a dia profissional.',
            style: TextStyle(color: Colors.grey, height: 1.5),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF003280),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Acessar Repositório'),
          ),
        ],
      ),
    ),
  );
}

// ==========================================
// CARD (Desenvolvimento)
// ==========================================
Widget _buildCardDesenvolvimento() {
  return Card(
    elevation: 0,
    color: const Color(0xFFF8FAFC),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
      side: BorderSide(color: Colors.grey.shade200),
    ),
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.code, color: Color(0xFF00796B)),
          const SizedBox(height: 15),
          const Text(
            'Desenvolvimento',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            'Desenvolver um aplicativo multiplataforma de acordo com o tema de sua preferência.',
            style: TextStyle(color: Colors.grey, height: 1.5),
          ),
          const SizedBox(height: 20),

          LinhaIconeTexto(
            icone: Icons.menu_book,
            texto: 'Desenvolvimento Mobile II',
          ),
          const SizedBox(height: 10),
          LinhaIconeTexto(
            icone: Icons.person,
            texto: 'Aluno: João Pedro Luchetta - 769231',
          ),
          const SizedBox(height: 10),
          LinhaIconeTexto(
            icone: Icons.co_present,
            texto: 'Professor: Rodrigo de Oliveira Plotze',
          ),
          const SizedBox(height: 10),
          LinhaIconeTexto(
            icone: Icons.school,
            texto: 'Universidade de Ribeirão Preto (UNAERP)',
          ),
        ],
      ),
    ),
  );
}
