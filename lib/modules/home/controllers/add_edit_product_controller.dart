import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stocklite_app/data/models/product_model.dart';
import 'package:stocklite_app/data/services/product_service.dart';
import 'dart:math';

class AddEditProductController {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final categoryController = TextEditingController();
  final quantityController = TextEditingController();
  final minQuantityController = TextEditingController();
  final supplierController = TextEditingController();
  final barcodeController = TextEditingController();

  final ProductService _productService = ProductService();

  // --- API (RF007) - VERSÃO CORRIGIDA ---
  Future<String> searchByBarcode() async {
    final barcode = barcodeController.text.trim();
    if (barcode.isEmpty) throw Exception('Digite um código de barras.');

    try {
      final url = Uri.parse('https://world.openfoodfacts.org/api/v0/product/$barcode.json');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == 1) {
          final productName = data['product']['product_name'];
          if (productName != null && productName.isNotEmpty) {
            // SUCESSO! Retorna o nome para a tela.
            return productName; 
          } else {
            throw Exception('Produto encontrado, mas sem nome cadastrado.');
          }
        } else {
          throw Exception('Produto não encontrado na base de dados.');
        }
      } else {
        throw Exception('Erro ao conectar com a API.');
      }
    } catch (e) {
      rethrow; // Re-lança o erro para a tela tratar
    }
  }

  // O método saveProduct() não muda
  Future<String?> saveProduct() async {
    final String name = nameController.text;
    final String priceText = priceController.text;
    final String category = categoryController.text;
    final String quantityText = quantityController.text;
    final String minQuantityText = minQuantityController.text;
    final String supplier = supplierController.text;

    if (name.trim().isEmpty || priceText.trim().isEmpty || category.trim().isEmpty || quantityText.trim().isEmpty || minQuantityText.trim().isEmpty || supplier.trim().isEmpty) {
      return 'Por favor, preencha todos os campos.';
    }

    try {
      final double? price = double.tryParse(priceText.replaceAll(',', '.'));
      final int? quantity = int.tryParse(quantityText);
      final int? minQuantity = int.tryParse(minQuantityText);

      if (price == null || quantity == null || minQuantity == null) {
        return 'Os campos de preço e quantidade devem conter apenas números.';
      }
      if (price <= 0) return 'O preço deve ser um valor positivo.';
      if (quantity < 0) return 'A quantidade não pode ser negativa.';
      if (minQuantity < 0) return 'A quantidade mínima não pode ser negativa.';

      final newProduct = ProductModel(
        id: '', 
        name: name,
        price: price,
        category: category,
        quantity: quantity,
        minimumQuantity: minQuantity,
        supplier: supplier,
      );

      await _productService.addProduct(newProduct);
      return null;

    } catch (e) {
      return 'Ocorreu um erro ao salvar: ${e.toString()}';
    }
  }
}