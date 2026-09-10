import 'package:flutter/material.dart';
import 'galeria_view.dart';
import 'enviar_recado_view.dart';
import 'enviar_foto_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('💍', style: TextStyle(fontSize: 64)),
                  const SizedBox(height: 16),
                  const Text(
                    'Nossas Lembranças',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w300,
                      color: Color(0xFF5D4E37),
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Compartilhe com a gente os momentos\nespeciais deste dia 💛',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF8A7B65),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Botão: Compartilhar foto
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.photo_camera_outlined),
                      label: const Text('Compartilhe uma foto da festa'),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const EnviarFotoView(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Botão: Deixar recado
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.favorite_outline),
                      label: const Text('Deixe um recado aos noivos'),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const EnviarRecadoView(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Botão: Galeria
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.photo_library_outlined),
                      label: const Text('Ver a galeria'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF5D4E37),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Color(0xFFD9CDB8)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const GaleriaView()),
                      ),
                    ),
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
