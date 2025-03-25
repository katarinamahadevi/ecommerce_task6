import 'package:ecommerce_task6/models/product_model.dart';

class CartModel {
    final int id;
    final int productId;
    final int userId;
    final int quantity;
    final DateTime createdAt;
    final DateTime updatedAt;
    final ProductModel product;

    CartModel({
        required this.id,
        required this.productId,
        required this.userId,
        required this.quantity,
        required this.createdAt,
        required this.updatedAt,
        required this.product,
    });

    factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
        id: json["id"],
        productId: json["product_id"],
        userId: json["user_id"],
        quantity: json["quantity"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        product: ProductModel.fromJson(json["product"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "product_id": productId,
        "user_id": userId,
        "quantity": quantity,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "product": product.toJson(),
    };
}