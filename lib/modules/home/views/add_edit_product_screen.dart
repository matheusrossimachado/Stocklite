import 'package:flutter/material.dart';
import 'package:stocklite_app/data/models/category_model.dart';
import 'package:stocklite_app/data/models/supplier_model.dart';
import 'package:stocklite_app/data/services/category_service.dart';
import 'package:stocklite_app/data/services/supplier_service.dart';
import 'package:stocklite_app/modules/home/controllers/add_edit_product_controller.dart';
import 'package:stocklite_app/data/models/product_model.dart'; // Importando o ProductModel

class AddEditProductScreen extends StatefulWidget {
  // 1. NOVO PARÂMETRO: O PRODUTO A SER EDITADO
  final ProductModel? product;

  const AddEditProductScreen({super.key, this.product});

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

  // 2. NOVO: Variável para saber se estamos em modo de edição
  bool get _isEditing => widget.product != null;

  @override
  void initState() {
    super.initState();
    // 3. PRÉ-PREENCHIMENTO DOS CAMPOS!
    if (_isEditing) {
      _controller.nameController.text = widget.product!.name;
      _controller.priceController.text = widget.product!.price.toString();
      _controller.quantityController.text = widget.product!.quantity.toString();
      _controller.minQuantityController.text = widget.product!.minimumQuantity.toString();
      
      _selectedCategory = widget.product!.category;
      _controller.categoryController.text = widget.product!.category;
      _selectedSupplier = widget.product!.supplier;
      _controller.supplierController.text = widget.product!.supplier;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // 4. TÍTULO DINÂMICO
        title: Text(_isEditing ? 'Editar Produto' : 'Adicionar Produto'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            
            // Ocultamos a busca por código de barras no modo de edição
            if (!_isEditing)
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
                    onPressed: () async {
                      setState(() => _isSearching = true);
                      try {
                        final productName = await _controller.searchByBarcode();
                        _controller.nameController.text = productName;
                        setState(() => _isSearching = false);
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Produto encontrado!'), backgroundColor: Colors.green));
                      } catch (e) {
                        setState(() => _isSearching = false);
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
                      }
                    },
                  ),
                ],
              ),
            if (!_isEditing) const SizedBox(height: 24),
            
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

            // Dropdown Categoria
            StreamBuilder<List<CategoryModel>>(
              stream: _categoryService.getCategoriesStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                if (snapshot.hasError) return Text('Erro: ${snapshot.error}');
                if (!snapshot.hasData || snapshot.data!.isEmpty) return const Text('Nenhuma categoria cadastrada.');
                
                final categories = snapshot.data!;
                
                if (_controller.categoryController.text.isEmpty) {
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
                if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                if (snapshot.hasError) return Text('Erro: ${snapshot.error}');
                if (!snapshot.hasData || snapshot.data!.isEmpty) return const Text('Nenhum fornecedor cadastrado.');

                final suppliers = snapshot.data!;

                if (_controller.supplierController.text.isEmpty) {
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
                // 5. LÓGICA DO BOTÃO ATUALIZADA
                final error = await _controller.saveProduct(widget.product);
                
                if (!context.mounted) return;
                if (error != null) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error), backgroundColor: Colors.red));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(_isEditing ? 'Produto atualizado!' : 'Produto salvo!'),
                      backgroundColor: Colors.green
                    )
                  );
                  Navigator.of(context).pop();
                }
              },
              child: Text(
                _isEditing ? 'ATUALIZAR PRODUTO' : 'SALVAR PRODUTO',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
              ),
            ),
          ],
        ),
      ),
    );
  }
}