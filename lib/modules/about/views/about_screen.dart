import 'package:flutter/material.dart';

// A nossa tela "Sobre", uma tela simples e informativa.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Usamos o Scaffold como esqueleto padrão da página.
    return Scaffold(
      // A AppBar com o título e o botão de voltar automático.
      appBar: AppBar(
        title: const Text('Sobre o Stocklite'),
      ),
      // Usamos um Padding para dar um respiro nas bordas da tela.
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          // Alinha o conteúdo no topo da tela.
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Ícone e Título Principal ---
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inventory_2_outlined,
                  size: 40,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Stocklite',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // --- Seção de Objetivo ---
            const Text(
              'Objetivo do Aplicativo',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'O Stocklite é um aplicativo desenvolvido para ajudar no controle de produtos e itens de despensa de forma simples e intuitiva. O objetivo é permitir que o usuário registre seus produtos, controle a quantidade em estoque e seja alertado quando um item estiver acabando.',
              style: TextStyle(fontSize: 16, height: 1.5), // height melhora a legibilidade
            ),
            const SizedBox(height: 32),

            // --- Seção da Equipe ---
            const Text(
              'Equipe de Desenvolvimento',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Usamos ListTile para um visual mais organizado para a lista de nomes.
            const ListTile(
              leading: Icon(Icons.person_outline),
              title: Text('Gabriel Cardozo'),
            ),
            const ListTile(
              leading: Icon(Icons.person_outline),
              title: Text('Matheus Rossi'),
            ),
          ],
        ),
      ),
    );
  }
}