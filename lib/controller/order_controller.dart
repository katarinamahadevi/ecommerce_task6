import 'package:ecommerce_task6/models/order_model.dart';
import 'package:ecommerce_task6/services/order_service.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  var isLoading = false.obs;
  var order = Rxn<Order>();

  // Membuat order baru
  Future<void> createOrder(List<Map<String, dynamic>> orderItems) async {
    isLoading(true);
    try {
      Order? newOrder = await OrderService.createOrder(orderItems);
      if (newOrder != null) {
        order.value = newOrder;
        Get.snackbar("Success", "Order berhasil dibuat");
        Get.toNamed('/checkout', arguments: newOrder);
      }
    } catch (e) {
      Get.snackbar("Error", "$e");
    } finally {
      isLoading(false);
    }
  }
}
