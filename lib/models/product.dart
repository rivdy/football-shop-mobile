class Product {
  final String name;
  final int price; // integer (IDR) sesuai ketentuan tipe data
  final String description;
  final String? thumbnailUrl; // opsional, harus URL valid jika diisi
  final String category;
  final bool isFeatured;

  Product({
    required this.name,
    required this.price,
    required this.description,
    required this.category,
    this.thumbnailUrl,
    this.isFeatured = false,
  });
}
