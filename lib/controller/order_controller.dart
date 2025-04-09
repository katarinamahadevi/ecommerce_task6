import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/cart_controller.dart';
import '../controller/auth_controller.dart';
import '../services/order_service.dart';
import '../models/order_model.dart';

class OrderController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();
  final CartController _cartController = Get.find<CartController>();

  var isLoading = false.obs;
  Rx<Order?> currentOrder = Rx<Order?>(null);

  var orderList = <Order>[].obs;
  Rx<Order?> selectedOrder = Rx<Order?>(null);

  var selectedOrderDetail = Rx<Order?>(null);
  var isOrderDetailLoading = false.obs;

  Future<void> createOrder() async {
    if (_cartController.cartItems.isEmpty) {
      Get.snackbar('Error', 'Your cart is empty');
      return;
    }

    isLoading(true);
    try {
      final items =
          _cartController.cartItems
              .map(
                (item) => {
                  'product_id': item.productId,
                  'quantity': item.quantity,
                },
              )
              .toList();

      final order = await OrderService.createOrder(
        _cartController.totalPrice.value.toInt(),
        items,
      );

      currentOrder.value = order;

      if (order.midtransPaymentUrl.isNotEmpty) {
        Future.delayed(Duration.zero, () {
          Get.toNamed('/checkout', arguments: order.midtransPaymentUrl);
        });
      } else {
        Get.snackbar('Error', 'Payment URL not available');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to create order: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchOrder() async {
    try {
      isLoading(true);
      print("Mulai fetch order...");
      final orders = await OrderService.fetchOrders();
      print("Order berhasil diambil: ${orders.length}");
      orderList.assignAll(orders);
    } catch (e) {
      print("Gagal ambil order: $e");
      Future.delayed(Duration.zero, () {
        Get.snackbar('Error', 'Failed to fetch order history');
      });
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchOrderDetail(int id) async {
    // try {
    print("Fetch detail for order ID: $id");
    isOrderDetailLoading(true);
    final order = await OrderService.fetchOrderDetail(id);
    print("Order detail fetched: $order");
    selectedOrderDetail.value = order;
    // } catch (e) {
    //   print("Error fetching order detail: $e");
    //   // selectedOrderDetail.value = null;
    //   Future.delayed(Duration.zero, () {
    //     Get.snackbar('Error', 'Gagal mengambil detail pesanan');
    //   });
    // } finally {
    //   isOrderDetailLoading(false);
    // }
  }
}
