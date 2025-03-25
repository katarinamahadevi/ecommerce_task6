import 'package:get/get.dart';
import '../models/order_model.dart';
import '../services/order_service.dart';
import 'auth_controller.dart';
import 'cart_controller.dart';

class OrderController extends GetxController {
  final OrderService _orderService = Get.put(OrderService());
  final AuthController _authController = Get.find<AuthController>();
  final CartController _cartController = Get.find<CartController>();

  final RxList<Order> _orders = <Order>[].obs;
  List<Order> get orders => _orders;

  final Rx<Order?> _currentOrder = Rx<Order?>(null);
  Order? get currentOrder => _currentOrder.value;

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    fetchUserOrders();
  }

  Future<void> fetchUserOrders() async {
    if (_authController.user == null) return;

    _isLoading.value = true;
    try {
      final userOrders = await _orderService.fetchUserOrders(_authController.user!.id);
      _orders.value = userOrders;
    } catch (e) {
      print('Error fetching user orders: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<Order?> createOrder() async {
    if (_authController.user == null || _cartController.cartItems.isEmpty) return null;

    _isLoading.value = true;
    try {
      final order = await _orderService.createOrder(
        _authController.user!.id, 
        _cartController.cartItems
      );

      if (order != null) {
        _currentOrder.value = order;
        _orders.add(order);
        _cartController.cartItems.clear(); // Clear cart after order creation
        return order;
      }
      return null;
    } catch (e) {
      print('Error creating order: $e');
      return null;
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> getOrderDetails(int orderId) async {
    _isLoading.value = true;
    try {
      final orderDetails = await _orderService.getOrderDetails(orderId);
      _currentOrder.value = orderDetails;
    } catch (e) {
      print('Error getting order details: $e');
    } finally {
      _isLoading.value = false;
    }
  }
}