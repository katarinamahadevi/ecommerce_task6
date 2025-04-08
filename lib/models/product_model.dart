import 'package:ecommerce_task6/models/category_model.dart';

class ProductModel {
  final int id;
  final String image;
  final String name;
  final int price;
  final String description;
  final int categoryId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String rupiah;
  final CategoryModel category;

  ProductModel({
    required this.id,
    required this.image,
    required this.name,
    required this.price,
    required this.description,
    required this.categoryId,
    required this.createdAt,
    required this.updatedAt,
    required this.rupiah,
    required this.category,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    id: json["id"],
    image: json["image"],
    name: json["name"],
    price: json["price"],
    description: json["description"],
    categoryId: json["category_id"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    rupiah: json["rupiah"],
    category: CategoryModel.fromJson(json["category"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "image": image,
    "name": name,
    "price": price,
    "description": description,
    "category_id": categoryId,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "rupiah": rupiah,
    "category": category.toJson(),
  };
}
