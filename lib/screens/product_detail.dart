import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../widgets/left_drawer.dart';

class ProductDetailPage extends StatefulWidget {
  final int productId;

  const ProductDetailPage({super.key, required this.productId});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  Future<Product> fetchProductDetail(BuildContext context) async {
    final request = Provider.of<CookieRequest>(context, listen: false);

    final response = await request.get(
      "https://rivaldy-putra-footballshop.pbp.cs.ui.ac.id/api/flutter/products/${widget.productId}/",
    );

    final data = response as Map<String, dynamic>;
    return Product.fromJson(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Produk"),
        centerTitle: true,
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder<Product>(
        future: fetchProductDetail(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text("Gagal memuat detail produk."),
            );
          }

          final product = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (product.thumbnailUrl != null &&
                    product.thumbnailUrl!.isNotEmpty)
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        product.thumbnailUrl!,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                else
                  const Center(
                    child: Icon(
                      Icons.sports_soccer,
                      size: 120,
                    ),
                  ),
                const SizedBox(height: 24),
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text("Kategori: ${product.category}"),
                const SizedBox(height: 4),
                Text(
                  "Harga: Rp ${product.price}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                if (product.isFeatured)
                  const Chip(
                    label: Text("Featured"),
                    avatar: Icon(Icons.star),
                  ),
                const SizedBox(height: 16),
                const Text(
                  "Deskripsi",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(product.description),
              ],
            ),
          );
        },
      ),
    );
  }
}
