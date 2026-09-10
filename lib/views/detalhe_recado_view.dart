import 'package:flutter/material.dart';
import '../models/recado.dart';

class DetalheRecadoView extends StatelessWidget {
  final Recado recado;
  const DetalheRecadoView({super.key, required this.recado});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF9),
      appBar: AppBar(
        title: const Text('Recado'),
        backgroundColor: const Color(0xFFF5EFE3),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFBF7EF),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE8DCC8), width: 1),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ícone de aspas
                  const Icon(
                    Icons.format_quote,
                    color: Color(0xFFE8DCC8),
                    size: 40,
                  ),
                  const SizedBox(height: 8),

                  // Mensagem
                  Text(
                    recado.mensagem,
                    style: const TextStyle(
                      color: Color(0xFF5D4E37),
                      fontSize: 18,
                      height: 1.7,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Divisor
                  const Divider(color: Color(0xFFE8DCC8), height: 1),
                  const SizedBox(height: 16),

                  // Autor
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 18,
                        backgroundColor: Color(0xFFE8DCC8),
                        child: Icon(
                          Icons.person,
                          color: Color(0xFFB8A88A),
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              recado.nome,
                              style: const TextStyle(
                                color: Color(0xFF5D4E37),
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Text(
                              'com carinho 💛',
                              style: TextStyle(
                                color: Color(0xFF8A7B65),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
