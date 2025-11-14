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

  Stream<List<SupplierModel>> getSuppliersStream() {
    try {
      return _getSuppliersCollection().orderBy('name').snapshots().map((snapshot) {
        return snapshot.docs.map((doc) => doc.data()).toList();
      });
    } catch (e) {
      print("Erro ao obter stream de fornecedores: $e");
      return Stream.value([]);
    }
  }

  Future<void> addSupplier(String supplierName) async {
    try {
      // Modificado: Agora cria um modelo completo com 5 campos (4 vazios)
      final newSupplier = SupplierModel(
        id: '', 
        name: supplierName,
        description: '',
        contactPerson: '',
        email: '',
        phone: ''
      );
      await _getSuppliersCollection().add(newSupplier);
    } catch (e) {
      print("Erro ao adicionar fornecedor: $e");
      rethrow;
    }
  }

  // Novo: Método de atualização para RF004
  Future<void> updateSupplier(String supplierId, String newName) async {
    try {
      // Atualiza apenas o nome, o que é suficiente para o RF004
      await _getSuppliersCollection().doc(supplierId).update({'name': newName});
    } catch (e) {
      print("Erro ao atualizar fornecedor: $e");
      rethrow;
    }
  }

  Future<void> deleteSupplier(String supplierId) async {
    try {
      await _getSuppliersCollection().doc(supplierId).delete();
    } catch (e) {
      print("Erro ao deletar fornecedor: $e");
      rethrow;
    }
  }
}