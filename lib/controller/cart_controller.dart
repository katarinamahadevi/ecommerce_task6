import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/cart_model.dart';
import '../models/product_model.dart';
import '../services/cart_service.dart';
import 'auth_controller.dart';

class CartController extends GetxController {
  final CartService _cartService = Get.put(CartService());
  final AuthController _authController = Get.find<AuthController>();

  var cartItems = <CartModel>[].obs;
  var isLoading = false.obs;
  var totalPrice = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCartItems();
  }

  // Fetch cart items from API
  Future<void> fetchCartItems() async {
    if (_authController.user == null) return;

    isLoading(true);
    try {
      final cartData = await CartService.fetchCartItems(
        _authController.user!.id,
      );
      cartItems.value = cartData;
      _calculateTotalPrice();
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch cart items: $e");
    } finally {
      isLoading(false);
    }
  }

  // Add product to cart
  Future<void> addToCart(ProductModel product, {int quantity = 1}) async {
    if (_authController.user == null) {
      Get.snackbar('Error', 'Please login to add items to cart');
      return;
    }

    isLoading(true);
    try {
      bool success = await CartService.addToCart(product, quantity);
      if (success) {
        // Karena API tidak mengembalikan detail cart, kita perlu men-trigger fetch ulang
        await fetchCartItems();
        Get.snackbar("Success", "${product.name} added to cart");
      } else {
        Get.snackbar("Error", "Failed to add product to cart");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to add product: $e");
    } finally {
      isLoading(false);
    }
  }

  // Remove product from cart
  Future<void> removeFromCart(CartModel cartItem) async {
    isLoading(true);
    try {
      bool success = await CartService.removeFromCart(cartItem.id);
      if (success) {
        cartItems.remove(cartItem);
        _calculateTotalPrice();
        Get.snackbar("Success", "Item removed from cart");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to remove item: $e");
    } finally {
      isLoading(false);
    }
  }

  void increaseQuantity(CartModel cartItem) {
    int index = cartItems.indexWhere((item) => item.id == cartItem.id);

    if (index != -1) {
      cartItems[index] = CartModel(
        id: cartItem.id,
        product: cartItem.product,
        productId: cartItem.productId,
        userId: cartItem.userId,
        quantity: cartItem.quantity + 1, // Tambah quantity
        createdAt: cartItem.createdAt,
        updatedAt: DateTime.now(), // Update waktu terakhir diperbarui
      );

      cartItems.refresh(); // Refresh GetX untuk update UI
      _calculateTotalPrice();
    }
  }

  void decreaseQuantity(CartModel cartItem) {
    int index = cartItems.indexWhere((item) => item.id == cartItem.id);

    if (index != -1) {
      if (cartItem.quantity > 1) {
        cartItems[index] = CartModel(
          id: cartItem.id,
          product: cartItem.product,
          productId: cartItem.productId,
          userId: cartItem.userId,
          quantity: cartItem.quantity - 1, // Kurangi quantity
          createdAt: cartItem.createdAt,
          updatedAt: DateTime.now(),
        );

        cartItems.refresh();
        _calculateTotalPrice();
      } else {
        removeFromCart(cartItem);
      }
    }
  }
  void _calculateTotalPrice() {
    totalPrice.value = cartItems.fold(
      0.0,
      (sum, item) => sum + (item.product.price * item.quantity),
    );
  }
}
