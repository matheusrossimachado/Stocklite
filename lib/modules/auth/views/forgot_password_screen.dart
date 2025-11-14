import 'package:flutter/material.dart';
// 1. IMPORTANDO O NOVO CONTROLLER
import 'package:stocklite_app/modules/auth/controllers/forgot_password_controller.dart';

// 2. CONVERTIDO PARA STATEFULWIDGET
// Para podermos ter o controller do campo de texto
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  // 3. INSTANCIANDO O CONTROLLER
  final _controller = ForgotPasswordController();
  bool _isLoading = false; // Para mostrar um spinner de loading

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recuperar Senha'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ... (Ícone e Títulos que já tínhamos) ...
            const Icon(
              Icons.lock_reset_rounded,
              size: 80,
              color: Colors.deepPurple,
            ),
            const SizedBox(height: 16),
            const Text(
              'Esqueceu sua senha?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Insira seu e-mail abaixo que enviaremos um link para você redefinir sua senha.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 48),

            // 4. CAMPO DE E-MAIL CONECTADO
            TextFormField(
              controller: _controller.emailController, // Conectado!
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

            // 5. BOTÃO DE ENVIAR COM LÓGICA 'async'
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _isLoading ? null : () async { // Desabilita o botão se estiver carregando
                setState(() => _isLoading = true); // Inicia o loading
                
                final String? errorMessage = await _controller.sendPasswordResetEmail();

                if (!context.mounted) return;

                if (errorMessage == null) {
                  // SUCESSO!
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Link de recuperação enviado! Verifique seu e-mail.'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.of(context).pop(); // Volta para o login
                } else {
                  // ERRO!
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(errorMessage),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
                
                setState(() => _isLoading = false); // Para o loading
              },
              // 6. MOSTRA O SPINNER OU O TEXTO NO BOTÃO
              child: _isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Text(
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