import 'package:ecommerce_task6/pages/cart_page.dart';
import 'package:ecommerce_task6/pages/home_page.dart';
import 'package:ecommerce_task6/pages/login_page.dart';
import 'package:ecommerce_task6/pages/onboarding_page.dart';
import 'package:ecommerce_task6/pages/orders_page.dart';
import 'package:ecommerce_task6/pages/register_page.dart';
import 'package:ecommerce_task6/services/api_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
        // GetPage(name: '/register', page: () => RegisterPage()),
        GetPage(name: '/home', page: () => HomePage()),
        GetPage(name: '/cart', page: () => CartPage()),
        GetPage(name: '/orders', page: () => OrdersPage()),
        //   GetPage(name: '/profile', page: () => ProfileScreen()),
        GetPage(name: '/checkout', page: () => OrdersPage()),
      ],
    );
  }
}

void main() {
  runApp(const MyApp());
}
