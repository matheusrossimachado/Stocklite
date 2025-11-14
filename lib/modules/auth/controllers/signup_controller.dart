import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupController {
  final nameController = TextEditingController();
  String fullPhoneNumber = '';
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  Future<String?> signup() async {
    final String name = nameController.text;
    final String phone = fullPhoneNumber;
    final String email = emailController.text;
    final String password = passwordController.text;
    final String confirmPassword = confirmPasswordController.text;

    // --- VALIDAÇÃO DE CAMPOS VAZIOS (continua igual) ---
    if (name.trim().isEmpty || phone.trim().isEmpty || email.trim().isEmpty || password.trim().isEmpty) {
      return 'Por favor, preencha todos os campos.';
    }
    
    // --- NOVA VALIDAÇÃO DE SENHA FORTE (RF002) ---
    // 1. Checagem de Comprimento Mínimo
    if (password.length < 8) {
      return 'A senha deve ter pelo menos 8 caracteres.';
    }
    // 2. Checagem de Letra Maiúscula
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return 'A senha deve conter pelo menos uma letra maiúscula.';
    }
    // 3. Checagem de Letra Minúscula
    if (!password.contains(RegExp(r'[a-z]'))) {
      return 'A senha deve conter pelo menos uma letra minúscula.';
    }
    // 4. Checagem de Número
    if (!password.contains(RegExp(r'[0-9]'))) {
      return 'A senha deve conter pelo menos um número.';
    }
    // 5. Checagem de Caractere Especial
    if (!password.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'))) {
      return 'A senha deve conter pelo menos um caractere especial (ex: !@#\$%).';
    }
    // 6. Checagem se as senhas coincidem (continua igual)
    if (password != confirmPassword) {
      return 'As senhas não coincidem.';
    }
    // --- FIM DA VALIDAÇÃO DE SENHA ---

    try {
      // PASSO 1: CRIAR O USUÁRIO NO AUTHENTICATION
      final UserCredential userCredential = 
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

      final User? user = userCredential.user;

      if (user != null) {
        // PASSO 2: SALVAR OS DADOS EXTRAS NO FIRESTORE
        await FirebaseFirestore.instance.collection('usuarios').doc(user.uid).set({
          'name': name,
          'phone': phone,
          'email': email,
        });
      }
      
      // SUCESSO!
      return null;

    } on FirebaseAuthException catch (e) {
      // Tratamento de erros do Firebase (continua igual)
      print('Erro de cadastro do Firebase: ${e.code}');
      if (e.code == 'weak-password') {
        // O Firebase também checa, mas a nossa checagem é mais específica
        return 'A senha é muito fraca (padrão Firebase).';
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