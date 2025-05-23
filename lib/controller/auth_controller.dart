import 'package:ecommerce_task6/services/storage_service.dart';
import 'package:get/get.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import 'package:dio/dio.dart';

class AuthController extends GetxController {
  final AuthService _authService = Get.put(AuthService());

  final Rx<UserModel?> _user = Rx<UserModel?>(null);
  UserModel? get user => _user.value;

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final RxString _errorMessage = ''.obs;
  String get errorMessage => _errorMessage.value;

  String? _authToken;
  String? get authToken => _authToken;

  Future<bool> login(String email, String password) async {
    _isLoading.value = true;
    _errorMessage.value = '';
    try {
      final result = await _authService.login(email, password);
      if (result['success']) {
        _user.value = result['user'];
        _authToken = result['token'];
              // await StorageService.saveToken(_authToken!);

        _isLoading.value = false;
        return true;
      } else {
        _errorMessage.value = result['message'];
        _isLoading.value = false;
        return false;
      }
    } catch (e) {
      print('Login error in controller: $e');
      _errorMessage.value = 'An unexpected error occurred';
      _isLoading.value = false;
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    _isLoading.value = true;
    _errorMessage.value = '';
    try {
      final result = await _authService.register(name, email, password);
      if (result['success']) {
        _user.value = result['user'];
        _isLoading.value = false;
        return true;
      } else {
        _errorMessage.value = result['message'];
        _isLoading.value = false;
        return false;
      }
    } catch (e) {
      _errorMessage.value = 'An unexpected error occurred';
      _isLoading.value = false;
      return false;
    }
  }

  Future<void> logout() async {
  _isLoading.value = true;
  try {
    await _authService.logout();
    _user.value = null;
    _authToken = null;
    await StorageService.removeToken();

    // Opsional: Arahkan ke halaman login
    // Get.offAllNamed('/login');
  } catch (e) {
    print("Logout error: $e");
    _errorMessage.value = e.toString();
  } finally {
    _isLoading.value = false;
  }
}
}
