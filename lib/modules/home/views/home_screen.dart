import 'package:flutter/material.dart';
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

  // NOVO: Variável de estado para controlar o modo de visualização.
  // Começa como 'false', ou seja, o padrão é a visualização em LISTA.
  bool _isGridView = false;

  // A lista de widgets agora precisa receber o estado de visualização.
  // Por isso, não pode ser 'static final' mais.
  late final List<Widget> _widgetOptions;

  // 'initState' é um método especial que é chamado uma única vez
  // quando o widget é criado. É o lugar perfeito para inicializar nossas variáveis.
  @override
  void initState() {
    super.initState();
    // Inicializamos nossa lista de abas aqui.
    _widgetOptions = <Widget>[
      // Passamos a variável de estado para a aba de Catálogo.
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
          // NOVO: O botão de Toggle!
          // Só mostramos o botão se a aba de Catálogo estiver selecionada.
          if (_selectedIndex == 0)
            IconButton(
              // O ícone muda dependendo do modo de visualização atual.
              icon: Icon(_isGridView ? Icons.view_list_rounded : Icons.grid_view_rounded),
              tooltip: 'Alterar Visualização', // Texto de ajuda
              onPressed: () {
                // Ao pressionar, usamos setState para inverter o valor da nossa variável.
                setState(() {
                  _isGridView = !_isGridView;
                  // ATENÇÃO: Precisamos reconstruir nossa lista de abas com o novo valor.
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

// O widget CatalogTab agora precisa saber qual visualização mostrar.
class CatalogTab extends StatelessWidget {
  // Recebemos o valor de 'isGridView' da tela principal.
  final bool isGridView;
  const CatalogTab({super.key, required this.isGridView});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductController>(
      builder: (context, productController, child) {
        if (productController.products.isEmpty) {
          return const Center(child: Text('Nenhum produto cadastrado ainda.'));
        }

        // --- AQUI ESTÁ A LÓGICA DO TOGGLE ---
        // Usamos um operador ternário para decidir qual widget construir.
        return isGridView
            ? _buildGridView(productController.products) // Se for grade, constrói a grade.
            : _buildListView(productController.products); // Senão, constrói a lista.
      },
    );
  }

  // MÉTODO PARA CONSTRUIR A LISTA (O que já tínhamos)
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

  // NOVO: MÉTODO PARA CONSTRUIR A GRADE
  Widget _buildGridView(List<ProductModel> products) {
    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      // 'gridDelegate' define o layout da grade.
      // 'SliverGridDelegateWithFixedCrossAxisCount' cria uma grade com um número fixo de colunas.
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 colunas
        crossAxisSpacing: 8, // Espaçamento horizontal entre os cards
        mainAxisSpacing: 8, // Espaçamento vertical
        childAspectRatio: 0.8, // Proporção dos cards (largura / altura)
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final ProductModel product = products[index];
        final bool isLowStock = product.quantity <= product.minimumQuantity;
        
        // Usamos um Card para cada item da grade, com um layout vertical (Column).
        return Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ícone com o alerta de estoque baixo no canto.
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