import 'package:flutter/material.dart';

// Nossa tela principal, o destino após o login.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Uma AppBar para dar um título à tela.
      appBar: AppBar(
        title: const Text('Stocklite - Início'),
        // Impede que o botão de "voltar" apareça automaticamente.
        automaticallyImplyLeading: false,
      ),
      // O corpo da tela, com uma mensagem de boas-vindas.
      body: const Center(
        child: Text(
          'Login efetuado com sucesso!\nBem-vindo!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}