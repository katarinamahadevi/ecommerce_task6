import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../models/cart_model.dart';
import '../models/product_model.dart';

class CartService extends GetxService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://tokopaedi.arfani.my.id/api/',
    connectTimeout: Duration(seconds: 10),
    receiveTimeout: Duration(seconds: 10),
  ));

  Future<List<CartModel>> fetchCartItems(int userId) async {
    try {
      final response = await _dio.get('cart/$userId');

      if (response.statusCode == 200) {
        final List<dynamic> cartList = response.data['data'];
        return cartList.map((json) => CartModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('Fetch cart items error: $e');
      return [];
    }
  }

  Future<CartModel?> addToCart(int userId, ProductModel product, int quantity) async {
    try {
      final response = await _dio.post('cart', data: {
        'user_id': userId,
        'product_id': product.id,
        'quantity': quantity,
      });

      if (response.statusCode == 200) {
        return CartModel.fromJson(response.data['data']);
      }
      return null;
    } catch (e) {
      print('Add to cart error: $e');
      return null;
    }
  }

  Future<bool> removeFromCart(int cartItemId) async {
    try {
      final response = await _dio.delete('cart/$cartItemId');
      return response.statusCode == 200;
    } catch (e) {
      print('Remove from cart error: $e');
      return false;
    }
  }

  Future<CartModel?> updateCartItemQuantity(int cartItemId, int quantity) async {
    try {
      final response = await _dio.put('cart/$cartItemId', data: {
        'quantity': quantity,
      });

      if (response.statusCode == 200) {
        return CartModel.fromJson(response.data['data']);
      }
      return null;
    } catch (e) {
      print('Update cart item quantity error: $e');
      return null;
    }
  }
}