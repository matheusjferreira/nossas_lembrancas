import 'package:cloud_firestore/cloud_firestore.dart';

class Foto {
  final String id;
  final String nome;
  final String legenda;
  final String fotoUrl;
  final DateTime criadoEm;

  Foto({
    required this.id,
    required this.nome,
    required this.legenda,
    required this.fotoUrl,
    required this.criadoEm,
  });

  factory Foto.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Foto(
      id: doc.id,
      nome: data['nome'] ?? '',
      legenda: data['legenda'] ?? '',
      fotoUrl: data['fotoUrl'] ?? '',
      criadoEm: (data['criadoEm'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
