import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocklite_app/data/models/category_model.dart';
import 'package:stocklite_app/data/models/product_model.dart';
import 'package:stocklite_app/data/models/supplier_model.dart';
import 'package:stocklite_app/data/services/category_service.dart';
import 'package:stocklite_app/data/services/product_service.dart';
import 'package:stocklite_app/data/services/supplier_service.dart';
import 'package:stocklite_app/modules/about/views/about_screen.dart';
import 'package:stocklite_app/modules/home/controllers/product_controller.dart';
import 'package:stocklite_app/modules/home/views/add_edit_product_screen.dart';
import 'package:stocklite_app/modules/home/views/search_screen.dart';

// As classes de aba vêm primeiro
class CatalogTab extends StatelessWidget {
  final bool isGridView;
  final ProductService _productService = ProductService();

  CatalogTab({super.key, required this.isGridView});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductController>(
      builder: (context, filterController, child) {
        return StreamBuilder<List<ProductModel>>(
          stream: _productService.getProductsStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Erro ao carregar produtos: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Nenhum produto cadastrado ainda.'));
            }

            List<ProductModel> products = snapshot.data!;
            final category = filterController.categoryFilter;
            final query = filterController.searchQuery;
            if (category != null) {
              products = products.where((p) => p.category == category).toList();
            }
            if (query.isNotEmpty) {
              products = products.where((p) => p.name.toLowerCase().contains(query.toLowerCase())).toList();
            }
            if (products.isEmpty) {
              return const Center(child: Text('Nenhum produto encontrado para este filtro.'));
            }
            return isGridView
                ? _buildGridView(context, products)
                : _buildListView(context, products);
          },
        );
      },
    );
  }

  Widget _buildListView(BuildContext context, List<ProductModel> products) {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        final isLowStock = product.quantity <= product.minimumQuantity;
        return Card(
          child: ListTile(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => AddEditProductScreen(product: product)),
              );
            },
            leading: Icon(Icons.shopping_bag_outlined, color: isLowStock ? Colors.red : Colors.deepPurple, size: 40),
            title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${product.category} - R\$ ${product.price.toStringAsFixed(2)}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(icon: const Icon(Icons.remove_circle_outline), onPressed: () => _productService.updateQuantity(product.id, product.quantity - 1)),
                Text('${product.quantity}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isLowStock ? Colors.red : Colors.black)),
                IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: () => _productService.updateQuantity(product.id, product.quantity + 1)),
                IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red), onPressed: () => _showDeleteConfirmDialog(context, product)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGridView(BuildContext context, List<ProductModel> products) {
    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 8, mainAxisSpacing: 8, childAspectRatio: 0.75),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        final isLowStock = product.quantity <= product.minimumQuantity;
        return Card(
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => AddEditProductScreen(product: product)),
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(alignment: Alignment.topRight, child: isLowStock ? const Icon(Icons.warning_amber_rounded, color: Colors.red) : const SizedBox(height: 24)),
                  Expanded(child: Center(child: Icon(Icons.shopping_bag_outlined, color: isLowStock ? Colors.red : Colors.deepPurple, size: 40))),
                  Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
                  Text('R\$ ${product.price.toStringAsFixed(2)}'),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(icon: const Icon(Icons.remove_circle_outline), onPressed: () => _productService.updateQuantity(product.id, product.quantity - 1)),
                      Text('${product.quantity}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isLowStock ? Colors.red : Colors.black)),
                      IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: () => _productService.updateQuantity(product.id, product.quantity + 1)),
                    ],
                  ),
                  Center(child: IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red), onPressed: () => _showDeleteConfirmDialog(context, product))),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  
  void _showDeleteConfirmDialog(BuildContext context, ProductModel product) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: Text('Tem certeza de que deseja excluir o item "${product.name}"? Esta ação não pode ser desfeita.'),
          actions: <Widget>[
            TextButton(child: const Text('CANCELAR'), onPressed: () => Navigator.of(ctx).pop()),
            TextButton(
              child: const Text('EXCLUIR', style: TextStyle(color: Colors.red)),
              onPressed: () {
                _productService.deleteProduct(product.id);
                Navigator.of(ctx).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
class SummaryTab extends StatelessWidget {
  const SummaryTab({super.key});

  @override
  Widget build(BuildContext context) {
    final productService = ProductService();
    final categoryService = CategoryService();
    final supplierService = SupplierService();
    
    final categoryNameController = TextEditingController();
    final supplierNameController = TextEditingController();

    return StreamBuilder<List<ProductModel>>(
      stream: productService.getProductsStream(),
      builder: (context, productSnapshot) {
        
        List<ProductModel> allProducts = productSnapshot.data ?? [];
        final int totalUniqueProducts = allProducts.length;
        final productsToRestock = allProducts.where((p) => p.quantity <= p.minimumQuantity).toList();
        final double restockCost = productsToRestock.fold(0.0, (sum, p) {
          int needed = p.minimumQuantity - p.quantity;
          return sum + (needed > 0 ? (p.price * needed) : 0.0);
        });

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildSummaryInfo('Itens Únicos', totalUniqueProducts.toString()),
                      _buildSummaryInfo('Custo p/ Repor', 'R\$ ${restockCost.toStringAsFixed(2)}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text('Gerenciar Categorias', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Divider(),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: categoryNameController,
                      decoration: const InputDecoration(labelText: 'Nova Categoria', border: OutlineInputBorder()),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.add_circle, color: Colors.deepPurple, size: 40),
                    onPressed: () async {
                      if (categoryNameController.text.isNotEmpty) {
                        await categoryService.addCategory(categoryNameController.text);
                        categoryNameController.clear();
                      }
                    },
                  ),
                ],
              ),
              StreamBuilder<List<CategoryModel>>(
                stream: categoryService.getCategoriesStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: Padding(padding: EdgeInsets.all(8.0), child: CircularProgressIndicator()));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Padding(padding: EdgeInsets.all(8.0), child: Text('Nenhuma categoria cadastrada.'));
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final category = snapshot.data![index];
                      return Card(
                        child: ListTile(
                          title: Text(category.name),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // --- BOTÃO DE EDITAR NOVO ---
                              IconButton(
                                icon: const Icon(Icons.edit_outlined, color: Colors.blue),
                                onPressed: () => _showEditCategoryDialog(context, category, categoryService),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.red),
                                onPressed: () => _showDeleteCategoryDialog(context, category, categoryService),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 24),
              const Text('Gerenciar Fornecedores', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Divider(),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: supplierNameController,
                      decoration: const InputDecoration(labelText: 'Novo Fornecedor', border: OutlineInputBorder()),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.store, color: Colors.deepPurple, size: 40),
                    onPressed: () async {
                      if (supplierNameController.text.isNotEmpty) {
                        await supplierService.addSupplier(supplierNameController.text);
                        supplierNameController.clear();
                      }
                    },
                  ),
                ],
              ),
              StreamBuilder<List<SupplierModel>>(
                stream: supplierService.getSuppliersStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: Padding(padding: EdgeInsets.all(8.0), child: CircularProgressIndicator()));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Padding(padding: EdgeInsets.all(8.0), child: Text('Nenhum fornecedor cadastrado.'));
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final supplier = snapshot.data![index];
                      return Card(
                        child: ListTile(
                          title: Text(supplier.name),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // --- BOTÃO DE EDITAR NOVO ---
                              IconButton(
                                icon: const Icon(Icons.edit_outlined, color: Colors.blue),
                                onPressed: () => _showEditSupplierDialog(context, supplier, supplierService),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.red),
                                onPressed: () => _showDeleteSupplierDialog(context, supplier, supplierService),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 24),
              const Text('Itens para Repor', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const Divider(),
              if (productsToRestock.isEmpty) const Center(child: Padding(padding: EdgeInsets.all(8.0), child: Text('Nenhum item com estoque baixo.'))),
              if (productsToRestock.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: productsToRestock.length,
                  itemBuilder: (context, index) {
                    final product = productsToRestock[index];
                    return Card(
                      color: Colors.red.shade50,
                      child: ListTile(
                        leading: const Icon(Icons.warning_amber_rounded, color: Colors.red),
                        // ***** LINHA CORRIGIDA AQUI *****
                        title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        trailing: Text('Qtd: ${product.quantity}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red)),
                      ),
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryInfo(String title, String value) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontSize: 16, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      ],
    );
  }
  
  // --- MÉTODO DE DIÁLOGO DE EDIÇÃO (NOVO) ---
  void _showEditCategoryDialog(BuildContext context, CategoryModel category, CategoryService service) {
    final editController = TextEditingController(text: category.name);
    
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Editar Categoria'),
          content: TextField(
            controller: editController,
            autofocus: true,
            decoration: const InputDecoration(labelText: 'Nome da Categoria'),
          ),
          actions: <Widget>[
            TextButton(child: const Text('CANCELAR'), onPressed: () => Navigator.of(ctx).pop()),
            TextButton(
              child: const Text('SALVAR', style: TextStyle(color: Colors.blue)),
              onPressed: () {
                if (editController.text.isNotEmpty) {
                  service.updateCategory(category.id, editController.text);
                  Navigator.of(ctx).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showDeleteCategoryDialog(BuildContext context, CategoryModel category, CategoryService service) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: Text('Tem certeza de que deseja excluir a categoria "${category.name}"?'),
          actions: <Widget>[
            TextButton(child: const Text('CANCELAR'), onPressed: () => Navigator.of(ctx).pop()),
            TextButton(
              child: const Text('EXCLUIR', style: TextStyle(color: Colors.red)),
              onPressed: () {
                service.deleteCategory(category.id);
                Navigator.of(ctx).pop();
              },
            ),
          ],
        );
      },
    );
  }
  
  // --- MÉTODO DE DIÁLOGO DE EDIÇÃO (NOVO) ---
  void _showEditSupplierDialog(BuildContext context, SupplierModel supplier, SupplierService service) {
    final editController = TextEditingController(text: supplier.name);
    
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Editar Fornecedor'),
          content: TextField(
            controller: editController,
            autofocus: true,
            decoration: const InputDecoration(labelText: 'Nome do Fornecedor'),
          ),
          actions: <Widget>[
            TextButton(child: const Text('CANCELAR'), onPressed: () => Navigator.of(ctx).pop()),
            TextButton(
              child: const Text('SALVAR', style: TextStyle(color: Colors.blue)),
              onPressed: () {
                if (editController.text.isNotEmpty) {
                  service.updateSupplier(supplier.id, editController.text);
                  Navigator.of(ctx).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showDeleteSupplierDialog(BuildContext context, SupplierModel supplier, SupplierService service) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: Text('Tem certeza de que deseja excluir o fornecedor "${supplier.name}"?'),
          actions: <Widget>[
            TextButton(child: const Text('CANCELAR'), onPressed: () => Navigator.of(ctx).pop()),
            TextButton(
              child: const Text('EXCLUIR', style: TextStyle(color: Colors.red)),
              onPressed: () {
                service.deleteSupplier(supplier.id);
                Navigator.of(ctx).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
// A HomeScreen (Stateful) vem por último
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _isGridView = false;
  
  @override
  void dispose() {
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final productController = Provider.of<ProductController>(context, listen: false);
    final categoryService = CategoryService();

    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedIndex == 0 ? 'Catálogo' : 'Resumo'),
        automaticallyImplyLeading: false,
        actions: [
          if (_selectedIndex == 0)
            IconButton(
              icon: const Icon(Icons.search),
              tooltip: 'Buscar',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const SearchScreen()),
                );
              },
            ),
          
          if (_selectedIndex == 0)
            StreamBuilder<List<CategoryModel>>(
              stream: categoryService.getCategoriesStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const IconButton(
                    icon: Icon(Icons.filter_list_rounded),
                    onPressed: null,
                    disabledColor: Colors.grey,
                  );
                }
                
                final categories = snapshot.data!;
                return PopupMenuButton<String>(
                  icon: const Icon(Icons.filter_list_rounded),
                  tooltip: 'Filtrar por Categoria',
                  onSelected: (String? value) {
                    productController.filterByCategory(value == 'all' ? null : value);
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      const PopupMenuItem<String>(
                        value: 'all',
                        child: Text('Todas as Categorias'),
                      ),
                      ...categories.map((CategoryModel category) {
                        return PopupMenuItem<String>(
                          value: category.name,
                          child: Text(category.name),
                        );
                      }).toList(),
                    ];
                  },
                );
              }
            ),

          if (_selectedIndex == 0)
            IconButton(
              icon: Icon(_isGridView ? Icons.view_list_rounded : Icons.grid_view_rounded),
              onPressed: () {
                setState(() {
                  _isGridView = !_isGridView;
                });
              },
            ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AboutScreen()));
            },
          ),
        ],
      ),
      body: _selectedIndex == 0 ? CatalogTab(isGridView: _isGridView) : const SummaryTab(),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const AddEditProductScreen(product: null)),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.view_list_rounded), label: 'Catálogo'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart_rounded), label: 'Resumo'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurple,
        onTap: _onItemTapped,
      ),
    );
  }
}