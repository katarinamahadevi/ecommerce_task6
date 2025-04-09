import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';

class ProductService extends GetxService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://tokopaedi.arfani.my.id/api/',
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
      headers: {'Accept': 'application/json'},
    ),
  );

  Future<List<ProductModel>> fetchProducts({
    String? search,
    int? categoryId,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final queryParams = <String, dynamic>{'page' : page,
      'limit' : limit,};
      
      if (search != null) queryParams['name'] = search;
      if (categoryId != null) queryParams['category_id'] = categoryId;

      final response = await _dio.get('products', queryParameters: queryParams);

      if (response.statusCode == 200) {
        final List<dynamic> productList = response.data['data'];
        return productList.map((json) => ProductModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('Fetch products error: $e');
      return [];
    }
  }

  Future<List<CategoryModel>> fetchCategories() async {
    try {
      final response = await _dio.get('categories');

      print('Raw Response: ${response.data}');
      print('Response Type: ${response.data.runtimeType}');

      if (response.data is List) {
        final List<dynamic> categoryList = response.data;

        print('Raw Category List: $categoryList');

        return categoryList
            .map((json) => CategoryModel.fromJson(json))
            .toList();
      } else if (response.data is Map && response.data['data'] is List) {
        final List<dynamic> categoryList = response.data['data'];

        print('Raw Category List: $categoryList');

        return categoryList
            .map((json) => CategoryModel.fromJson(json))
            .toList();
      }

      print('Unexpected response format');
      return [];
    } catch (e) {
      print('Fetch categories error: $e');
      return [];
    }
  }
}
