import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordController {
  final emailController = TextEditingController();

  // Método 'async' para "esperar" a resposta do Firebase
  Future<String?> sendPasswordResetEmail() async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      return 'Por favor, digite seu e-mail.';
    }

    try {
      // AQUI ESTÁ A MÁGICA (RF001)
      // Pedimos ao Firebase para enviar o e-mail de redefinição.
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      
      // Se não deu erro, retornamos 'null' (sucesso)
      return null;

    } on FirebaseAuthException catch (e) {
      // Traduzimos os erros mais comuns do Firebase
      if (e.code == 'user-not-found') {
        return 'Nenhuma conta encontrada para este e-mail.';
      } else if (e.code == 'invalid-email') {
        return 'O formato do e-mail é inválido.';
      } else {
        return 'Ocorreu um erro. Tente novamente.';
      }
    }
  }
}