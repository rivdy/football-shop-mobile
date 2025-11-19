import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String username = "";
  String password1 = "";
  String password2 = "";

  @override
  Widget build(BuildContext context) {
    final request = Provider.of<CookieRequest>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
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
              onChanged: (value) => password1 = value,
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(labelText: "Confirm Password"),
              obscureText: true,
              onChanged: (value) => password2 = value,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                final messenger = ScaffoldMessenger.of(context);
                final navigator = Navigator.of(context);

                final response = await request.post(
                  "$baseUrl/auth/register/",
                  {
                    "username": username,
                    "password1": password1,
                    "password2": password2,
                  },
                );

                if (!context.mounted) return;

                if (response["status"] == true) {
                  messenger.showSnackBar(
                    const SnackBar(
                      content: Text("Akun berhasil dibuat, silakan login."),
                    ),
                  );
                  navigator.pop();
                } else {
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text(
                        (response["message"] ?? "Gagal register.").toString(),
                      ),
                    ),
                  );
                }
              },
              child: const Text("Register"),
            ),
          ],
        ),
      ),
    );
  }
}
