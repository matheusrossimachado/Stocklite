import 'package:flutter/material.dart';
// 1. IMPORTANDO AS FERRAMENTAS E MODELOS
import 'package:provider/provider.dart';
import 'package:stocklite_app/data/models/product_model.dart';
import 'package:stocklite_app/modules/about/views/about_screen.dart';
import 'package:stocklite_app/modules/home/controllers/product_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // 2. A LISTA DE TELAS AGORA TEM NOSSO CATÁLOGO DE VERDADE
  static final List<Widget> _widgetOptions = <Widget>[
    // Posição 0: A nova tela do Catálogo
    const CatalogTab(), // Substituímos o Center por um widget dedicado

    // Posição 1: A tela do Resumo (continua como placeholder)
    const Center(
      child: Text(
        'Aqui ficará o Resumo/Dashboard',
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    ),
  ];

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
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.view_list_rounded),
            label: 'Catálogo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_rounded),
            label: 'Resumo',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurple,
        onTap: _onItemTapped,
      ),
    );
  }
}

// 3. O WIDGET DEDICADO PARA A ABA DE CATÁLOGO
class CatalogTab extends StatelessWidget {
  const CatalogTab({super.key});

  @override
  Widget build(BuildContext context) {
    // 4. A MÁGICA DO CONSUMER
    // O widget Consumer "ouve" o ProductController. Toda vez que o controller
    // chamar 'notifyListeners()', o Consumer vai reconstruir o que está dentro do 'builder'.
    return Consumer<ProductController>(
      builder: (context, productController, child) {
        // 5. CONSTRUINDO A LISTA
        // Usamos ListView.builder para criar a lista de forma eficiente.
        // Ele só constrói os itens que estão visíveis na tela.
        return ListView.builder(
          // Dizemos quantos itens a lista terá no total.
          itemCount: productController.products.length,
          // 'itemBuilder' é a receita para construir cada item da lista.
          itemBuilder: (context, index) {
            // Pegamos o produto específico para esta posição da lista.
            final ProductModel product = productController.products[index];

            // 6. O VISUAL DE CADA ITEM DA LISTA
            // Usamos um ListTile, que é perfeito para exibir informações de forma organizada.
            return ListTile(
              // 'leading' é o widget que aparece no início.
              leading: const Icon(Icons.shopping_bag_outlined),
              // 'title' é o texto principal.
              title: Text(product.name),
              // 'subtitle' é o texto secundário, abaixo do título.
              subtitle: Text('${product.category} - R\$ ${product.price.toStringAsFixed(2)}'),
              // 'trailing' é o widget que aparece no final.
              trailing: Text(
                'Qtd: ${product.quantity}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            );
          },
        );
      },
    );
  }
}