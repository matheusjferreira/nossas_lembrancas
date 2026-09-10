import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/recado.dart';
import '../viewmodels/app_viewmodel.dart';
import 'detalhe_recado_view.dart';

class MuralRecadosView extends StatelessWidget {
  const MuralRecadosView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.read<AppViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Mural de recados')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
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
                      'Ainda não há recados.\nDeixe o seu carinho para os noivos 💛',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFF8A7B65), fontSize: 16),
                    ),
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: recados.length,
                separatorBuilder: (_, _) => const SizedBox(height: 16),
                itemBuilder: (_, i) => _CardRecado(recado: recados[i]),
              );
            },
          ),
        ),
      ),
    );
  }
}

// ============ CARD DE RECADO ============
class _CardRecado extends StatelessWidget {
  final Recado recado;
  const _CardRecado({required this.recado});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => DetalheRecadoView(recado: recado)),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFBF7EF),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE8DCC8), width: 1),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.format_quote, color: Color(0xFFE8DCC8), size: 32),
            const SizedBox(height: 4),
            Text(
              recado.mensagem,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFF5D4E37),
                fontSize: 16,
                height: 1.6,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 16),
            const Divider(color: Color(0xFFE8DCC8), height: 1),
            const SizedBox(height: 12),
            Row(
              children: [
                const CircleAvatar(
                  radius: 14,
                  backgroundColor: Color(0xFFE8DCC8),
                  child: Icon(Icons.person, color: Color(0xFFB8A88A), size: 14),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    recado.nome,
                    style: const TextStyle(
                      color: Color(0xFF5D4E37),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
