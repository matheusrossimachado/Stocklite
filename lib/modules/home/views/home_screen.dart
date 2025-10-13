import 'package:flutter/material.dart';
// 1. Importando a nossa nova tela "Sobre"
import 'package:stocklite_app/modules/about/views/about_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stocklite - Início'),
        automaticallyImplyLeading: false,
        // 2. Adicionando um botão de ação na AppBar
        actions: [
          // O 'actions' é uma lista de widgets que aparecem à direita do título.
          IconButton(
            // Usamos um ícone de informação.
            icon: const Icon(Icons.info_outline),
            // A ação que acontece ao pressionar o botão.
            onPressed: () {
              // Navegação simples para a nova tela.
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AboutScreen(),
                ),
              );
            },
          ),
        ],
      ),
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