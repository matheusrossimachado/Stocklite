import 'package:flutter/material.dart';

// MUDANÇA: Convertido para StatefulWidget para poder gerenciar o estado dos "olhos".
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // NOVO: Duas variáveis, uma para cada campo de senha, para controle independente.
  bool _isPasswordObscured = true;
  bool _isConfirmPasswordObscured = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ... (título e campos de nome/email não mudam)
            const Text('Crie sua Conta', textAlign: TextAlign.center, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('É rápido e fácil!', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 48),
            TextFormField(
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Nome completo',
                prefixIcon: Icon(Icons.person_outline),
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'E-mail',
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
            ),
            const SizedBox(height: 16),

            // --- CAMPO DE SENHA COM O "OLHO" ---
            TextFormField(
              textInputAction: TextInputAction.next,
              obscureText: _isPasswordObscured, // Usa a primeira variável
              decoration: InputDecoration(
                labelText: 'Senha',
                prefixIcon: const Icon(Icons.lock_outline),
                border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                suffixIcon: IconButton(
                  icon: Icon(_isPasswordObscured ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _isPasswordObscured = !_isPasswordObscured;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            // --- CAMPO DE CONFIRMAR SENHA COM O "OLHO" ---
            TextFormField(
              obscureText: _isConfirmPasswordObscured, // Usa a segunda variável
              decoration: InputDecoration(
                labelText: 'Confirmar Senha',
                prefixIcon: const Icon(Icons.lock_person_outlined),
                border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                suffixIcon: IconButton(
                  icon: Icon(_isConfirmPasswordObscured ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _isConfirmPasswordObscured = !_isConfirmPasswordObscured;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 32),

            // ... (botão de cadastrar e link para login não mudam)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {},
              child: const Text('CADASTRAR', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Já tem uma conta?'),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Faça login', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}