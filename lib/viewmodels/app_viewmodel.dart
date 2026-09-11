import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../models/recado.dart';
import '../models/foto.dart';
import '../services/firebase_service.dart';

class AppViewModel extends ChangeNotifier {
  final FirebaseService _service = FirebaseService();

  bool _enviandoFoto = false;
  bool _enviandoRecado = false;
  String? _erro;
  String? _sucesso;

  bool get enviandoFoto => _enviandoFoto;
  bool get enviandoRecado => _enviandoRecado;
  String? get erro => _erro;
  String? get sucesso => _sucesso;

  Stream<List<Foto>> get fotosStream => _service.streamFotos();
  Stream<List<Recado>> get recadosStream => _service.streamRecados();

  Future<bool> enviarFoto({
    required String nome,
    required String legenda,
    required Uint8List bytes,
    required String extensao,
  }) async {
    return _executar(
      tipo: 'foto',
      acao: () => _service.enviarFoto(
        nome: nome,
        legenda: legenda,
        bytes: bytes,
        extensao: extensao,
      ),
    );
  }

  Future<bool> enviarRecado({
    required String nome,
    required String mensagem,
  }) async {
    return _executar(
      tipo: 'recado',
      acao: () => _service.enviarRecado(nome: nome, mensagem: mensagem),
    );
  }

  Future<bool> _executar({
    required String tipo,
    required Future<void> Function() acao,
  }) async {
    if (tipo == 'foto') {
      _enviandoFoto = true;
    } else {
      _enviandoRecado = true;
    }
    _erro = null;
    _sucesso = null;
    notifyListeners();

    try {
      await acao();
      _sucesso = tipo == 'foto'
          ? 'Foto enviada! Obrigado 💛'
          : 'Recado enviado! Obrigado 💛';
      return true;
    } catch (e) {
      _erro = 'Ops, algo deu errado: $e';
      return false;
    } finally {
      if (tipo == 'foto') {
        _enviandoFoto = false;
      } else {
        _enviandoRecado = false;
      }
      notifyListeners();
    }
  }

  void limparMensagens() {
    _erro = null;
    _sucesso = null;
    notifyListeners();
  }
}
