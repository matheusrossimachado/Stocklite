import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
// 1. IMPORTANDO AS FERRAMENTAS NECESSÁRIAS
import 'package:provider/provider.dart';
import 'package:stocklite_app/modules/auth/views/login_screen.dart';
import 'package:stocklite_app/modules/home/controllers/product_controller.dart'; // Nosso novo cérebro!

void main() {
  runApp(
    // 2. DISPONIBILIZANDO O CONTROLLER PARA O APP
    // ChangeNotifierProvider cria uma instância do nosso controller e a "fornece"
    // para todos os widgets filhos (ou seja, nosso app inteiro).
    ChangeNotifierProvider(
      // O 'create' é responsável por construir o nosso controller pela primeira vez.
      create: (context) => ProductController(),
      // O DevicePreview agora é filho do Provider.
      child: DevicePreview(
        enabled: !kReleaseMode,
        builder: (context) => const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      title: 'Stocklite',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // A tela inicial continua sendo a de login.
      home: const LoginScreen(),
    );
  }
}