import 'package:flutter/material.dart';
import 'package:stocklite_app/data/models/product_model.dart';

class ProductController extends ChangeNotifier {
  
  final List<ProductModel> _products = [
    ProductModel(id: '1', name: 'Arroz Camil 1kg', price: 5.50, category: 'Alimentos', quantity: 10, minimumQuantity: 5),
    ProductModel(id: '2', name: 'Café Pilão 500g', price: 12.80, category: 'Alimentos', quantity: 3, minimumQuantity: 4),
    ProductModel(id: '3', name: 'Sabonete Dove', price: 2.99, category: 'Higiene', quantity: 8, minimumQuantity: 2),
    ProductModel(id: '4', name: 'Detergente Ypê', price: 1.99, category: 'Limpeza', quantity: 1, minimumQuantity: 3),
  ];

  List<ProductModel> get products => _products;

  // --- MÉTODOS COM A LÓGICA DE VOLTA ---

  void addProduct(ProductModel product) {
    _products.add(product);
    notifyListeners();
  }

  void incrementQuantity(String productId) {
    final product = _products.firstWhere((p) => p.id == productId);
    product.quantity++;
    notifyListeners();
  }

  void decrementQuantity(String productId) {
    final product = _products.firstWhere((p) => p.id == productId);
    if (product.quantity > 0) {
      product.quantity--;
      notifyListeners();
    }
  }

  void deleteProduct(String productId) {
    _products.removeWhere((p) => p.id == productId);
    notifyListeners();
  }

  // --- CÁLCULOS INTELIGENTES ATUALIZADOS ---

  int get totalUniqueProducts => _products.length;

  List<ProductModel> get productsToRestock {
    return _products.where((p) => p.quantity <= p.minimumQuantity).toList();
  }

  double get restockCost {
    if (productsToRestock.isEmpty) {
      return 0.0;
    }

    return productsToRestock.fold(0.0, (sum, product) {
      int itemsNeeded = product.minimumQuantity - product.quantity;
      if (itemsNeeded <= 0) return sum;
      return sum + (product.price * itemsNeeded);
    });
  }
}