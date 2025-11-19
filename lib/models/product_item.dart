import 'dart:convert';

List<ProductItem> productItemFromJson(String str) =>
    List<ProductItem>.from(
      json.decode(str).map((x) => ProductItem.fromJson(x)),
    );

String productItemToJson(List<ProductItem> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductItem {
  String model;
  int pk;
  Fields fields;

  ProductItem({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory ProductItem.fromJson(Map<String, dynamic> json) => ProductItem(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
      );

  Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
      };
}

class Fields {
  int user;
  int updatedBy;
  String name;
  int price;
  String description;
  String thumbnail;
  String category;
  bool isFeatured;
  DateTime createdAt;
  DateTime updatedAt;
  int stock;
  String brand;

  Fields({
    required this.user,
    required this.updatedBy,
    required this.name,
    required this.price,
    required this.description,
    required this.thumbnail,
    required this.category,
    required this.isFeatured,
    required this.createdAt,
    required this.updatedAt,
    required this.stock,
    required this.brand,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        updatedBy: json["updated_by"],
        name: json["name"],
        price: json["price"],
        description: json["description"],
        thumbnail: json["thumbnail"],
        category: json["category"],
        isFeatured: json["is_featured"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        stock: json["stock"],
        brand: json["brand"],
      );

  Map<String, dynamic> toJson() => {
        "user": user,
        "updated_by": updatedBy,
        "name": name,
        "price": price,
        "description": description,
        "thumbnail": thumbnail,
        "category": category,
        "is_featured": isFeatured,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "stock": stock,
        "brand": brand,
      };
}
