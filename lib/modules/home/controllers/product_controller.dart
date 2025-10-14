import 'package:flutter/material.dart';
// Importando nosso blueprint de produto.
import 'package:stocklite_app/data/models/product_model.dart';

// 1. A MÁGICA COMEÇA AQUI:
// Nossa classe "herda" as funcionalidades do ChangeNotifier.
// Isso dá a ela o poder de notificar os "ouvintes" (nossas telas).
class ProductController extends ChangeNotifier {

  // 2. A LISTA DE PRODUTOS
  // Esta é a nossa "fonte da verdade". Todos os produtos do app ficarão aqui.
  // O '_' no início (_products) a torna "privada", ou seja, só pode ser
  // alterada de dentro desta classe. Isso é uma boa prática de organização.
  final List<ProductModel> _products = [
    // Vamos adicionar alguns produtos "fake" para termos o que mostrar na tela.
    ProductModel(id: '1', name: 'Arroz Camil 1kg', price: 5.50, category: 'Alimentos', quantity: 10, minimumQuantity: 5),
    ProductModel(id: '2', name: 'Café Pilão 500g', price: 12.80, category: 'Alimentos', quantity: 3, minimumQuantity: 4),
    ProductModel(id: '3', name: 'Sabonete Dove', price: 2.99, category: 'Higiene', quantity: 8, minimumQuantity: 2),
    ProductModel(id: '4', name: 'Detergente Ypê', price: 1.99, category: 'Limpeza', quantity: 4, minimumQuantity: 3),
  ];

  // 3. O "GETTER" PÚBLICO
  // Para que nossas telas possam LER a lista de produtos, criamos um "getter".
  // Ele fornece uma cópia "somente leitura" da lista, impedindo modificações diretas.
  List<ProductModel> get products => _products;

  // 4. MÉTODOS PARA MODIFICAR A LISTA (Exemplos)
  // No futuro, teremos os métodos de adicionar, remover, etc.
  // Por exemplo:
  void addProduct(ProductModel product) {
    _products.add(product);
    // 5. O COMANDO MÁGICO: notificar os ouvintes!
    // Sempre que a lista for alterada, chamamos notifyListeners().
    // Isso avisa a tela: "Ei, a lista mudou! Se redesenhe para mostrar a versão mais nova!"
    notifyListeners();
  }
}