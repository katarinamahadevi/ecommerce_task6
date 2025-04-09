import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../services/storage_service.dart';
import '../models/order_model.dart';

class OrderService {
  static const String baseUrl = "https://tokopaedi.arfani.my.id/api";
  static final Dio _dio =
      Dio()
        ..interceptors.add(
          PrettyDioLogger(
            requestHeader: true,
            requestBody: true,
            responseHeader: true,
            responseBody: true,
            compact: true,
            maxWidth: 90,
          ),
        );

  static Future<Order> createOrder(
    int totalPrice,
    List<Map<String, dynamic>> items,
  ) async {
    String? token = await StorageService.getToken();
    print("Token: $token");

    if (token == null) {
      throw Exception("Authentication token is not available");
    }

    try {
      final response = await _dio.post(
        '$baseUrl/orders',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
        data: {'total_price': totalPrice, 'items': items},
      );

      print('Order response: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Order.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to create order: ${response.data}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Order creation failed: ${e.response?.data}');
      } else {
        throw Exception('Network error occurred: ${e.message}');
      }
    }
  }

  static Future<List<Order>> fetchOrders() async {
    String? token = await StorageService.getToken();

    if (token == null) throw Exception("Authentication token is not available");
    final response = await _dio.get(
      '$baseUrl/orders',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );
    if (response.statusCode == 200) {
      print("Response full: ${response.data}");

      List<dynamic> data = response.data['data']['data'];
      return data.map((json) => Order.fromJson(json)).toList();
    }
    return [];
  }

  static Future<Order> fetchOrderDetail(int id) async {
    String? token = await StorageService.getToken();

    if (token == null) {
      throw Exception("Authentication token is not available");
    }

    try {
      final response = await _dio.get(
        '$baseUrl/orders/$id',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        print("Response data: ${response.data}");

        final data = response.data['data'];
        if (data != null && data is Map<String, dynamic>) {
          return Order.fromJson(data);
        } else {
          throw Exception('Order detail is null or invalid format.');
        }
      } else {
        print("Full response data: ${response.data}");

        throw Exception('Failed to fetch order detail');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print("Dio error: ${e.response?.data}");
        throw Exception('Failed to fetch order detail: ${e.response?.data}');
      } else {
        print("Network error: ${e.message}");
        throw Exception('Network error occurred: ${e.message}');
      }
    }
  }
}
