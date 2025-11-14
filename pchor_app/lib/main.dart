import 'package:flutter/material.dart';
import 'package:pchor_app/screens/main_screen.dart'; //Ekran główny

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PChOR App',
      theme: ThemeData(
        // Motyw z fioletowym akcentem
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Ustawiamy nasz główny ekran startowy
      home: const MainScreen(),
    );
  }
}
