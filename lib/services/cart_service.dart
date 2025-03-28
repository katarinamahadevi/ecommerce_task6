import 'package:dio/dio.dart';
import 'package:ecommerce_task6/services/storage_service.dart';
import 'package:get/get.dart';
import '../models/cart_model.dart';
import '../models/product_model.dart';

class CartService {
  static const String baseUrl = "https://tokopaedi.arfani.my.id/api";
  static final Dio _dio = Dio();
  final dio = Dio(BaseOptions(headers: {"Accept": "application/json"}));
  final StorageService _storageService = Get.put(StorageService());
  ProfileService() {
    Get.lazyPut(() => StorageService());
  }

  // Get all cart items
  static Future<List<CartModel>> fetchCartItems(int userId) async {
    String? token = await StorageService.getToken();
    try {
      final response = await _dio.get(
        "$baseUrl/carts",
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200) {
        List<dynamic> data = response.data['data'];
        return data.map((json) => CartModel.fromJson(json)).toList();
      } else {
        throw Exception("Failed to load cart items");
      }
    } catch (e) {
      throw Exception("Error fetching cart: $e");
    }
  }

  // Add product to cart
  static Future<bool> addToCart(ProductModel product, int quantity) async {
    String? token = await StorageService.getToken();
    if (token == null) throw Exception("Token tidak tersedia");

    try {
      final response = await _dio.post(
        "$baseUrl/carts",
        data: {"product_id": product.id, "quantity": quantity},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.data['message']); // Log pesan sukses
        return true; // Berhasil menambahkan ke cart
      } else {
        print("Failed to add to cart: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Error adding to cart: $e");
      return false; // Gagal menambahkan ke cart
    }
  }

  static Future<bool> removeFromCart(int cartId) async {
    String? token = await StorageService.getToken();

    try {
      final response = await _dio.post(
        "$baseUrl/carts/remove",
        data: {"cart_id": cartId},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception("Error removing from cart: $e");
    }
  }
}
