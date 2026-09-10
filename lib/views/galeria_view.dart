import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/recado.dart';
import '../viewmodels/app_viewmodel.dart';

class GaleriaView extends StatelessWidget {
  const GaleriaView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.read<AppViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Galeria de recordações')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: StreamBuilder<List<Recado>>(
            stream: vm.recadosStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Erro: ${snapshot.error}'));
              }
              final recados = snapshot.data ?? [];
              if (recados.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Text(
                      'Ainda não há recados.\nSeja o primeiro a compartilhar 💛',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFF8A7B65), fontSize: 16),
                    ),
                  ),
                );
              }

              // 👇 GRID estilo Instagram
              return GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 220, // largura máxima de cada célula
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1, // quadrado (1:1) igual Instagram
                ),
                itemCount: recados.length,
                itemBuilder: (_, i) => _GridItem(recado: recados[i]),
              );
            },
          ),
        ),
      ),
    );
  }
}

// ============ ITEM DO GRID ============
class _GridItem extends StatelessWidget {
  final Recado recado;
  const _GridItem({required this.recado});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _abrirDetalhe(context),
      child: ClipRRect(
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Fundo
            if (recado.fotoUrl != null)
              Image.network(
                recado.fotoUrl!,
                fit: BoxFit.cover,
                loadingBuilder: (_, child, progress) => progress == null
                    ? child
                    : Container(
                        color: const Color(0xFFF5EFE3),
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                errorBuilder: (_, __, ___) => Container(
                  color: const Color(0xFFF5EFE3),
                  child: const Icon(
                    Icons.broken_image_outlined,
                    color: Color(0xFFB8A88A),
                  ),
                ),
              )
            else
              Container(
                color: const Color(0xFFF5EFE3),
                padding: const EdgeInsets.all(12),
                alignment: Alignment.center,
                child: Text(
                  recado.mensagem,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF5D4E37),
                    fontSize: 13,
                    height: 1.3,
                  ),
                ),
              ),

            // Overlay escuro no rodapé com o nome
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
                    colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.favorite, color: Colors.white, size: 12),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        recado.nome,
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

  void _abrirDetalhe(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => _DetalheView(recado: recado)),
    );
  }
}

// ============ TELA DE DETALHE (foto grande) ============
class _DetalheView extends StatelessWidget {
  final Recado recado;
  const _DetalheView({required this.recado});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF9),
      appBar: AppBar(
        title: Text(recado.nome),
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
                if (recado.fotoUrl != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      recado.fotoUrl!,
                      fit: BoxFit.contain,
                      loadingBuilder: (_, child, progress) => progress == null
                          ? child
                          : const SizedBox(
                              height: 300,
                              child: Center(child: CircularProgressIndicator()),
                            ),
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.broken_image_outlined,
                        size: 80,
                        color: Color(0xFFB8A88A),
                      ),
                    ),
                  ),
                if (recado.mensagem.isNotEmpty) ...[
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
                                  Icons.favorite,
                                  color: Color(0xFFB8A88A),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  recado.nome,
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
                            recado.mensagem,
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
