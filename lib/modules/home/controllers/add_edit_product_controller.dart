import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocklite_app/data/models/product_model.dart';
import 'package:stocklite_app/modules/home/controllers/product_controller.dart';
import 'dart:math';

class AddEditProductController {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final categoryController = TextEditingController();
  final quantityController = TextEditingController();
  final minQuantityController = TextEditingController();

  String? saveProduct(BuildContext context) {
    final String name = nameController.text;
    final String priceText = priceController.text;
    final String category = categoryController.text;
    final String quantityText = quantityController.text;
    final String minQuantityText = minQuantityController.text;

    if (name.trim().isEmpty || priceText.trim().isEmpty || category.trim().isEmpty || quantityText.trim().isEmpty || minQuantityText.trim().isEmpty) {
      return 'Por favor, preencha todos os campos.';
    }

    try {
      final double? price = double.tryParse(priceText.replaceAll(',', '.'));
      final int? quantity = int.tryParse(quantityText);
      final int? minQuantity = int.tryParse(minQuantityText);

      if (price == null || quantity == null || minQuantity == null) {
        return 'Os campos de preço e quantidade devem conter apenas números.';
      }
      
      // AQUI ESTÁ A SUA CORREÇÃO APLICADA!
      if (price <= 0) {
        return 'O preço deve ser um valor positivo.';
      }
      if (quantity < 0) {
        return 'A quantidade não pode ser negativa.';
      }
      if (minQuantity < 0) {
        return 'A quantidade mínima não pode ser negativa.';
      }

      final newProduct = ProductModel(
        id: Random().nextInt(999999).toString(),
        name: name,
        price: price,
        category: category,
        quantity: quantity,
        minimumQuantity: minQuantity,
      );

      final productController = Provider.of<ProductController>(context, listen: false);
      productController.addProduct(newProduct);
      
      return null;

    } catch (e) {
      return 'Ocorreu um erro ao salvar. Verifique os valores inseridos.';
    }
  }
}