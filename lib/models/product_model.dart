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
  final CategoryModel? category;

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
    category:
        json["category"] != null
            ? CategoryModel.fromJson(json["category"])
            : null,
  );
}
