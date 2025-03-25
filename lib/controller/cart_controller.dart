import 'package:get/get.dart';
import '../models/cart_model.dart';
import '../models/product_model.dart';
import '../services/cart_service.dart';
import 'auth_controller.dart';

class CartController extends GetxController {
  final CartService _cartService = Get.put(CartService());
  final AuthController _authController = Get.find<AuthController>();

  final RxList<CartModel> _cartItems = <CartModel>[].obs;
  List<CartModel> get cartItems => _cartItems;

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final RxDouble _totalPrice = 0.0.obs;
  double get totalPrice => _totalPrice.value;

  @override
  void onInit() {
    super.onInit();
    fetchCartItems();
  }

  Future<void> fetchCartItems() async {
    if (_authController.user == null) return;

    _isLoading.value = true;
    try {
      final cartItems = await _cartService.fetchCartItems(_authController.user!.id);
      _cartItems.value = cartItems;
      _calculateTotalPrice();
    } catch (e) {
      print('Error fetching cart items: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> addToCart(ProductModel product, {int quantity = 1}) async {
    if (_authController.user == null) return;

    _isLoading.value = true;
    try {
      final cartItem = await _cartService.addToCart(_authController.user!.id, product, quantity);
      if (cartItem != null) {
        _cartItems.add(cartItem);
        _calculateTotalPrice();
      }
    } catch (e) {
      print('Error adding to cart: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> removeFromCart(CartModel cartItem) async {
    _isLoading.value = true;
    try {
      final success = await _cartService.removeFromCart(cartItem.id);
      if (success) {
        _cartItems.remove(cartItem);
        _calculateTotalPrice();
      }
    } catch (e) {
      print('Error removing from cart: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> updateCartItemQuantity(CartModel cartItem, int newQuantity) async {
    _isLoading.value = true;
    try {
      final updatedCartItem = await _cartService.updateCartItemQuantity(cartItem.id, newQuantity);
      if (updatedCartItem != null) {
        final index = _cartItems.indexWhere((item) => item.id == cartItem.id);
        if (index != -1) {
          _cartItems[index] = updatedCartItem;
          _calculateTotalPrice();
        }
      }
    } catch (e) {
      print('Error updating cart item quantity: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  void _calculateTotalPrice() {
    _totalPrice.value = _cartItems.fold(0.0, (total, cartItem) {
      return total + (cartItem.product.price * cartItem.quantity);
    });
  }
}