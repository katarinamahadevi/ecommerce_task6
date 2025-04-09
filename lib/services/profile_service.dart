import 'package:dio/dio.dart';
import 'package:ecommerce_task6/services/storage_service.dart';
import 'package:get/get.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../models/user_model.dart';

class ProfileService extends GetxService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://tokopaedi.arfani.my.id/api/',
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
      headers: {'Accept': 'application/json'},
    ),
  )
  ..interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      compact: true,
      maxWidth: 90,
    ));

  final StorageService _storageService = Get.put(
    StorageService(),
  ); // ✅ Mencegah error
  ProfileService() {
    Get.lazyPut(() => StorageService());
  }

  Future<UserModel?> getUserProfile() async {
    String? token = await StorageService.getToken();
    try {
      final response = await _dio.get(
        'user',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data['data']);
      } else {
        return UserModel.fromJson(response.data);
      }
    } on DioException catch (e) {
      print('Profile fetch error: ${e.response?.data}');
      return null;
    } catch (e) {
      print('Unexpected profile error: $e');
      return null;
    }
  }

  Future<bool> updateUserProfile(String name, String password) async {
    String? token = await StorageService.getToken();

    if (token == null) {
      print('User is not authenticated');
      return false;
    }

    try {
      final response = await _dio.post(
        'user/update', 
        data: {'name': name, 'password': password},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        print('Profile updated successfully');
        return true;
      } else {
        print('Profile update failed: ${response.data}');
        return false;
      }
    } on DioException catch (e) {
      print('Profile update error: ${e.response?.data}');
      return false;
    } catch (e) {
      print('Unexpected profile update error: $e');
      return false;
    }
  }
}
