import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocklite_app/data/models/product_model.dart';
import 'package:stocklite_app/modules/about/views/about_screen.dart';
import 'package:stocklite_app/modules/home/controllers/product_controller.dart';
// 1. IMPORTANDO A NOSSA FUTURA TELA DE ADICIONAR PRODUTO
import 'package:stocklite_app/modules/home/views/add_edit_product_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _isGridView = false;
  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      CatalogTab(isGridView: _isGridView),
      const Center(
        child: Text('Aqui ficará o Resumo/Dashboard'),
      ),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedIndex == 0 ? 'Catálogo' : 'Resumo'),
        automaticallyImplyLeading: false,
        actions: [
          if (_selectedIndex == 0)
            IconButton(
              icon: Icon(_isGridView ? Icons.view_list_rounded : Icons.grid_view_rounded),
              tooltip: 'Alterar Visualização',
              onPressed: () {
                setState(() {
                  _isGridView = !_isGridView;
                  _widgetOptions[0] = CatalogTab(isGridView: _isGridView);
                });
              },
            ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AboutScreen()),
              );
            },
          ),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),

      // --- AQUI ESTÁ A NOVIDADE ---
      // A propriedade 'floatingActionButton' do Scaffold.
      floatingActionButton: _selectedIndex == 0 // SÓ MOSTRA O BOTÃO SE A ABA FOR A DE CATÁLOGO
    ? FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddEditProductScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      )
    : null, // Se não for a aba de catálogo, o botão não é construído (fica nulo).

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

// O resto do arquivo (CatalogTab, _buildListView, _buildGridView) continua igual.
class CatalogTab extends StatelessWidget {
  final bool isGridView;
  const CatalogTab({super.key, required this.isGridView});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductController>(
      builder: (context, productController, child) {
        if (productController.products.isEmpty) {
          return const Center(child: Text('Nenhum produto cadastrado ainda.'));
        }
        return isGridView
            ? _buildGridView(productController.products)
            : _buildListView(productController.products);
      },
    );
  }

  Widget _buildListView(List<ProductModel> products) {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final ProductModel product = products[index];
        final bool isLowStock = product.quantity <= product.minimumQuantity;
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            leading: Icon(Icons.shopping_bag_outlined, color: isLowStock ? Colors.red : Colors.deepPurple, size: 40),
            title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${product.category} - R\$ ${product.price.toStringAsFixed(2)}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isLowStock) const Icon(Icons.warning_amber_rounded, color: Colors.red),
                const SizedBox(width: 8),
                Text('${product.quantity}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isLowStock ? Colors.red : Colors.black)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGridView(List<ProductModel> products) {
    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.8,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final ProductModel product = products[index];
        final bool isLowStock = product.quantity <= product.minimumQuantity;
        return Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: isLowStock ? const Icon(Icons.warning_amber_rounded, color: Colors.red) : const SizedBox(),
                ),
                Expanded(
                  child: Center(
                    child: Icon(Icons.shopping_bag_outlined, color: isLowStock ? Colors.red : Colors.deepPurple, size: 50),
                  ),
                ),
                Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text('Qtd: ${product.quantity}', style: TextStyle(fontWeight: FontWeight.bold, color: isLowStock ? Colors.red : Colors.black)),
                Text('R\$ ${product.price.toStringAsFixed(2)}'),
              ],
            ),
          ),
        );
      },
    );
  }
}