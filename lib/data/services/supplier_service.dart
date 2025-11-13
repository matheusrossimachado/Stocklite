import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stocklite_app/data/models/supplier_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SupplierService {
  
  String? get _userId => FirebaseAuth.instance.currentUser?.uid;

  CollectionReference<SupplierModel> _getSuppliersCollection() {
    if (_userId == null) {
      throw Exception('Usuário não está logado.');
    }
    
    return FirebaseFirestore.instance
        .collection('usuarios')
        .doc(_userId)
        .collection('suppliers')
        .withConverter<SupplierModel>(
          fromFirestore: (snapshot, _) => SupplierModel.fromFirestore(snapshot),
          toFirestore: (supplier, _) => supplier.toMap(),
        );
  }

  // --- MÉTODOS DE CRUD ---

  Stream<List<SupplierModel>> getSuppliersStream() {
    try {
      return _getSuppliersCollection().snapshots().map((snapshot) {
        return snapshot.docs.map((doc) => doc.data()).toList();
      });
    } catch (e) {
      print("Erro ao obter stream de fornecedores: $e");
      return Stream.value([]);
    }
  }

  Future<void> addSupplier(String supplierName) async {
    try {
      final newSupplier = SupplierModel(id: '', name: supplierName);
      await _getSuppliersCollection().add(newSupplier);
    } catch (e) {
      print("Erro ao adicionar fornecedor: $e");
      rethrow;
    }
  }
}