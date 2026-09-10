import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/app_viewmodel.dart';

class EnviarRecadoView extends StatefulWidget {
  const EnviarRecadoView({super.key});

  @override
  State<EnviarRecadoView> createState() => _EnviarRecadoViewState();
}

class _EnviarRecadoViewState extends State<EnviarRecadoView> {
  final _nomeCtrl = TextEditingController();
  final _msgCtrl = TextEditingController();

  @override
  void dispose() {
    _nomeCtrl.dispose();
    _msgCtrl.dispose();
    super.dispose();
  }

  Future<void> _enviar() async {
    final nome = _nomeCtrl.text.trim();
    final msg = _msgCtrl.text.trim();

    if (nome.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, diga seu nome 💛')),
      );
      return;
    }
    if (msg.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Escreva seu recado 💛')));
      return;
    }

    final vm = context.read<AppViewModel>();
    final ok = await vm.enviarTexto(nome: nome, mensagem: msg);

    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Recado enviado! Obrigado 💛')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(vm.erro ?? 'Erro ao enviar')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final enviando = context.watch<AppViewModel>().enviando;

    return Scaffold(
      appBar: AppBar(title: const Text('Recado aos noivos')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Deixe um recado aos noivos 💛',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w300,
                    color: Color(0xFF5D4E37),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Escreva uma mensagem carinhosa para guardarmos pra sempre',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF8A7B65)),
                ),
                const SizedBox(height: 32),
                TextField(
                  controller: _nomeCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Seu nome',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _msgCtrl,
                  maxLines: 6,
                  maxLength: 1000,
                  decoration: const InputDecoration(
                    labelText: 'Seu recado',
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: enviando ? null : _enviar,
                  child: enviando
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Enviar recado'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
