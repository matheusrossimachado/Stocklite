import 'package:flutter/material.dart';

// IMPORTANDO NOSSAS NOVAS TELAS. Agora vai funcionar, pois os arquivos existem!
import 'package:stocklite_app/modules/auth/views/forgot_password_screen.dart';
import 'package:stocklite_app/modules/auth/views/signup_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: screenSize.height,
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- Partes 1, 2 e 3 não mudam ---
              const Icon(
                Icons.inventory_2_outlined,
                size: 80,
                color: Colors.deepPurple,
              ),
              const SizedBox(height: 16),
              const Text(
                'Bem-vindo ao Stocklite',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Faça login para continuar',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 48),
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
              const SizedBox(height: 16),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  prefixIcon: Icon(Icons.lock_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // --- 4. Botão "Esqueci minha senha" ---
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  // AQUI ESTÁ A MUDANÇA!
                  onPressed: () {
                    // O Navigator é o gerente de rotas do Flutter.
                    // 'push' "empurra" uma nova tela para cima da tela atual.
                    Navigator.of(context).push(
                      // MaterialPageRoute cria uma transição de tela padrão.
                      MaterialPageRoute(
                        // O builder constrói a tela que queremos mostrar.
                        builder: (context) => const ForgotPasswordScreen(),
                      ),
                    );
                  },
                  child: const Text('Esqueci minha senha'),
                ),
              ),
              const SizedBox(height: 24),

              // --- 5. Botão de Entrar ---
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
                  // Lógica de login virá aqui no futuro
                },
                child: const Text(
                  'ENTRAR',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 32),

              // --- 6. Link para Cadastro ---
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Não tem uma conta?'),
                  TextButton(
                    // AQUI ESTÁ A OUTRA MUDANÇA!
                    onPressed: () {
                      // Usamos a mesma lógica do Navigator para ir para a tela de cadastro.
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const SignupScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Cadastre-se',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}