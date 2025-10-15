import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocklite_app/data/models/product_model.dart';
import 'package:stocklite_app/modules/about/views/about_screen.dart';
import 'package:stocklite_app/modules/home/controllers/product_controller.dart';
import 'package:stocklite_app/modules/home/views/add_edit_product_screen.dart';

// #############################################################################
// AS CLASSES DE ABA (CATALOGTAB E SUMMARYTAB) VÊM PRIMEIRO
// #############################################################################

// --- WIDGET DA ABA DE CATÁLOGO ---
class CatalogTab extends StatelessWidget {
  final bool isGridView;
  const CatalogTab({super.key, required this.isGridView});

  @override
  Widget build(BuildContext context) {
    final productController = Provider.of<ProductController>(context);
    if (productController.products.isEmpty) {
      return const Center(child: Text('Nenhum produto encontrado.'));
    }
    return isGridView
        ? _buildGridView(context, productController)
        : _buildListView(context, productController);
  }

  Widget _buildListView(BuildContext context, ProductController productController) {
    final products = productController.products;
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final ProductModel product = products[index];
        final bool isLowStock = product.quantity <= product.minimumQuantity;
        return Card(
          child: ListTile(
            leading: Icon(Icons.shopping_bag_outlined, color: isLowStock ? Colors.red : Colors.deepPurple, size: 40),
            title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${product.category} - R\$ ${product.price.toStringAsFixed(2)}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(icon: const Icon(Icons.remove_circle_outline), onPressed: () => context.read<ProductController>().decrementQuantity(product.id)),
                Text('${product.quantity}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isLowStock ? Colors.red : Colors.black)),
                IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: () => context.read<ProductController>().incrementQuantity(product.id)),
                IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red), onPressed: () => _showDeleteConfirmDialog(context, product)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGridView(BuildContext context, ProductController productController) {
    final products = productController.products;
    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 8, mainAxisSpacing: 8, childAspectRatio: 0.75),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final ProductModel product = products[index];
        final bool isLowStock = product.quantity <= product.minimumQuantity;
        return Card(
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
                    IconButton(icon: const Icon(Icons.remove_circle_outline), onPressed: () => context.read<ProductController>().decrementQuantity(product.id)),
                    Text('${product.quantity}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isLowStock ? Colors.red : Colors.black)),
                    IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: () => context.read<ProductController>().incrementQuantity(product.id)),
                  ],
                ),
                Center(child: IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red), onPressed: () => _showDeleteConfirmDialog(context, product))),
              ],
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
                context.read<ProductController>().deleteProduct(product.id);
                Navigator.of(ctx).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

// --- WIDGET DA ABA DE RESUMO ---
class SummaryTab extends StatelessWidget {
  const SummaryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductController>(
      builder: (context, controller, child) {
        final toRestock = controller.productsToRestock;
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
                      _buildSummaryInfo('Itens Únicos', controller.totalUniqueProducts.toString()),
                      _buildSummaryInfo('Custo p/ Repor', 'R\$ ${controller.restockCost.toStringAsFixed(2)}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text('Itens para Repor', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const Divider(),
              const SizedBox(height: 8),
              if (toRestock.isEmpty) const Center(child: Text('Nenhum item com estoque baixo. Parabéns!')),
              if (toRestock.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: toRestock.length,
                  itemBuilder: (context, index) {
                    final product = toRestock[index];
                    return Card(
                      color: Colors.red.shade50,
                      child: ListTile(
                        leading: const Icon(Icons.warning_amber_rounded, color: Colors.red),
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
}


// #############################################################################
// A CLASSE DA TELA PRINCIPAL (HOMESCREEN) VEM POR ÚLTIMO
// #############################################################################

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _isGridView = false;
  final _searchController = TextEditingController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final productController = Provider.of<ProductController>(context, listen: false);
    final List<Widget> widgetOptions = <Widget>[
      CatalogTab(isGridView: _isGridView),
      const SummaryTab(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: _selectedIndex == 0
            ? TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Buscar produtos...',
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      productController.search('');
                    },
                  ),
                ),
                onChanged: (query) => productController.search(query),
              )
            : const Text('Resumo'),
        automaticallyImplyLeading: false,
        actions: [
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
      body: widgetOptions.elementAt(_selectedIndex),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AddEditProductScreen()));
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