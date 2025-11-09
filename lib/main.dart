import 'package:flutter/material.dart';
import 'screens/menu.dart';
import 'screens/add_product_form.dart';

void main() {
  runApp(const FootballShopApp());
}

class FootballShopApp extends StatelessWidget {
  const FootballShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Football Shop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF005F73), // warna brand contoh
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      home: const MenuPage(),
      routes: {
        AddProductFormPage.routeName: (_) => const AddProductFormPage(),
      },
    );
  }
}
