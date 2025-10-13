import 'package:flutter/material.dart';

class SignupController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // MUDANÇA: O método agora retorna uma String que pode ser nula (String?).
  String? signup() {
    final String name = nameController.text;
    final String email = emailController.text;
    final String password = passwordController.text;
    final String confirmPassword = confirmPasswordController.text;

    // --- NOSSA LÓGICA DE VALIDAÇÃO ---

    // 1. Verificar se algum campo está vazio.
    // O método '.trim()' remove espaços em branco do início e do fim.
    if (name.trim().isEmpty || email.trim().isEmpty || password.trim().isEmpty || confirmPassword.trim().isEmpty) {
      return 'Por favor, preencha todos os campos.';
    }

    // 2. Verificar se o e-mail tem um formato minimamente válido.
    // A propriedade '.contains()' checa se a string contém um determinado texto.
    if (!email.contains('@') || !email.contains('.')) {
      return 'Por favor, insira um e-mail válido.';
    }

    // 3. Verificar o comprimento mínimo da senha.
    if (password.length < 6) {
      return 'A senha deve ter pelo menos 6 caracteres.';
    }

    // 4. Verificar se as senhas coincidem.
    if (password != confirmPassword) {
      return 'As senhas não coincidem.';
    }

    // 5. Se todas as validações passaram, retornamos null.
    print('Validação de cadastro bem-sucedida!');
    return null;
  }
}