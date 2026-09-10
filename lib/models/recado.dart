import 'package:cloud_firestore/cloud_firestore.dart';

class Recado {
  final String id;
  final String tipo; // 'foto' ou 'texto'
  final String nome;
  final String mensagem;
  final String? fotoUrl;
  final DateTime criadoEm;

  Recado({
    required this.id,
    required this.tipo,
    required this.nome,
    required this.mensagem,
    this.fotoUrl,
    required this.criadoEm,
  });

  factory Recado.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Recado(
      id: doc.id,
      tipo: data['tipo'] ?? 'texto',
      nome: data['nome'] ?? '',
      mensagem: data['mensagem'] ?? '',
      fotoUrl: data['fotoUrl'],
      criadoEm: (data['criadoEm'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tipo': tipo,
      'nome': nome,
      'mensagem': mensagem,
      'fotoUrl': fotoUrl,
      'criadoEm': FieldValue.serverTimestamp(),
    };
  }
}
