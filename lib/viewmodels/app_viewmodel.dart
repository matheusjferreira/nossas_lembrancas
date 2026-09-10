import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../models/recado.dart';
import '../services/firebase_service.dart';

class AppViewModel extends ChangeNotifier {
  final FirebaseService _service = FirebaseService();

  bool _enviando = false;
  String? _erro;
  String? _sucesso;

  bool get enviando => _enviando;
  String? get erro => _erro;
  String? get sucesso => _sucesso;

  Stream<List<Recado>> get recadosStream => _service.streamRecados();

  Future<bool> enviarFoto({
    required String nome,
    required String mensagem,
    required Uint8List bytes,
    required String extensao,
  }) async {
    return _executar(
      () => _service.enviarFoto(
        nome: nome,
        mensagem: mensagem,
        bytes: bytes,
        extensao: extensao,
      ),
    );
  }

  Future<bool> enviarTexto({
    required String nome,
    required String mensagem,
  }) async {
    return _executar(
      () => _service.enviarTexto(nome: nome, mensagem: mensagem),
    );
  }

  Future<bool> _executar(Future<void> Function() acao) async {
    _enviando = true;
    _erro = null;
    _sucesso = null;
    notifyListeners();

    try {
      await acao();
      _sucesso = 'Recado enviado! Obrigado 💛';
      return true;
    } catch (e) {
      _erro = 'Ops, algo deu errado: $e';
      return false;
    } finally {
      _enviando = false;
      notifyListeners();
    }
  }

  void limparMensagens() {
    _erro = null;
    _sucesso = null;
    notifyListeners();
  }
}
