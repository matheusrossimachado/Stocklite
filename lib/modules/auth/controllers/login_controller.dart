import 'package:flutter/material.dart';
// 1. IMPORTANDO A FERRAMENTA DE AUTENTICAÇÃO DO FIREBASE
import 'package:firebase_auth/firebase_auth.dart';

class LoginController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // 2. MUDANÇA: O método agora é 'async' (assíncrono) porque
  // ele precisa "esperar" a resposta do Firebase.
  // Ele vai retornar uma String? (String nula) se der certo,
  // ou uma mensagem de erro se falhar.
  Future<String?> login() async {
    String email = emailController.text;
    String password = passwordController.text;

    try {
      // 3. A MÁGICA REAL!
      // Estamos pedindo ao Firebase para tentar fazer o login com o email e senha.
      // O 'await' pausa o código aqui até o Firebase responder.
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 4. SUCESSO!
      // Se o 'await' acima não deu erro, o login foi um sucesso!
      // Retornamos 'null' (sem mensagem de erro).
      return null;
      
    } on FirebaseAuthException catch (e) {
      // 5. DEU ERRO!
      // O Firebase nos devolve um 'e' (erro) com um código.
      // Nós "traduzimos" esse código para uma mensagem amigável.
      print('Erro de login do Firebase: ${e.code}');
      if (e.code == 'user-not-found') {
        return 'Nenhuma conta encontrada para este e-mail.';
      } else if (e.code == 'wrong-password') {
        return 'Senha incorreta. Tente novamente.';
      } else if (e.code == 'invalid-email') {
        return 'O formato do e-mail é inválido.';
      } else {
        return 'Ocorreu um erro. Tente novamente mais tarde.';
      }
    }
  }
}