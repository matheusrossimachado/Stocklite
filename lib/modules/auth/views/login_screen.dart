import 'package:flutter/material.dart';
import 'package:stocklite_app/modules/auth/controllers/login_controller.dart';
import 'package:stocklite_app/modules/auth/views/forgot_password_screen.dart';
import 'package:stocklite_app/modules/auth/views/signup_screen.dart';
import 'package:stocklite_app/modules/home/views/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _controller = LoginController();

  // NOVO: Uma variável de estado para controlar a visibilidade da senha.
  // Começa como 'true' porque a senha deve iniciar escondida.
  bool _isPasswordObscured = true;

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
              // ... (ícone e título não mudam)
              const Icon(Icons.inventory_2_outlined, size: 80, color: Colors.deepPurple),
              const SizedBox(height: 48),

              // Campo de E-mail (não muda)
              TextFormField(
                controller: _controller.emailController,
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

              // --- CAMPO DE SENHA COM A MUDANÇA ---
              TextFormField(
                controller: _controller.passwordController,
                // MUDANÇA: 'obscureText' agora depende da nossa variável de estado.
                obscureText: _isPasswordObscured,
                decoration: InputDecoration( // Removido o 'const' para poder usar variáveis
                  labelText: 'Senha',
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  // NOVO: O ícone no final do campo (o "olho").
                  suffixIcon: IconButton(
                    // O ícone muda dependendo se a senha está visível ou não.
                    icon: Icon(
                      _isPasswordObscured ? Icons.visibility_off : Icons.visibility,
                    ),
                    // A ação que acontece ao clicar no ícone.
                    onPressed: () {
                      // setState é o comando que avisa o Flutter: "Ei, uma variável de estado
                      // mudou, por favor, redesenhe a tela para mostrar a mudança!"
                      setState(() {
                        // Invertemos o valor da variável (true vira false, false vira true).
                        _isPasswordObscured = !_isPasswordObscured;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // ... (resto do código da tela não muda)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ForgotPasswordScreen(),
                    ));
                  },
                  child: const Text('Esqueci minha senha'),
                ),
              ),
              const SizedBox(height: 24),
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
                  final bool loginSuccess = _controller.login();
                  if (loginSuccess) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                    );
                  } else {
                    final snackBar = SnackBar(
                      content: const Text('E-mail ou senha inválidos.'),
                      backgroundColor: Colors.red,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                child: const Text(
                  'ENTRAR',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Não tem uma conta?'),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SignupScreen(),
                      ));
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