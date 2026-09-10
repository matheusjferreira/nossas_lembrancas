import 'package:flutter/material.dart';
import '../models/foto.dart';

class DetalheFotoView extends StatelessWidget {
  final Foto foto;
  const DetalheFotoView({super.key, required this.foto});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF9),
      appBar: AppBar(
        title: const Text('Detalhes da foto'),
        backgroundColor: const Color(0xFFF5EFE3),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Foto grande
                Image.network(
                  foto.fotoUrl,
                  fit: BoxFit.contain,
                  frameBuilder: (_, child, frame, wasSynchronouslyLoaded) {
                    if (wasSynchronouslyLoaded) return child;
                    if (frame != null) return child;
                    return Container(
                      height: 300,
                      color: const Color(0xFFF5EFE3),
                      child: const Center(
                        child: Icon(
                          Icons.photo_outlined,
                          color: Color(0xFFB8A88A),
                          size: 48,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (_, _, _) => const SizedBox(
                    height: 300,
                    child: Center(
                      child: Icon(
                        Icons.broken_image_outlined,
                        size: 80,
                        color: Color(0xFFB8A88A),
                      ),
                    ),
                  ),
                ),

                // Legenda (só se existir)
                if (foto.legenda.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Card(
                    elevation: 0,
                    color: const Color(0xFFFBF7EF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const CircleAvatar(
                                backgroundColor: Color(0xFFE8DCC8),
                                child: Icon(
                                  Icons.person,
                                  color: Color(0xFFB8A88A),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  foto.nome,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF5D4E37),
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            foto.legenda,
                            style: const TextStyle(
                              color: Color(0xFF5D4E37),
                              height: 1.5,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
