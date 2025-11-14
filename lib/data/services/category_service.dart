import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stocklite_app/data/models/category_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CategoryService {
  
  String? get _userId => FirebaseAuth.instance.currentUser?.uid;

  CollectionReference<CategoryModel> _getCategoriesCollection() {
    if (_userId == null) {
      throw Exception('Usuário não está logado.');
    }
    
    return FirebaseFirestore.instance
        .collection('usuarios')
        .doc(_userId)
        .collection('categories')
        .withConverter<CategoryModel>(
          fromFirestore: (snapshot, _) => CategoryModel.fromFirestore(snapshot),
          toFirestore: (category, _) => category.toMap(),
        );
  }

  Stream<List<CategoryModel>> getCategoriesStream() {
    try {
      return _getCategoriesCollection().orderBy('name').snapshots().map((snapshot) {
        return snapshot.docs.map((doc) => doc.data()).toList();
      });
    } catch (e) {
      print("Erro ao obter stream de categorias: $e");
      return Stream.value([]);
    }
  }

  Future<void> addCategory(String categoryName) async {
    try {
      // Modificado: Agora cria um modelo completo com 5 campos (4 vazios)
      final newCategory = CategoryModel(
        id: '', 
        name: categoryName,
        description: '',
        contactPerson: '',
        email: '',
        phone: ''
      );
      await _getCategoriesCollection().add(newCategory);
    } catch (e) {
      print("Erro ao adicionar categoria: $e");
      rethrow;
    }
  }

  // Novo: Método de atualização para RF004
  Future<void> updateCategory(String categoryId, String newName) async {
    try {
      // Atualiza apenas o nome, o que é suficiente para o RF004
      await _getCategoriesCollection().doc(categoryId).update({'name': newName});
    } catch (e) {
      print("Erro ao atualizar categoria: $e");
      rethrow;
    }
  }

  Future<void> deleteCategory(String categoryId) async {
    try {
      await _getCategoriesCollection().doc(categoryId).delete();
    } catch (e) {
      print("Erro ao deletar categoria: $e");
      rethrow;
    }
  }
}