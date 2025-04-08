import 'package:ecommerce_task6/models/product_model.dart';

class OrderItem {
  final int id;
  final int orderId;
  final int productId;
  final int quantity;
  final int price;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ProductModel product;

  OrderItem({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.quantity,
    required this.price,
    required this.createdAt,
    required this.updatedAt,
    required this.product,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      orderId: json['order_id'],
      productId: json['product_id'],
      quantity: json['quantity'],
      price: json['price'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      product: ProductModel.fromJson(json['product']),
    );
  }
}
