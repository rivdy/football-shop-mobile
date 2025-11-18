import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import 'menu.dart';
import 'register.dart';

const String baseUrl = "http://127.0.0.1:8000";

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String username = "";
  String password = "";
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final request = Provider.of<CookieRequest>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: "Username"),
              onChanged: (value) => username = value.trim(),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
              onChanged: (value) => password = value,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () async {
                      setState(() => _isLoading = true);

                      final messenger = ScaffoldMessenger.of(context);
                      final navigator = Navigator.of(context);

                      final response = await request.login(
                        "$baseUrl/auth/login/",
                        {
                          "username": username,
                          "password": password,
                        },
                      );

                      setState(() => _isLoading = false);

                      if (request.loggedIn) {
                        messenger.showSnackBar(
                          SnackBar(
                            content: Text(
                              (response["message"] ?? "Login successful!")
                                  .toString(),
                            ),
                          ),
                        );
                        navigator.pushReplacement(
                          MaterialPageRoute(
                            builder: (_) => const MenuPage(),
                          ),
                        );
                      } else {
                        messenger.showSnackBar(
                          SnackBar(
                            content: Text(
                              (response["message"] ??
                                      "Login gagal, cek username/password.")
                                  .toString(),
                            ),
                          ),
                        );
                      }
                    },
              child: Text(_isLoading ? "Loading..." : "Login"),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterPage()),
                );
              },
              child: const Text("Belum punya akun? Register di sini"),
            ),
          ],
        ),
      ),
    );
  }
}
