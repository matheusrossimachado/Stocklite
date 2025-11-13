import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stocklite_app/data/models/category_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CategoryService {
  
  // Pega o ID do usuário que está logado
  String? get _userId => FirebaseAuth.instance.currentUser?.uid;

  // Referência para a coleção de CATEGORIAS do usuário logado
  // Caminho: /usuarios/{ID_DO_USUARIO}/categories
  CollectionReference<CategoryModel> _getCategoriesCollection() {
    if (_userId == null) {
      throw Exception('Usuário não está logado.');
    }
    
    return FirebaseFirestore.instance
        .collection('usuarios')
        .doc(_userId)
        .collection('categories')
        .withConverter<CategoryModel>(
          // Ensina o Firestore a LER nossos dados
          fromFirestore: (snapshot, _) => CategoryModel.fromFirestore(snapshot),
          // Ensina o Firestore a SALVAR nossos dados
          toFirestore: (category, _) => category.toMap(),
        );
  }

  // --- MÉTODOS DE CRUD ---

  // GET (Stream) - Retorna um "rio" de listas de categorias
  Stream<List<CategoryModel>> getCategoriesStream() {
    try {
      return _getCategoriesCollection().snapshots().map((snapshot) {
        return snapshot.docs.map((doc) => doc.data()).toList();
      });
    } catch (e) {
      print("Erro ao obter stream de categorias: $e");
      return Stream.value([]); // Retorna um stream vazio em caso de erro
    }
  }

  // CREATE - Adicionar Categoria
  Future<void> addCategory(String categoryName) async {
    try {
      // Criamos um modelo 'fake' só para usar o método toMap()
      // O Firestore vai gerar o ID.
      final newCategory = CategoryModel(id: '', name: categoryName);
      await _getCategoriesCollection().add(newCategory);
    } catch (e) {
      print("Erro ao adicionar categoria: $e");
      rethrow;
    }
  }
}