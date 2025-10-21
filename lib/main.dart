import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mensajería segura',
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF4461F2),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}