import 'package:ecommerce_task6/controller/auth_controller.dart';
import 'package:ecommerce_task6/controller/cart_controller.dart';
import 'package:ecommerce_task6/controller/order_controller.dart';
import 'package:ecommerce_task6/controller/product_controller.dart';
import 'package:ecommerce_task6/services/storage_service.dart';
import 'package:get/get.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
    Get.lazyPut<ProductController>(() => ProductController(), fenix: true);
    Get.lazyPut<CartController>(() => CartController(), fenix: true);
    Get.lazyPut<OrderController>(() => OrderController(), fenix: true);
    Get.lazyPut<StorageService>(() => StorageService(), fenix: true);
  }
}
