import 'package:flutter/material.dart';

class LinhaDetalhe extends StatelessWidget {
  final IconData icone;
  final String titulo;
  final String valor;

  const LinhaDetalhe({
    super.key,
    required this.icone,
    required this.titulo,
    required this.valor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icone, size: 20, color: Colors.grey.shade600),
        const SizedBox(width: 12),
        // O Expanded aqui (opcional) ajuda a evitar erro de overflow se o texto do 'valor' for muito longo
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titulo,
                style: TextStyle(
                  fontSize: 12, 
                  color: Colors.grey.shade600, 
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                valor,
                style: const TextStyle(
                  fontSize: 16, 
                  fontWeight: FontWeight.w600, 
                  color: Colors.black87,
                ),
                softWrap: true, // Permite a quebra de linha automática
              ),
            ],
          ),
        ),
      ],
    );
  }
}