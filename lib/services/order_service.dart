import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../models/order_model.dart';
import '../models/cart_model.dart';

class OrderService extends GetxService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://tokopaedi.arfani.my.id/api/',
    connectTimeout: Duration(seconds: 10),
    receiveTimeout: Duration(seconds: 10),
  ));

  Future<Order?> createOrder(int userId, List<CartModel> cartItems) async {
    try {
      final orderItems = cartItems.map((cartItem) => {
        'product_id': cartItem.productId,
        'quantity': cartItem.quantity,
        'price': cartItem.product.price,
      }).toList();

      final response = await _dio.post('orders', data: {
        'user_id': userId,
        'order_items': orderItems,
      });

      if (response.statusCode == 200) {
        return Order.fromJson(response.data['data']);
      }
      return null;
    } catch (e) {
      print('Create order error: $e');
      return null;
    }
  }

  Future<List<Order>> fetchUserOrders(int userId) async {
    try {
      final response = await _dio.get('orders/user/$userId');

      if (response.statusCode == 200) {
        final List<dynamic> orderList = response.data['data'];
        return orderList.map((json) => Order.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('Fetch user orders error: $e');
      return [];
    }
  }

  Future<Order?> getOrderDetails(int orderId) async {
    try {
      final response = await _dio.get('orders/$orderId');

      if (response.statusCode == 200) {
        return Order.fromJson(response.data['data']);
      }
      return null;
    } catch (e) {
      print('Get order details error: $e');
      return null;
    }
  }
}