import 'package:dio/dio.dart';
import 'package:ecommerce_task6/services/storage_service.dart';
import 'package:get/get.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../models/user_model.dart';

class AuthService extends GetxService {
  final Dio _dio = Dio(
      BaseOptions(
        baseUrl: 'https://tokopaedi.arfani.my.id/api/',
        connectTimeout: Duration(seconds: 10),
        receiveTimeout: Duration(seconds: 10),
        validateStatus: (status) => true,
        headers: {'Accept': 'application/json'},
      ),
    )
    ..interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    );
  final StorageService _storageService = Get.put(StorageService());

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post(
        'login',
        data: {'email': email, 'password': password},
      );

      String? token = response.data['data']['access_token'];

      if (response.statusCode == 200) {
        // Ensure the response data is not null and contains the expected structure
        if (response.data != null && response.data is Map<String, dynamic>) {
          await StorageService.saveToken(token!);
          return {
            'success': true,
            'user': UserModel.fromJson(response.data['data'] ?? {}),
            'token': response.data['token'] ?? '',
          };
        } else {
          return {'success': false, 'message': 'Invalid response format'};
        }
      } else {
        return {
          'success': false,
          'message': response.data['message'] ?? 'Login failed',
        };
      }
    } on DioException catch (e) {
      print('Login DioError: ${e.response?.data}');
      return {
        'success': false,
        'message': e.response?.data?['message'] ?? 'Network error occurred',
      };
    } catch (e) {
      print('Unexpected login error: $e');
      return {'success': false, 'message': 'An unexpected error occurred'};
    }
  }

  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
  ) async {
    try {
      final response = await _dio.post(
        'register',
        data: {'name': name, 'email': email, 'password': password},
      );
      print(response.data);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'user': UserModel.fromJson(response.data['user'] ?? {}),
          'token': response.data['token'] ?? '',
        };
      } else {
        return {
          'success': false,
          'message': response.data['message'] ?? 'Registration failed',
        };
      }
    } on DioException catch (e) {
      return {
        'success': false,
        'message': e.response?.data?['message'] ?? 'Network error occurred',
      };
    } catch (e) {
      return {'success': false, 'message': 'An unexpected error occurred'};
    }
  }
  Future<void> logout() async {
  await StorageService.removeToken();
}
}