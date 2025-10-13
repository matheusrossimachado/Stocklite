import 'package:flutter/material.dart';

class SignupController {
  final nameController = TextEditingController();
  // MUDANÇA: Removemos o phoneController e vamos guardar o número de outra forma.
  String fullPhoneNumber = ''; // <-- VAI GUARDAR O NÚMERO COMPLETO (ex: +5516999999999)
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String? signup() {
    final String name = nameController.text;
    // MUDANÇA: Usamos nossa nova variável.
    final String phone = fullPhoneNumber; 
    final String email = emailController.text;
    final String password = passwordController.text;
    final String confirmPassword = confirmPasswordController.text;

    if (name.trim().isEmpty || phone.trim().isEmpty || email.trim().isEmpty || password.trim().isEmpty || confirmPassword.trim().isEmpty) {
      return 'Por favor, preencha todos os campos.';
    }

    // Podemos adicionar uma validação simples para o telefone
    if(phone.length < 10){
       return 'Por favor, insira um telefone válido.';
    }

    if (!email.contains('@') || !email.contains('.')) {
      return 'Por favor, insira um e-mail válido.';
    }

    if (password.length < 6) {
      return 'A senha deve ter pelo menos 6 caracteres.';
    }

    if (password != confirmPassword) {
      return 'As senhas não coincidem.';
    }

    print('Validação de cadastro bem-sucedida!');
    print('Telefone completo: $phone');
    return null;
  }
}