import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import 'screens/menu.dart';
import 'screens/add_product_form.dart';
import 'screens/login.dart';
import 'screens/register.dart';

void main() {
  runApp(
    Provider(
      create: (_) => CookieRequest(),
      child: const FootballShopApp(),
    ),
  );
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
          seedColor: const Color(0xFF005F73),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      home: const LoginPage(),
      routes: {
        AddProductFormPage.routeName: (_) => const AddProductFormPage(),
        '/menu': (_) => const MenuPage(),
        '/register': (_) => const RegisterPage(),
      },
    );
  }
}
