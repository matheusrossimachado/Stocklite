import 'package:flutter/material.dart';

class LoginController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // MUDANÇA: O método agora retorna um 'bool' (true ou false)
  bool login() {
    String email = emailController.text;
    String password = passwordController.text;

    // --- NOSSA LÓGICA DE LOGIN "FAKE" ---
    // Verificamos se o email e a senha correspondem aos valores corretos.
    if (email == 'teste@teste.com' && password == '123456') {
      print('Login bem-sucedido!');
      // Se o login estiver correto, retornamos true.
      return true;
    } else {
      print('Erro de login: credenciais inválidas.');
      // Se estiver incorreto, retornamos false.
      return false;
    }
  }
}