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
      final dio = Dio(
        BaseOptions(
          baseUrl: 'https://tokopaedi.arfani.my.id/api/',
          connectTimeout: Duration(seconds: 10),
          receiveTimeout: Duration(seconds: 10),
        ),
      );

      final response = await dio.post(
        'register',
        data: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': password,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Parse user from response
        final userData = response.data['user'];
        final token = response.data['token'];

        if (userData != null) {
          _user.value = UserModel.fromJson(userData);
          _authToken = token;
          _isLoading.value = false;
          return true;
        }
      }

      // If registration fails
      _errorMessage.value = response.data['message'] ?? 'Registration failed';
      _isLoading.value = false;
      return false;
    } on DioException catch (e) {
      print('Registration DioError: ${e.response?.data}');
      _errorMessage.value =
          e.response?.data?['message'] ?? 'Network error occurred';
      _isLoading.value = false;
      return false;
    } catch (e) {
      print('Unexpected registration error: $e');
      _errorMessage.value = 'An unexpected error occurred';
      _isLoading.value = false;
      return false;
    }
  }

  void logout() {
    _user.value = null;
    _authToken = null;
    _errorMessage.value = '';
    _authService.logout();
  }
}
