import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../models/user_model.dart';

class AuthService extends GetxService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://tokopaedi.arfani.my.id/api/',
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
    ),
  );

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post(
        'login',
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        // Ensure the response data is not null and contains the expected structure
        if (response.data != null && response.data is Map<String, dynamic>) {
          return {
            'success': true,
            'user': UserModel.fromJson(response.data['user'] ?? {}),
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

  Future<void> logout() async {
    // Implement logout logic if needed
  }
}
