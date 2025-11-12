import 'package:flutter/material.dart';
// 1. IMPORTANDO AS FERRAMENTAS DO FIREBASE
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupController {
  final nameController = TextEditingController();
  final phoneController = TextEditingController(); // Vamos usar o text do 'intl_phone_number_input'
  String fullPhoneNumber = ''; // Vamos preencher isso pela tela
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // 2. O MÉTODO AGORA É 'ASYNC' E RETORNA UM ERRO OU NADA
  Future<String?> signup() async {
    final String name = nameController.text;
    final String phone = fullPhoneNumber; // Usamos o número completo
    final String email = emailController.text;
    final String password = passwordController.text;
    final String confirmPassword = confirmPasswordController.text;

    // --- VALIDAÇÃO DE CAMPOS (continua igual) ---
    if (name.trim().isEmpty || phone.trim().isEmpty || email.trim().isEmpty || password.trim().isEmpty) {
      return 'Por favor, preencha todos os campos.';
    }
    if (password != confirmPassword) {
      return 'As senhas não coincidem.';
    }
    // ... (outras validações que fizemos) ...
    
    try {
      // 3. PASSO 1: CRIAR O USUÁRIO NO FIREBASE AUTHENTICATION
      // Primeiro, criamos o usuário (email/senha) no serviço de autenticação.
      final UserCredential userCredential = 
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

      // Se chegamos aqui, o usuário foi criado com sucesso!
      final User? user = userCredential.user;

      if (user != null) {
        // 4. PASSO 2: SALVAR OS DADOS EXTRAS NO FIRESTORE
        // Agora, pegamos o ID único desse usuário (user.uid) e usamos como
        // chave para salvar os outros dados no banco de dados, na coleção "usuarios".
        await FirebaseFirestore.instance.collection('usuarios').doc(user.uid).set({
          'name': name,
          'phone': phone,
          'email': email,
          // Você pode adicionar qualquer outro campo que quiser aqui.
        });
      }
      
      // 5. SUCESSO!
      // Se tudo deu certo (Auth e Firestore), retornamos null (sem erro).
      return null;

    } on FirebaseAuthException catch (e) {
      // 6. DEU ERRO!
      // Traduzimos os erros do Firebase para o usuário. [cite: 14, 38]
      print('Erro de cadastro do Firebase: ${e.code}');
      if (e.code == 'weak-password') {
        return 'Sua senha é muito fraca.';
      } else if (e.code == 'email-already-in-use') {
        return 'Este e-mail já está sendo usado por outra conta.';
      } else if (e.code == 'invalid-email') {
        return 'O formato do e-mail é inválido.';
      } else {
        return 'Ocorreu um erro. Tente novamente mais tarde.';
      }
    }
  }
}