import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:stocklite_app/modules/auth/controllers/signup_controller.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _controller = SignupController();
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
            // CORREÇÃO DO ERRO DE DIGITAÇÃO AQUI
            const Text(
              'Crie sua Conta',
              textAlign: TextAlign.center, // Apenas um 'textAlign'
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 48),

            TextFormField(
              controller: _controller.nameController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Nome completo',
                prefixIcon: Icon(Icons.person_outline),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
            ),
            const SizedBox(height: 16),

            // --- VERSÃO CORRIGIDA E FUNCIONAL DO CAMPO DE TELEFONE ---
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).colorScheme.outline, width: 1.0),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: InternationalPhoneNumberInput(
                onInputChanged: (PhoneNumber number) {
                  _controller.fullPhoneNumber = number.phoneNumber ?? '';
                },
                
                // Configuração da aparência do seletor (bandeira e código)
                selectorConfig: const SelectorConfig(
                  selectorType: PhoneInputSelectorType.DIALOG,
                  trailingSpace: false, // Remove o espaço extra à direita da bandeira
                ),

                // Decoração do campo de texto interno
                inputDecoration: const InputDecoration(
                  hintText: 'Telefone',
                  // CRÍTICO: Remove a borda de dentro para não ter duas bordas
                  border: InputBorder.none, 
                ),
                
                // CRÍTICO: Remove a borda padrão do widget em si
                inputBorder: InputBorder.none, 

                initialValue: PhoneNumber(isoCode: 'BR'),
                formatInput: true,
                keyboardType: const TextInputType.numberWithOptions(
                    signed: true, decimal: true),
              ),
            ),
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _controller.emailController,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'E-mail',
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _controller.passwordController,
              obscureText: _isPasswordObscured,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: 'Senha',
                prefixIcon: const Icon(Icons.lock_outline),
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                suffixIcon: IconButton(
                  icon: Icon(_isPasswordObscured
                      ? Icons.visibility_off
                      : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _isPasswordObscured = !_isPasswordObscured;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _controller.confirmPasswordController,
              obscureText: _isConfirmPasswordObscured,
              decoration: InputDecoration(
                labelText: 'Confirmar Senha',
                prefixIcon: const Icon(Icons.lock_person_outlined),
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                suffixIcon: IconButton(
                  icon: Icon(_isConfirmPasswordObscured
                      ? Icons.visibility_off
                      : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _isConfirmPasswordObscured = !_isConfirmPasswordObscured;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                final String? errorMessage = _controller.signup();
                if (errorMessage != null) {
                  final snackBar = SnackBar(
                      content: Text(errorMessage), backgroundColor: Colors.red);
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else {
                  final snackBar = SnackBar(
                      content: const Text('Conta criada com sucesso!'),
                      backgroundColor: Colors.green);
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('CADASTRAR',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                  child: const Text('Faça login',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}