import 'package:flutter/material.dart';
import 'package:stocklite_app/data/models/product_model.dart';

class ProductController extends ChangeNotifier {

  // MUDANÇA: Esta lista agora guardará TODOS os produtos, sem filtro.
  // É a nossa "fonte da verdade" original.
  final List<ProductModel> _allProducts = [
    ProductModel(id: '1', name: 'Arroz Camil 1kg', price: 5.50, category: 'Alimentos', quantity: 10, minimumQuantity: 5),
    ProductModel(id: '2', name: 'Café Pilão 500g', price: 12.80, category: 'Alimentos', quantity: 3, minimumQuantity: 4),
    ProductModel(id: '3', name: 'Sabonete Dove', price: 2.99, category: 'Higiene', quantity: 8, minimumQuantity: 2),
    ProductModel(id: '4', name: 'Detergente Ypê', price: 1.99, category: 'Limpeza', quantity: 1, minimumQuantity: 3),
  ];

  // MUDANÇA: Esta lista agora será a LISTA FILTRADA que a tela vai exibir.
  List<ProductModel> _filteredProducts = [];

  // NO CONSTRUTOR do controller, garantimos que a lista filtrada comece
  // com todos os produtos.
  ProductController() {
    _filteredProducts = List.from(_allProducts);
  }

  // O getter agora aponta para a lista filtrada.
  List<ProductModel> get products => _filteredProducts;

  // --- MÉTODOS DE GERENCIAMENTO (com um pequeno ajuste) ---

  void addProduct(ProductModel product) {
    _allProducts.add(product);
    search(''); // Chamamos a busca com texto vazio para resetar a lista
  }

  void deleteProduct(String productId) {
    _allProducts.removeWhere((p) => p.id == productId);
    search(''); // Resetamos a lista após a exclusão
  }

  void incrementQuantity(String productId) {
    final product = _allProducts.firstWhere((p) => p.id == productId);
    product.quantity++;
    notifyListeners(); // Apenas notificar é suficiente aqui
  }

  void decrementQuantity(String productId) {
    final product = _allProducts.firstWhere((p) => p.id == productId);
    if (product.quantity > 0) {
      product.quantity--;
      notifyListeners(); // Apenas notificar é suficiente aqui
    }
  }

  // --- O NOVO MÉTODO DE BUSCA ---
  void search(String query) {
    if (query.isEmpty) {
      // Se a busca estiver vazia, a lista filtrada volta a ser a lista completa.
      _filteredProducts = List.from(_allProducts);
    } else {
      // Se houver um texto, filtramos a lista completa.
      _filteredProducts = _allProducts
          .where((product) =>
              // Convertemos ambos para minúsculas para a busca não diferenciar maiúsculas/minúsculas.
              product.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    // ESSENCIAL: Avisamos a tela que a lista de produtos a ser exibida mudou!
    notifyListeners();
  }

  // --- CÁLCULOS INTELIGENTES (agora baseados na lista completa) ---
  int get totalUniqueProducts => _allProducts.length;

  List<ProductModel> get productsToRestock {
    return _allProducts.where((p) => p.quantity <= p.minimumQuantity).toList();
  }

  double get restockCost {
    // ... (lógica do restockCost não muda)
    final toRestock = productsToRestock;
    if (toRestock.isEmpty) return 0.0;
    return toRestock.fold(0.0, (sum, product) {
      int itemsNeeded = product.minimumQuantity - product.quantity;
      if (itemsNeeded <= 0) return sum;
      return sum + (product.price * itemsNeeded);
    });
  }
}