import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class OnboardingController extends GetxController {
  final GetStorage _storage = GetStorage();
  var currentPage = 0.obs;
  final PageController pageController = PageController();

  final List<Map<String, String>> onboardingData = [
    {
      'title': 'Selamat Datang di Tokopaedi',
      'image': 'assets/images/onboarding1.png',
      'description': 'Temukan berbagai produk berkualitas dengan harga terbaik',
    },
    {
      'title': 'Belanja Mudah',
      'image': 'assets/images/onboarding2.png',
      'description': 'Cukup beberapa klik, produk akan dikirim ke alamat Anda',
    },
    {
      'title': 'Pembayaran Aman',
      'image': 'assets/images/onboarding3.png',
      'description': 'Berbagai metode pembayaran yang aman dan terpercaya',
    },
  ];

  bool get isLastPage => currentPage.value == onboardingData.length - 1;

  void nextPage() {
    if (isLastPage) {
      completeOnboarding();
    } else {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  void goToPage(int index) {
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  void completeOnboarding() {
    _storage.write('onboarding_completed', true);
    Get.offAllNamed('/login');
  }

  void skipOnboarding() {
    completeOnboarding();
  }

  bool isOnboardingCompleted() {
    return _storage.read('onboarding_completed') ?? false;
  }
}