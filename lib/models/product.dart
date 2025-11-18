class Product {
  final int id;                
  final String name;
  final int price;
  final String description;
  final String category;
  final String? thumbnailUrl;  // opsional
  final bool isFeatured;
  final String? owner;         // opsional, dari Django

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.category,
    this.thumbnailUrl,
    this.isFeatured = false,
    this.owner,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json["id"],
      name: json["name"],
      price: json["price"],
      description: json["description"],
      category: json["category"],
      thumbnailUrl: json["thumbnail"],
      isFeatured: json["is_featured"] ?? false,
      owner: json["owner"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "price": price,
      "description": description,
      "category": category,
      "thumbnail": thumbnailUrl,
      "is_featured": isFeatured,
      "owner": owner,
    };
  }
}
