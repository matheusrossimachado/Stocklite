import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String id;
  final String name;
  final double price;
  final String category;
  int quantity;
  final int minimumQuantity;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.quantity,
    required this.minimumQuantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'category': category,
      'quantity': quantity,
      'minimumQuantity': minimumQuantity,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map, String id) {
    return ProductModel(
      id: id,
      name: map['name'] ?? '',
      price: (map['price'] as num? ?? 0.0).toDouble(),
      category: map['category'] ?? '',
      quantity: (map['quantity'] as num? ?? 0).toInt(),
      minimumQuantity: (map['minimumQuantity'] as num? ?? 0).toInt(),
    );
  }
  
  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ProductModel(
      id: doc.id,
      name: data['name'] ?? '',
      price: (data['price'] as num? ?? 0.0).toDouble(),
      category: data['category'] ?? '',
      quantity: (data['quantity'] as num? ?? 0).toInt(),
      minimumQuantity: (data['minimumQuantity'] as num? ?? 0).toInt(),
    );
  }
}