import 'package:get/get.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';
import '../services/product_service.dart';

class ProductController extends GetxController {
  final ProductService _productService = Get.put(ProductService());

  final RxList<ProductModel> _products = <ProductModel>[].obs;
  List<ProductModel> get products => _products;

  final RxList<CategoryModel> _categories = <CategoryModel>[].obs;
  List<CategoryModel> get categories => _categories;

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final RxString _searchQuery = ''.obs;
  String get searchQuery => _searchQuery.value;

  final Rx<CategoryModel?> _selectedCategory = Rx<CategoryModel?>(null);
  CategoryModel? get selectedCategory => _selectedCategory.value;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
    fetchProducts();
  }

  Future<void> fetchProducts({String? search, int? categoryId}) async {
    _isLoading.value = true;
    try {
      final fetchedProducts = await _productService.fetchProducts(
        search: search,
        categoryId: categoryId,
      );
      _products.value = fetchedProducts;
    } catch (e) {
      print('Error fetching products: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> fetchCategories() async {
    _isLoading.value = true;
    try {
      final fetchedCategories = await _productService.fetchCategories();
      _categories.value = fetchedCategories;
    } catch (e) {
      print('Error fetching categories: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  void setSearchQuery(String query) {
    _searchQuery.value = query;
    fetchProducts(search: query);
  }

  void setSelectedCategory(CategoryModel? category) {
    _selectedCategory.value = category;
    fetchProducts(categoryId: category?.id);
  }
}