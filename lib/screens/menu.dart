import 'package:flutter/material.dart';
import '../widgets/item_card.dart';
import '../widgets/left_drawer.dart';
import 'add_product_form.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      {
        'title': 'See Products',
        'icon': Icons.list_alt_outlined,
        'onTap': () {
          // TODO: arahkan ke halaman list produk jika sudah ada
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Coming soon: Product List')),
          );
        },
      },
      {
        'title': 'Tambah Produk',
        'icon': Icons.add_box_outlined,
        'onTap': () {
          Navigator.pushNamed(context, AddProductFormPage.routeName);
        },
      },
      {
        'title': 'Logout',
        'icon': Icons.logout,
        'onTap': () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Logged out (dummy)')),
          );
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
              .map((e) => ItemCard(
                    title: e['title'] as String,
                    icon: e['icon'] as IconData,
                    onTap: e['onTap'] as VoidCallback,
                  ))
              .toList(),
        ),
      ),
    );
  }
}
