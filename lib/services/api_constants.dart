import 'package:ecommerce_task6/controller/auth_controller.dart';
import 'package:ecommerce_task6/controller/cart_controller.dart';
import 'package:ecommerce_task6/controller/order_controller.dart';
import 'package:ecommerce_task6/controller/product_controller.dart';
import 'package:get/get.dart';

class AppBindings extends Bindings {
  //buat mendaftarkan controller yang udah dibuat
  @override
  void dependencies() {
    Get.put<AuthController>(AuthController());
    Get.put<ProductController>(ProductController());
    Get.put<CartController>(CartController());
    Get.put<OrderController>(OrderController());
  }
}
