import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/product.dart';
import '../widgets/left_drawer.dart';

class AddProductFormPage extends StatefulWidget {
  static const routeName = '/add-product';

  const AddProductFormPage({super.key});

  @override
  State<AddProductFormPage> createState() => _AddProductFormPageState();
}

class _AddProductFormPageState extends State<AddProductFormPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descController = TextEditingController();
  final _thumbController = TextEditingController();

  // Field states
  String? _selectedCategory;
  bool _isFeatured = false;

  // Contoh kategori: sesuaikan dengan model di Django-mu
  final List<String> _categories = [
    'Jersey',
    'Shoes',
    'Ball',
    'Accessories',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descController.dispose();
    _thumbController.dispose();
    super.dispose();
  }

  String? _validateName(String? v) {
    if (v == null || v.trim().isEmpty) return 'Name tidak boleh kosong';
    if (v.trim().length < 3) return 'Minimal 3 karakter';
    if (v.trim().length > 50) return 'Maksimal 50 karakter';
    return null;
  }

  String? _validatePrice(String? v) {
    if (v == null || v.isEmpty) return 'Price tidak boleh kosong';
    // sudah digitsOnly via inputFormatter, tapi kita cek lagi
    final value = int.tryParse(v);
    if (value == null) return 'Price harus berupa bilangan bulat';
    if (value <= 0) return 'Price harus bernilai positif';
    if (value > 1000000000) return 'Price terlalu besar';
    return null;
  }

  String? _validateDescription(String? v) {
    if (v == null || v.trim().isEmpty) return 'Description tidak boleh kosong';
    if (v.trim().length < 10) return 'Minimal 10 karakter';
    return null;
  }

  String? _validateCategory(String? v) {
    if (v == null || v.isEmpty) return 'Category wajib dipilih';
    return null;
  }

  String? _validateThumbnail(String? v) {
    if (v == null || v.trim().isEmpty) return null; // opsional
    final url = v.trim();
    final uri = Uri.tryParse(url);
    final isValid =
        uri != null && (uri.isScheme('http') || uri.isScheme('https')) && uri.host.isNotEmpty;
    if (!isValid) return 'Thumbnail harus berupa URL http(s) valid';
    // Panjang/batas minimum?
    if (url.length > 300) return 'URL terlalu panjang';
    return null;
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    _nameController.clear();
    _priceController.clear();
    _descController.clear();
    _thumbController.clear();
    setState(() {
      _selectedCategory = null;
      _isFeatured = false;
    });
  }

  void _onSave() {
    if (_formKey.currentState!.validate()) {
      final product = Product(
        name: _nameController.text.trim(),
        price: int.parse(_priceController.text.trim()),
        description: _descController.text.trim(),
        category: _selectedCategory!,
        thumbnailUrl: _thumbController.text.trim().isEmpty
            ? null
            : _thumbController.text.trim(),
        isFeatured: _isFeatured,
      );

      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Konfirmasi Data'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text('Name       : ${product.name}'),
                Text('Price      : ${product.price}'),
                Text('Category   : ${product.category}'),
                Text('Featured   : ${product.isFeatured ? "Yes" : "No"}'),
                Text('Thumbnail  : ${product.thumbnailUrl ?? "-"}'),
                const SizedBox(height: 8),
                const Text('Description:'),
                Text(product.description),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Tutup'),
            ),
          ],
        ),
      ).then((_) {
        _resetForm();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data produk tersimpan (dummy).')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Produk'),
        centerTitle: true,
      ),
      drawer: const LeftDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // NAME
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name *',
                    hintText: 'Contoh: Nike Tiempo Legend 10',
                  ),
                  textInputAction: TextInputAction.next,
                  validator: _validateName,
                ),
                const SizedBox(height: 12),

                // PRICE
                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(
                    labelText: 'Price (IDR) *',
                    hintText: 'Contoh: 499000',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  textInputAction: TextInputAction.next,
                  validator: _validatePrice,
                ),
                const SizedBox(height: 12),

                // CATEGORY
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Category *',
                  ),
                  value: _selectedCategory,
                  items: _categories
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedCategory = v),
                  validator: _validateCategory,
                ),
                const SizedBox(height: 12),

                // THUMBNAIL (opsional)
                TextFormField(
                  controller: _thumbController,
                  decoration: const InputDecoration(
                    labelText: 'Thumbnail URL (opsional)',
                    hintText: 'https://example.com/image.jpg',
                  ),
                  keyboardType: TextInputType.url,
                  textInputAction: TextInputAction.next,
                  validator: _validateThumbnail,
                ),
                const SizedBox(height: 12),

                // DESCRIPTION
                TextFormField(
                  controller: _descController,
                  decoration: const InputDecoration(
                    labelText: 'Description *',
                  ),
                  maxLines: 4,
                  validator: _validateDescription,
                ),
                const SizedBox(height: 8),

                // FEATURED
                SwitchListTile(
                  value: _isFeatured,
                  onChanged: (v) => setState(() => _isFeatured = v),
                  title: const Text('Feature this product'),
                  contentPadding: EdgeInsets.zero,
                ),
                const SizedBox(height: 16),

                // SAVE
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _onSave,
                    icon: const Icon(Icons.save_outlined),
                    label: const Text('Save'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
