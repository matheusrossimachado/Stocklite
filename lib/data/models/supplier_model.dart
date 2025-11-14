import 'package:cloud_firestore/cloud_firestore.dart';

class SupplierModel {
  final String id;
  final String name;
  // --- CAMPOS NOVOS PARA CUMPRIR RUBRICA RF003 ---
  final String description;
  final String contactPerson;
  final String email;
  final String phone;

  SupplierModel({
    required this.id,
    required this.name,
    this.description = '',
    this.contactPerson = '',
    this.email = '',
    this.phone = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'contactPerson': contactPerson,
      'email': email,
      'phone': phone,
    };
  }

  factory SupplierModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return SupplierModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      contactPerson: data['contactPerson'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
    );
  }
}