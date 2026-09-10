import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/foto.dart';
import '../viewmodels/app_viewmodel.dart';
import 'detalhe_foto_view.dart';

class GaleriaView extends StatelessWidget {
  const GaleriaView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.read<AppViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Galeria de fotos')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: StreamBuilder<List<Foto>>(
            stream: vm.fotosStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Erro: ${snapshot.error}'));
              }
              final fotos = snapshot.data ?? [];
              if (fotos.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Text(
                      'Ainda não há fotos.\nSeja o primeiro a compartilhar 💛',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFF8A7B65), fontSize: 16),
                    ),
                  ),
                );
              }

              return GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 220,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1,
                ),
                itemCount: fotos.length,
                itemBuilder: (_, i) => _GridFoto(foto: fotos[i]),
              );
            },
          ),
        ),
      ),
    );
  }
}

// ============ ITEM DE FOTO NO GRID ============
class _GridFoto extends StatelessWidget {
  final Foto foto;
  const _GridFoto({required this.foto});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => DetalheFotoView(foto: foto)),
      ),
      child: ClipRRect(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              foto.fotoUrl,
              fit: BoxFit.cover,
              gaplessPlayback: true,
              frameBuilder: (_, child, frame, wasSynchronouslyLoaded) {
                if (wasSynchronouslyLoaded) return child;
                if (frame != null) return child;
                return Container(
                  color: const Color(0xFFF5EFE3),
                  child: const Center(
                    child: Icon(
                      Icons.photo_outlined,
                      color: Color(0xFFB8A88A),
                      size: 32,
                    ),
                  ),
                );
              },
              errorBuilder: (_, _, _) => Container(
                color: const Color(0xFFF5EFE3),
                child: const Center(
                  child: Icon(
                    Icons.broken_image_outlined,
                    color: Color(0xFFB8A88A),
                    size: 32,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.6),
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.person, color: Colors.white, size: 12),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        foto.nome,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
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
