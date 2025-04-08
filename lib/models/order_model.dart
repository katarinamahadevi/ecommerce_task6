import 'package:ecommerce_task6/models/order_item_model.dart';

class Order {
  final int id;
  final String code;
  final int userId;
  final int totalPrice;
  final String status;
  final String midtransPaymentType;
  final String midtransPaymentUrl;
  final String midtransSnapToken;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<OrderItem> orderItems;

  Order({
    required this.id,
    required this.code,
    required this.userId,
    required this.totalPrice,
    required this.status,
    required this.midtransPaymentType,
    required this.midtransPaymentUrl,
    required this.midtransSnapToken,
    required this.createdAt,
    required this.updatedAt,
    required this.orderItems,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      code: json['code'],
      userId: json['user_id'],
      totalPrice: json['total_price'],
      status: json['status'],
      midtransPaymentType: json['midtrans_payment_type'] ?? '',
      midtransPaymentUrl: json['midtrans_payment_url'] ?? '',
      midtransSnapToken: json['midtrans_snap_token'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      orderItems:
          (json['order_items'] as List?)
              ?.map((item) => OrderItem.fromJson(item))
              .toList() ??
          [],
    );
  }
}
