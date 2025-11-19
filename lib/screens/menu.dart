import 'package:flutter/material.dart';
import '../widgets/item_card.dart';
import '../widgets/left_drawer.dart';
import 'add_product_form.dart';
import 'product_list.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      {
        'title': 'All Products',
        'icon': Icons.list_alt_outlined,
        'color': const Color(0xFF1E88E5),
        'onTap': () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Kamu telah menekan tombol All Products'),
            ),
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ProductListPage(),
            ),
          );
        },
      },
      {
        'title': 'My Products',
        'icon': Icons.person_outline,
        'color': const Color(0xFF43A047),
        'onTap': () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Kamu telah menekan tombol My Products'),
            ),
          );
          // kalau nanti mau filter "my", bisa diarahkan ke page khusus/filter
        },
      },
      {
        'title': 'Create Product',
        'icon': Icons.add_box_outlined,
        'color': const Color(0xFFE53935),
        'onTap': () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Kamu telah menekan tombol Create Product'),
            ),
          );
          Navigator.pushNamed(context, AddProductFormPage.routeName);
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
                  backgroundColor: e['color'] as Color,
                  onTap: e['onTap'] as VoidCallback,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
