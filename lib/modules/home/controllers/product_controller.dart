import 'package:flutter/material.dart';
import 'package:stocklite_app/data/models/product_model.dart';

class ProductController extends ChangeNotifier {
  
  final List<ProductModel> _allProducts = [
    ProductModel(id: '1', name: 'Arroz Camil 1kg', price: 5.50, category: 'Alimentos', quantity: 10, minimumQuantity: 5),
    ProductModel(id: '2', name: 'Café Pilão 500g', price: 12.80, category: 'Alimentos', quantity: 3, minimumQuantity: 4),
    ProductModel(id: '3', name: 'Sabonete Dove', price: 2.99, category: 'Higiene', quantity: 8, minimumQuantity: 2),
    ProductModel(id: '4', name: 'Detergente Ypê', price: 1.99, category: 'Limpeza', quantity: 1, minimumQuantity: 3),
  ];

  List<ProductModel> _filteredProducts = [];
  String _searchQuery = '';
  String? _categoryFilter;

  ProductController() {
    _filteredProducts = List.from(_allProducts);
  }

  List<ProductModel> get products => _filteredProducts;

  List<String> get uniqueCategories {
    return _allProducts.map((p) => p.category).toSet().toList();
  }

  void search(String query) {
    _searchQuery = query;
    _runFilters();
  }

  void filterByCategory(String? category) {
    _categoryFilter = category;
    _runFilters();
  }

  void _runFilters() {
    List<ProductModel> tempProducts = List.from(_allProducts);
    if (_categoryFilter != null) {
      tempProducts = tempProducts.where((product) => product.category == _categoryFilter).toList();
    }
    if (_searchQuery.isNotEmpty) {
      tempProducts = tempProducts
          .where((product) =>
              product.name.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
    _filteredProducts = tempProducts;
    notifyListeners();
  }

  void addProduct(ProductModel product) {
    _allProducts.add(product);
    _runFilters();
  }

  void deleteProduct(String productId) {
    _allProducts.removeWhere((p) => p.id == productId);
    _runFilters();
  }

  void incrementQuantity(String productId) {
    final product = _allProducts.firstWhere((p) => p.id == productId);
    product.quantity++;
    notifyListeners();
  }

  void decrementQuantity(String productId) {
    final product = _allProducts.firstWhere((p) => p.id == productId);
    if (product.quantity > 0) {
      product.quantity--;
      notifyListeners();
    }
  }

  int get totalUniqueProducts => _allProducts.length;

  List<ProductModel> get productsToRestock {
    return _allProducts.where((p) => p.quantity <= p.minimumQuantity).toList();
  }

  double get restockCost {
    final toRestock = productsToRestock;
    if (toRestock.isEmpty) {
      return 0.0;
    }
    return toRestock.fold(0.0, (sum, product) {
      int itemsNeeded = product.minimumQuantity - product.quantity;
      if (itemsNeeded <= 0) return sum;
      return sum + (product.price * itemsNeeded);
    });
  }
}