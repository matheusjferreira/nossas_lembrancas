import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/recado.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Enviar foto
  Future<void> enviarFoto({
    required String nome,
    required String mensagem,
    required Uint8List bytes,
    required String extensao,
  }) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final path = 'fotos/${timestamp}_$nome.$extensao';
    final ref = _storage.ref().child(path);

    // Define o contentType explicitamente
    final metadata = SettableMetadata(contentType: 'image/$extensao');

    await ref.putData(bytes, metadata);
    final url = await ref.getDownloadURL();

    await _db.collection('recados').add({
      'tipo': 'foto',
      'nome': nome,
      'mensagem': mensagem,
      'fotoUrl': url,
      'criadoEm': FieldValue.serverTimestamp(),
    });
  }

  // Enviar texto
  Future<void> enviarTexto({
    required String nome,
    required String mensagem,
  }) async {
    await _db.collection('recados').add({
      'tipo': 'texto',
      'nome': nome,
      'mensagem': mensagem,
      'fotoUrl': null,
      'criadoEm': FieldValue.serverTimestamp(),
    });
  }

  // Stream de recados ordenados do mais recente
  Stream<List<Recado>> streamRecados() {
    return _db
        .collection('recados')
        .orderBy('criadoEm', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => Recado.fromDoc(d)).toList());
  }
}
