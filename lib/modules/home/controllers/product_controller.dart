import 'package:flutter/material.dart';

class ProductController extends ChangeNotifier {
  
  String _searchQuery = '';
  String? _categoryFilter;

  String get searchQuery => _searchQuery;
  String? get categoryFilter => _categoryFilter;

  List<String> get uniqueCategories {
    return ['Alimentos', 'Limpeza', 'Higiene', 'Bebidas', 'Outros'];
  }

  void search(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void filterByCategory(String? category) {
    _categoryFilter = category;
    notifyListeners();
  }
}