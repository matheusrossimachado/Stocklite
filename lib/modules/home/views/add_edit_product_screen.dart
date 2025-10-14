import 'package:flutter/material.dart';
// 1. IMPORTANDO O NOSSO NOVO CONTROLLER
import 'package:stocklite_app/modules/home/controllers/add_edit_product_controller.dart';

class AddEditProductScreen extends StatefulWidget {
  const AddEditProductScreen({super.key});

  @override
  State<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  // 2. INSTANCIANDO O CONTROLLER
  final _controller = AddEditProductController();

  final List<String> _categories = ['Alimentos', 'Limpeza', 'Higiene', 'Bebidas', 'Outros'];
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Produto'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 3. CONECTANDO CADA CAMPO AO SEU CONTROLLER
            TextFormField(
              controller: _controller.nameController, // Conectado
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Nome do Produto',
                prefixIcon: Icon(Icons.label_outline),
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _controller.priceController, // Conectado
              textInputAction: TextInputAction.next,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Preço',
                prefixIcon: Icon(Icons.monetization_on_outlined),
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Categoria',
                prefixIcon: Icon(Icons.category_outlined),
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
              value: _selectedCategory,
              hint: const Text('Selecione uma categoria'),
              items: _categories.map((String category) {
                return DropdownMenuItem<String>(value: category, child: Text(category));
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCategory = newValue;
                  // 4. ATUALIZANDO O CONTROLLER QUANDO A CATEGORIA MUDA
                  _controller.categoryController.text = newValue ?? '';
                });
              },
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _controller.quantityController, // Conectado
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Quantidade',
                      prefixIcon: Icon(Icons.inventory_2_outlined),
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _controller.minQuantityController, // Conectado
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Qtd. Mínima',
                      prefixIcon: Icon(Icons.warning_amber_rounded),
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 48),

            // 5. IMPLEMENTANDO A LÓGICA DO BOTÃO SALVAR
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                // Chamamos nosso método de salvar do controller.
                final String? errorMessage = _controller.saveProduct(context);

                if (errorMessage != null) {
                  // Se houver um erro, mostramos a SnackBar vermelha.
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
                  );
                } else {
                  // Se for sucesso (null), mostramos a SnackBar verde...
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Produto salvo com sucesso!'), backgroundColor: Colors.green),
                  );
                  // ...e fechamos a tela de formulário, voltando para a Home.
                  Navigator.of(context).pop();
                }
              },
              child: const Text('SALVAR PRODUTO', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}