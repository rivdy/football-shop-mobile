import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import '../widgets/item_card.dart';
import '../widgets/left_drawer.dart';
import 'add_product_form.dart';
import 'login.dart';
import 'product_list.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final request = Provider.of<CookieRequest>(context);

    final items = [
      {
        'title': 'See Products',
        'icon': Icons.list_alt_outlined,
        'color': Colors.blue, // biru
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ProductListPage(),
            ),
          );
        },
      },
      {
        'title': 'Tambah Produk',
        'icon': Icons.add_box_outlined,
        'color': Colors.green, // hijau
        'onTap': () {
          Navigator.pushNamed(context, AddProductFormPage.routeName);
        },
      },
      {
        'title': 'Logout',
        'icon': Icons.logout,
        'color': Colors.red, // merah
        'onTap': () async {
          final response = await request.logout(
            "https://rivaldy-putra-footballshop.pbp.cs.ui.ac.id/auth/logout/",
          );

          if (response["status"] == true || request.loggedIn == false) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginPage()),
              (route) => false,
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Logout gagal.")),
            );
          }
        },
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Football Shop'),
        centerTitle: true,
      ),
      drawer: const LeftDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: items
              .map(
                (e) => ItemCard(
                  title: e['title'] as String,
                  icon: e['icon'] as IconData,
                  onTap: e['onTap'] as VoidCallback,
                  backgroundColor: e['color'] as Color,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
