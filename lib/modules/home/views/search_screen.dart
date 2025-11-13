import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocklite_app/data/models/product_model.dart';
import 'package:stocklite_app/data/services/product_service.dart';
import 'package:stocklite_app/modules/home/controllers/product_controller.dart';


class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  final ProductService _productService = ProductService();

  @override
  void dispose() {
    // IMPORTANTE: Limpa a busca no controller principal quando o usuário sai da tela
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductController>().search('');
    });
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Usamos 'watch' para que a tela se reconstrua a cada nova letra digitada
    final productController = context.watch<ProductController>();

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true, // Foca no campo de texto assim que a tela abre
          decoration: InputDecoration(
            hintText: 'Buscar produtos por nome...',
            border: InputBorder.none,
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      productController.search('');
                    },
                  )
                : null,
          ),
          onChanged: (query) => productController.search(query),
        ),
      ),
      body: StreamBuilder<List<ProductModel>>(
        stream: _productService.getProductsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum produto cadastrado.'));
          }

          List<ProductModel> products = snapshot.data!;
          final category = productController.categoryFilter;
          final query = productController.searchQuery;

          if (category != null) {
            products = products.where((p) => p.category == category).toList();
          }
          if (query.isNotEmpty) {
            products = products.where((p) => p.name.toLowerCase().contains(query.toLowerCase())).toList();
          }

          if (products.isEmpty) {
            return const Center(child: Text('Nenhum produto encontrado.'));
          }

          // Exibimos os resultados em uma ListView (sem botões, só para consulta)
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              final isLowStock = product.quantity <= product.minimumQuantity;
              
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  leading: Icon(Icons.shopping_bag_outlined, color: isLowStock ? Colors.red : Colors.deepPurple),
                  title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(product.category),
                  trailing: Text('Qtd: ${product.quantity}', style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              );
            },
          );
        },
      ),
    );
  }
}