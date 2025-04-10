import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ProductService extends GetxService {
  final Dio _dio = Dio(
      BaseOptions(
        baseUrl: 'https://tokopaedi.arfani.my.id/api/',
        connectTimeout: Duration(seconds: 10),
        receiveTimeout: Duration(seconds: 10),
        headers: {'Accept': 'application/json'},
      ),
    )
    ..interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        compact: true,
        maxWidth: 90,
      ),
    );

  Future<List<ProductModel>> fetchProducts({
    String? search,
    int? categoryId,
    int? minPrice,
    int? maxPrice,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final queryParams = <String, dynamic>{'page': page, 'limit': limit};

      if (search != null && search.isNotEmpty) queryParams['name'] = search;
      if (categoryId != null) queryParams['category_id'] = categoryId;

      // Kita masih mengirim parameter harga ke API, meskipun API mungkin mengabaikannya
      if (minPrice != null) queryParams['min_price'] = minPrice;
      if (maxPrice != null) queryParams['max_price'] = maxPrice;

      print('Query params: $queryParams');
      final response = await _dio.get('products', queryParameters: queryParams);
      print('Response for filtered products: ${response.data}');

      if (response.statusCode == 200) {
        final List<dynamic> productList = response.data['data'];
        List<ProductModel> products =
            productList.map((json) => ProductModel.fromJson(json)).toList();

        // Filter harga di sisi klien
        if (minPrice != null || maxPrice != null) {
          products =
              products.where((product) {
                bool matches = true;
                if (minPrice != null) {
                  matches = matches && product.price >= minPrice;
                }
                if (maxPrice != null) {
                  matches = matches && product.price <= maxPrice;
                }
                return matches;
              }).toList();

          print('After client-side filtering: ${products.length} products');
        }

        return products;
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
