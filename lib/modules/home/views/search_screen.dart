import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocklite_app/data/models/product_model.dart';
import 'package:stocklite_app/data/services/product_service.dart';
import 'package:stocklite_app/modules/home/controllers/product_controller.dart';

// Enum para controlar as opções de ordenação
enum SortOption { byNameAsc, byNameDesc, byPriceAsc, byPriceDesc }

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  final ProductService _productService = ProductService();
  
  // Variável de estado para a ordenação
  SortOption _sortOption = SortOption.byNameAsc;

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Limpa o filtro de categoria ao sair, se quiser
      // context.read<ProductController>().filterByCategory(null);
      
      // Limpa a busca ao sair
      context.read<ProductController>().search('');
    });
    _searchController.dispose();
    super.dispose();
  }

  // Função helper para aplicar a ordenação
  void _sortProducts(List<ProductModel> products) {
    switch (_sortOption) {
      case SortOption.byNameAsc:
        products.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        break;
      case SortOption.byNameDesc:
        products.sort((a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()));
        break;
      case SortOption.byPriceAsc:
        products.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortOption.byPriceDesc:
        products.sort((a, b) => b.price.compareTo(a.price));
        break;
    }
  }

  // Função helper para mostrar o ícone correto
  IconData _getSortIcon() {
    switch (_sortOption) {
      case SortOption.byNameAsc:
        return Icons.sort_by_alpha_rounded;
      case SortOption.byPriceAsc:
        return Icons.arrow_upward_rounded;
      case SortOption.byPriceDesc:
        return Icons.arrow_downward_rounded;
      default:
        return Icons.sort_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final productController = context.watch<ProductController>();

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
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
        actions: [
          // ---- NOVO BOTÃO DE ORDENAÇÃO ----
          PopupMenuButton<SortOption>(
            icon: Icon(_getSortIcon()),
            tooltip: 'Ordenar por',
            onSelected: (SortOption result) {
              setState(() {
                _sortOption = result;
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<SortOption>>[
              const PopupMenuItem<SortOption>(
                value: SortOption.byNameAsc,
                child: Text('Nome (A-Z)'),
              ),
              const PopupMenuItem<SortOption>(
                value: SortOption.byNameDesc,
                child: Text('Nome (Z-A)'),
              ),
              const PopupMenuItem<SortOption>(
                value: SortOption.byPriceAsc,
                child: Text('Menor Preço'),
              ),
              const PopupMenuItem<SortOption>(
                value: SortOption.byPriceDesc,
                child: Text('Maior Preço'),
              ),
            ],
          ),
        ],
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

          // 1. Aplicar Filtros
          if (category != null) {
            products = products.where((p) => p.category == category).toList();
          }
          if (query.isNotEmpty) {
            products = products.where((p) => p.name.toLowerCase().contains(query.toLowerCase())).toList();
          }
          
          // 2. Aplicar Ordenação
          _sortProducts(products);
          
          // 3. Exibir resultado
          if (products.isEmpty) {
            return const Center(child: Text('Nenhum produto encontrado.'));
          }

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
                  // Exibindo o preço para confirmar a ordenação
                  trailing: Text('R\$ ${product.price.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              );
            },
          );
        },
      ),
    );
  }
}