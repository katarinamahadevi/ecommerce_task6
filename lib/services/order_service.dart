import 'package:dio/dio.dart';
import 'package:ecommerce_task6/models/order_model.dart';
import 'package:ecommerce_task6/services/storage_service.dart';

class OrderService {
  static const String baseUrl = "https://tokopaedi.arfani.my.id/api";
  static final Dio _dio = Dio();

  // Membuat order baru
  static Future<Order?> createOrder(List<Map<String, dynamic>> orderItems) async {
    String? token = await StorageService.getToken();
    if (token == null) throw Exception("Token tidak tersedia");

    try {
      final response = await _dio.post(
        "$baseUrl/orders",
        data: {"order_items": orderItems},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 201) {
        return Order.fromJson(response.data['data']);
      } else {
        throw Exception("Gagal membuat pesanan: ${response.data['message']}");
      }
    } catch (e) {
      throw Exception("Error saat membuat order: $e");
    }
  }

  // Mendapatkan detail order berdasarkan ID
  static Future<Order?> fetchOrderDetails(int orderId) async {
    String? token = await StorageService.getToken();
    if (token == null) throw Exception("Token tidak tersedia");

    try {
      final response = await _dio.get(
        "$baseUrl/orders/$orderId",
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        return Order.fromJson(response.data['data']);
      } else {
        throw Exception("Gagal mengambil detail order");
      }
    } catch (e) {
      throw Exception("Error saat mengambil order: $e");
    }
  }
}
