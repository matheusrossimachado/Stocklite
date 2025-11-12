import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:provider/provider.dart';
import 'package:stocklite_app/modules/auth/views/login_screen.dart';
import 'package:stocklite_app/modules/home/controllers/product_controller.dart';

// 1. IMPORTANDO O FIREBASE CORE E O NOSSO ARQUIVO DE OPÇÕES
import 'package:firebase_core/firebase_core.dart';
// Atenção aqui! Verifique se o nome do seu projeto é 'stocklite_app'
// Se o seu pubspec.yaml tiver 'name: stocklite', mude a linha abaixo:
import 'package:stocklite_app/firebase_options.dart'; 

// 2. TORNANDO O MÉTODO 'main' ASSÍNCRONO
void main() async {
  // 3. GARANTINDO QUE O FLUTTER ESTÁ PRONTO
  WidgetsFlutterBinding.ensureInitialized();

  // 4. INICIALIZANDO O FIREBASE
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 5. O RESTO DO NOSSO CÓDIGO
  runApp(
    ChangeNotifierProvider(
      create: (context) => ProductController(),
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
      home: const LoginScreen(),
    );
  }
}