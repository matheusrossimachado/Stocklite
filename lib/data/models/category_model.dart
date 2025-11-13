import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  final String id;
  final String name;

  CategoryModel({
    required this.id,
    required this.name,
  });

  // Converte a classe para um Mapa (JSON) para salvar no Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }

  // Cria a classe a partir de um Documento do Firestore
  factory CategoryModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return CategoryModel(
      id: doc.id,
      name: data['name'] ?? '',
    );
  }
}