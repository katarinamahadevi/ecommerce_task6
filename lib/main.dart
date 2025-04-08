import 'package:ecommerce_task6/pages/cart_page.dart';
import 'package:ecommerce_task6/pages/checkout_page.dart';
import 'package:ecommerce_task6/pages/home_page.dart';
import 'package:ecommerce_task6/pages/login_page.dart';
import 'package:ecommerce_task6/pages/onboarding_page.dart';
import 'package:ecommerce_task6/pages/order_detail_page.dart';
import 'package:ecommerce_task6/pages/orders_page.dart';
import 'package:ecommerce_task6/pages/profile_page.dart';
import 'package:ecommerce_task6/pages/register_page.dart';
import 'package:ecommerce_task6/services/api_constants.dart';
import 'package:ecommerce_task6/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-Commerce App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialBinding: AppBindings(),
      initialRoute: '/onboarding',
      getPages: [
        GetPage(name: '/onboarding', page: () => OnboardingPage()),
        GetPage(name: '/login', page: () => LoginPage()),
        GetPage(name: '/register', page: () => RegisterPage()),
        GetPage(name: '/home', page: () => HomePage()),
        GetPage(name: '/cart', page: () => CartPage()),
        GetPage(name: '/orders', page: () => OrdersPage()),
        GetPage(name: '/profile', page: () => ProfilePage()),
        GetPage(
          name: '/checkout',
          page: () => CheckoutPage(paymentUrl: Get.arguments),
        ),
//         GetPage(
//   name: '/order-detail',
//   page: () => OrderDetailPage(),
// ),

      ],
    );
  }
}

void main() {
  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  GetStorage.init();
  Get.put(StorageService());
}
