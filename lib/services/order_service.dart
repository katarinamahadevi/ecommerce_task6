import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../services/storage_service.dart';
import '../models/order_model.dart';

class OrderService {
  static const String baseUrl = "https://tokopaedi.arfani.my.id/api";
  static final Dio _dio = Dio()
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

  static Future<Map<String, dynamic>> fetchOrders([int page = 1]) async {
    String? token = await StorageService.getToken();
    if (token == null) throw Exception("Authentication token is not available");

    try {
      print("Fetching orders for page $page");
      
      final response = await _dio.get(
        '$baseUrl/orders',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
        queryParameters: {
          'page': page,
        },
      );

      if (response.statusCode == 200) {
        print("Response keys: ${response.data.keys}");
        
        // Simpan raw response untuk debugging
        print("Raw response data: ${response.data}");
        
        List<Order> orders = [];
        Map<String, dynamic> meta = {
          'current_page': page,
          'last_page': page,
          'total': 0,
        };
        
        // Cek apakah API mendukung pagination
        bool isLegacyFormat = false;
        
        if (response.data['data'] is Map && response.data['data'].containsKey('data')) {
          // Format API dengan pagination (data dalam data)
          final nestedData = response.data['data'];
          print("Nested data structure detected: ${nestedData.keys}");
          
          if (nestedData['data'] is List) {
            final List<dynamic> dataList = nestedData['data'];
            orders = dataList.map((json) => Order.fromJson(json)).toList();
            
            // Ambil metadata pagination
            if (nestedData.containsKey('meta')) {
              meta = nestedData['meta'];
            } else {
              meta = {
                'current_page': nestedData['current_page'] ?? page,
                'last_page': nestedData['last_page'] ?? page,
                'total': nestedData['total'] ?? 0,
                'per_page': nestedData['per_page'] ?? 10,
              };
            }
          }
        } else if (response.data['data'] is List) {
          // Format API lama tanpa pagination
          isLegacyFormat = true;
          final List<dynamic> dataList = response.data['data'];
          orders = dataList.map((json) => Order.fromJson(json)).toList();
          
          // Untuk API tanpa pagination, kita anggap hanya satu halaman
          meta = {
            'current_page': 1,
            'last_page': 1,
            'total': dataList.length,
          };
        }
        
        print("Parsed orders: ${orders.length}, Meta: $meta, Legacy format: $isLegacyFormat");
        
        return {
          'orders': orders,
          'meta': meta,
          'isLegacyFormat': isLegacyFormat,
        };
      }
      
      print("HTTP error: ${response.statusCode}");
      return {
        'orders': <Order>[],
        'meta': {
          'current_page': page,
          'last_page': page,
          'total': 0,
        },
        'isLegacyFormat': true,
      };
    } catch (e) {
      print("Error fetching orders: $e");
      rethrow;
    }
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