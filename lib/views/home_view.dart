import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'galeria_view.dart';
import 'enviar_recado_view.dart';
import 'enviar_foto_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final tamanhoTela = MediaQuery.of(context).size;
    // Logo responsivo: menor em telas pequenas
    final tamanhoLogo = tamanhoTela.width < 400 ? 160.0 : 220.0;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo BM
                  SvgPicture.asset(
                    'assets/BM_logo.svg',
                    width: tamanhoLogo,
                    height: tamanhoLogo,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 12),

                  // Ícone de aliança
                  const Text('💍', style: TextStyle(fontSize: 40)),
                  const SizedBox(height: 12),

                  // Título
                  const Text(
                    'Nossas Lembranças',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w300,
                      color: Color(0xFF5D4E37),
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Subtítulo
                  const Text(
                    'Compartilhe com a gente os momentos\nespeciais deste dia 💛',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF8A7B65),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 40),

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
                  const SizedBox(height: 12),

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
                  const SizedBox(height: 12),

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
