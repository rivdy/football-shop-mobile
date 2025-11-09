import 'package:flutter/material.dart';
import '../screens/menu.dart';
import '../screens/add_product_form.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF005F73),
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Football Shop',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text('Halaman Utama'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const MenuPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.add_box_outlined),
              title: const Text('Tambah Produk'),
              onTap: () {
                Navigator.pushReplacementNamed(
                  context,
                  AddProductFormPage.routeName,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
