import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/recado.dart';
import '../models/foto.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // ============ FOTOS ============
  Future<void> enviarFoto({
    required String nome,
    required String legenda,
    required Uint8List bytes,
    required String extensao,
  }) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final path = 'fotos/${timestamp}_$nome.$extensao';
    final ref = _storage.ref().child(path);

    final metadata = SettableMetadata(contentType: 'image/$extensao');

    await ref.putData(bytes, metadata);
    final url = await ref.getDownloadURL();

    await _db.collection('fotos').add({
      'nome': nome,
      'legenda': legenda,
      'fotoUrl': url,
      'criadoEm': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<Foto>> streamFotos() {
    return _db
        .collection('fotos')
        .orderBy('criadoEm', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => Foto.fromDoc(d)).toList());
  }

  // ============ RECADOS ============
  Future<void> enviarRecado({
    required String nome,
    required String mensagem,
  }) async {
    await _db.collection('recados').add({
      'nome': nome,
      'mensagem': mensagem,
      'criadoEm': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<Recado>> streamRecados() {
    return _db
        .collection('recados')
        .orderBy('criadoEm', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => Recado.fromDoc(d)).toList());
  }
}
