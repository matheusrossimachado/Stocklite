import 'package:flutter/material.dart';
import 'package:stocklite_app/data/models/category_model.dart';
import 'package:stocklite_app/data/models/supplier_model.dart';
import 'package:stocklite_app/data/services/category_service.dart';
import 'package:stocklite_app/data/services/supplier_service.dart';
import 'package:stocklite_app/modules/home/controllers/add_edit_product_controller.dart';

class AddEditProductScreen extends StatefulWidget {
  const AddEditProductScreen({super.key});

  @override
  State<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final _controller = AddEditProductController();
  final CategoryService _categoryService = CategoryService();
  final SupplierService _supplierService = SupplierService();

  String? _selectedCategory;
  String? _selectedSupplier;

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
            TextFormField(
              controller: _controller.nameController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Nome do Produto',
                prefixIcon: Icon(Icons.label_outline),
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _controller.priceController,
              textInputAction: TextInputAction.next,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Preço',
                prefixIcon: Icon(Icons.monetization_on_outlined),
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
            ),
            const SizedBox(height: 16),

            // --- DROPDOWN DE CATEGORIA ---
            StreamBuilder<List<CategoryModel>>(
              stream: _categoryService.getCategoriesStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                if (snapshot.data!.isEmpty) return const Text('Nenhuma categoria cadastrada.');

                final categories = snapshot.data!;
                
                if (_selectedCategory == null || !categories.any((c) => c.name == _selectedCategory)) {
                  _selectedCategory = categories.first.name;
                  _controller.categoryController.text = _selectedCategory!;
                }

                return DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Categoria',
                    prefixIcon: Icon(Icons.category_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                  ),
                  value: _selectedCategory,
                  items: categories.map((CategoryModel category) {
                    return DropdownMenuItem<String>(value: category.name, child: Text(category.name));
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCategory = newValue;
                      _controller.categoryController.text = newValue ?? '';
                    });
                  },
                );
              },
            ),
            const SizedBox(height: 16),

            // --- DROPDOWN DE FORNECEDOR ---
            StreamBuilder<List<SupplierModel>>(
              stream: _supplierService.getSuppliersStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                if (snapshot.data!.isEmpty) return const Text('Nenhum fornecedor cadastrado. Adicione na tela de Resumo.');

                final suppliers = snapshot.data!;
                
                if (_selectedSupplier == null || !suppliers.any((s) => s.name == _selectedSupplier)) {
                  _selectedSupplier = suppliers.first.name;
                  _controller.supplierController.text = _selectedSupplier!;
                }

                return DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Fornecedor',
                    prefixIcon: Icon(Icons.store_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                  ),
                  value: _selectedSupplier,
                  items: suppliers.map((SupplierModel supplier) {
                    return DropdownMenuItem<String>(value: supplier.name, child: Text(supplier.name));
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedSupplier = newValue;
                      _controller.supplierController.text = newValue ?? '';
                    });
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _controller.quantityController,
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
                    controller: _controller.minQuantityController,
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

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () async {
                final String? errorMessage = await _controller.saveProduct();

                if (!context.mounted) return;
                if (errorMessage != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Produto salvo com sucesso!'), backgroundColor: Colors.green),
                  );
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