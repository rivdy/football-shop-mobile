import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import '../widgets/left_drawer.dart';

const String baseUrl = "http://127.0.0.1:8000";

class AddProductFormPage extends StatefulWidget {
  static const String routeName = '/add-product';

  const AddProductFormPage({super.key});

  @override
  State<AddProductFormPage> createState() => _AddProductFormPageState();
}

class _AddProductFormPageState extends State<AddProductFormPage> {
  final _formKey = GlobalKey<FormState>();

  String name = '';
  String description = '';
  String category = '';
  String? thumbnailUrl;
  int price = 0;

  @override
  Widget build(BuildContext context) {
    final request = Provider.of<CookieRequest>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Produk'),
        centerTitle: true,
      ),
      drawer: const LeftDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Nama Produk',
                ),
                onSaved: (value) => name = value ?? '',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama produk wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Harga (IDR)',
                ),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  price = int.tryParse(value ?? '0') ?? 0;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harga wajib diisi';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Harga harus berupa angka';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                ),
                onSaved: (value) => category = value ?? '',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Kategori wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Thumbnail URL (opsional)',
                ),
                onSaved: (value) => thumbnailUrl = value,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Deskripsi',
                ),
                maxLines: 3,
                onSaved: (value) => description = value ?? '',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Deskripsi wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;

                  _formKey.currentState!.save();
                  final messenger = ScaffoldMessenger.of(context);
                  final navigator = Navigator.of(context);

                  final response = await request.post(
                    "$baseUrl/ajax/products/create/",
                    {
                      "name": name,
                      "price": price.toString(),
                      "description": description,
                      "category": category,
                      "thumbnail": thumbnailUrl ?? "",
                    },
                  );

                  if (!context.mounted) return;

                  if (response["ok"] == true || response["status"] == true) {
                    messenger.showSnackBar(
                      const SnackBar(
                        content: Text('Produk berhasil ditambahkan.'),
                      ),
                    );
                    navigator.pop();
                  } else {
                    messenger.showSnackBar(
                      SnackBar(
                        content: Text(
                          (response["message"] ??
                                  response["errors"]?.toString() ??
                                  "Gagal menambah produk.")
                              .toString(),
                        ),
                      ),
                    );
                  }
                },
                child: const Text('Simpan Produk'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
