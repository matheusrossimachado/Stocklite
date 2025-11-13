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
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Adicionar Produto')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _controller.barcodeController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Código de Barras (EAN)',
                      prefixIcon: Icon(Icons.qr_code),
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.deepPurple.shade50,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.all(16),
                  ),
                  icon: _isSearching 
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.search, color: Colors.deepPurple),
                  
                  // A LÓGICA FINAL E CORRETA
                  onPressed: () async {
                    setState(() => _isSearching = true); // 1. Começa o loading
                    
                    try {
                      // 2. Tenta buscar o nome do produto
                      final productName = await _controller.searchByBarcode();

                      // 3. ATUALIZA O CONTROLLER PRIMEIRO!
                      _controller.nameController.text = productName;
                      
                      // 4. SÓ DEPOIS, ATUALIZA A TELA (para o spinner)
                      setState(() => _isSearching = false); 

                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Produto encontrado!'), backgroundColor: Colors.green));

                    } catch (e) {
                      // 5. ERRO!
                      setState(() => _isSearching = false); // Para o loading
                      
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            TextFormField(
              controller: _controller.nameController, // O TextFormFiedl está ouvindo aqui
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

            // Dropdown Categoria
            StreamBuilder<List<CategoryModel>>(
              stream: _categoryService.getCategoriesStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Text('Erro ao carregar categorias: ${snapshot.error}');
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('Nenhuma categoria cadastrada.');
                }
                final categories = snapshot.data!;
                if (_selectedCategory == null || !categories.any((c) => c.name == _selectedCategory)) {
                  _selectedCategory = categories.first.name;
                  _controller.categoryController.text = _selectedCategory!;
                }
                return DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Categoria', prefixIcon: Icon(Icons.category_outlined), border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12)))),
                  value: _selectedCategory,
                  items: categories.map((c) => DropdownMenuItem(value: c.name, child: Text(c.name))).toList(),
                  onChanged: (v) => setState(() { _selectedCategory = v; _controller.categoryController.text = v ?? ''; }),
                );
              },
            ),
            const SizedBox(height: 16),

            // Dropdown Fornecedor
            StreamBuilder<List<SupplierModel>>(
              stream: _supplierService.getSuppliersStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Text('Erro ao carregar fornecedores: ${snapshot.error}');
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('Nenhum fornecedor cadastrado.');
                }
                final suppliers = snapshot.data!;
                if (_selectedSupplier == null || !suppliers.any((s) => s.name == _selectedSupplier)) {
                  _selectedSupplier = suppliers.first.name;
                  _controller.supplierController.text = _selectedSupplier!;
                }
                return DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Fornecedor', prefixIcon: Icon(Icons.store_outlined), border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12)))),
                  value: _selectedSupplier,
                  items: suppliers.map((s) => DropdownMenuItem(value: s.name, child: Text(s.name))).toList(),
                  onChanged: (v) => setState(() { _selectedSupplier = v; _controller.supplierController.text = v ?? ''; }),
                );
              },
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(child: TextFormField(controller: _controller.quantityController, textInputAction: TextInputAction.next, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Quantidade', prefixIcon: Icon(Icons.inventory_2_outlined), border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12)))))),
                const SizedBox(width: 16),
                Expanded(child: TextFormField(controller: _controller.minQuantityController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Qtd. Mínima', prefixIcon: Icon(Icons.warning_amber_rounded), border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12)))))),
              ],
            ),
            const SizedBox(height: 48),

            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              onPressed: () async {
                final error = await _controller.saveProduct();
                if (!context.mounted) return;
                if (error != null) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error), backgroundColor: Colors.red));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Produto salvo!'), backgroundColor: Colors.green));
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