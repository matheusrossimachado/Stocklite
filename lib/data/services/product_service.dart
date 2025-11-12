import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stocklite_app/data/models/product_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProductService {
  
  String? get _userId => FirebaseAuth.instance.currentUser?.uid;

  CollectionReference<ProductModel> _getProductsCollection() {
    if (_userId == null) {
      throw Exception('Usuário não está logado.');
    }
    
    return FirebaseFirestore.instance
        .collection('usuarios')
        .doc(_userId)
        .collection('products')
        .withConverter<ProductModel>(
          fromFirestore: (snapshot, _) => ProductModel.fromFirestore(snapshot),
          toFirestore: (product, _) => product.toMap(),
        );
  }

  // GET (Stream)
  Stream<List<ProductModel>> getProductsStream() {
    try {
      return _getProductsCollection().snapshots().map((snapshot) {
        return snapshot.docs.map((doc) => doc.data()).toList();
      });
    } catch (e) {
      print("Erro ao obter stream de produtos: $e");
      return Stream.value([]);
    }
  }

  // CREATE
  Future<void> addProduct(ProductModel product) async {
    try {
      await _getProductsCollection().add(product);
    } catch (e) {
      print("Erro ao adicionar produto: $e");
      rethrow;
    }
  }

  // UPDATE
  Future<void> updateQuantity(String productId, int newQuantity) async {
    if (newQuantity < 0) return Future.value();
    try {
      await _getProductsCollection().doc(productId).update({'quantity': newQuantity});
    } catch (e) {
      print("Erro ao atualizar quantidade do produto: $e");
      rethrow;
    }
  }

  // DELETE
  Future<void> deleteProduct(String productId) async {
    try {
      await _getProductsCollection().doc(productId).delete();
    } catch (e) {
      print("Erro ao deletar produto: $e");
      rethrow;
    }
  }
}