import 'package:flutter/material.dart';

// A tela para o usuário recuperar a senha.
class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // A AppBar com fundo transparente e sem sombra para um visual limpo.
      // O Flutter adiciona o botão de "voltar" aqui para nós.
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      // O SingleChildScrollView para garantir que a tela seja rolável.
      body: SingleChildScrollView(
        // Padding para dar o espaçamento lateral padrão.
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- 1. Ícone e Título ---
            // Um ícone para dar um contexto visual à ação.
            const Icon(
              Icons.lock_reset_rounded,
              size: 80,
              color: Colors.deepPurple,
            ),
            const SizedBox(height: 16),
            const Text(
              'Esqueceu sua senha?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Sem problemas! Insira seu e-mail abaixo que enviaremos um link para você redefinir sua senha.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 48),

            // --- 2. Campo de E-mail ---
            // O único campo necessário nesta tela.
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'E-mail',
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // --- 3. Botão de Enviar ---
            // O botão principal para executar a ação.
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                // No futuro, aqui ficará a lógica para chamar o Firebase
                // ou outro serviço para enviar o e-mail de recuperação.
                // Por agora, podemos apenas voltar para a tela de login.
                Navigator.of(context).pop();
              },
              child: const Text(
                'ENVIAR LINK',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}   