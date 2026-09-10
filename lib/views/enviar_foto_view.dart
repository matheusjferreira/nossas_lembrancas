import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../viewmodels/app_viewmodel.dart';

class EnviarFotoView extends StatefulWidget {
  const EnviarFotoView({super.key});

  @override
  State<EnviarFotoView> createState() => _EnviarFotoViewState();
}

class _EnviarFotoViewState extends State<EnviarFotoView> {
  final _nomeCtrl = TextEditingController();
  final _legendaCtrl = TextEditingController();
  final _picker = ImagePicker();
  Uint8List? _fotoBytes;
  String? _extensao;

  @override
  void dispose() {
    _nomeCtrl.dispose();
    _legendaCtrl.dispose();
    super.dispose();
  }

  Future<void> _escolherFoto() async {
    final file = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 1600,
    );
    if (file == null) return;
    final bytes = await file.readAsBytes();
    setState(() {
      _fotoBytes = bytes;
      _extensao = file.name.split('.').last;
    });
  }

  Future<void> _enviar() async {
    final nome = _nomeCtrl.text.trim();
    final legenda = _legendaCtrl.text.trim();

    if (nome.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, diga seu nome 💛')),
      );
      return;
    }
    if (_fotoBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escolha uma foto para compartilhar 💛')),
      );
      return;
    }

    final vm = context.read<AppViewModel>();
    final ok = await vm.enviarFoto(
      nome: nome,
      mensagem: legenda,
      bytes: _fotoBytes!,
      extensao: _extensao ?? 'jpg',
    );

    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Foto enviada! Obrigado 💛')),
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
      appBar: AppBar(title: const Text('Foto da festa')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Compartilhe uma foto da festa 📸',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w300,
                    color: Color(0xFF5D4E37),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Um momento que você registrou e quer dividir com a gente',
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

                // Preview da foto
                if (_fotoBytes != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.memory(
                      _fotoBytes!,
                      height: 250,
                      fit: BoxFit.cover,
                    ),
                  ),
                if (_fotoBytes != null) const SizedBox(height: 16),

                // Botão escolher foto
                OutlinedButton.icon(
                  icon: const Icon(Icons.photo_camera_outlined),
                  label: Text(
                    _fotoBytes == null ? 'Escolher foto' : 'Trocar foto',
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF5D4E37),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: Color(0xFFD9CDB8)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: enviando ? null : _escolherFoto,
                ),
                const SizedBox(height: 16),

                // Legenda opcional
                TextField(
                  controller: _legendaCtrl,
                  maxLines: 3,
                  maxLength: 300,
                  decoration: const InputDecoration(
                    labelText: 'Legenda (opcional)',
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 16),

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
                      : const Text('Enviar foto'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
