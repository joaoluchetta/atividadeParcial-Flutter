import 'package:flutter/material.dart';

class LinhaIconeTexto extends StatelessWidget {
  final IconData icone;
  final String texto;

  const LinhaIconeTexto({super.key, required this.icone, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icone, size: 18, color: const Color(0xFF003280)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            texto,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
