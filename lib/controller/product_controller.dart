import 'package:ecommerce_task6/models/category_model.dart';
import 'package:ecommerce_task6/models/product_model.dart';
import 'package:ecommerce_task6/services/product_service.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ProductController extends GetxController {
  final ProductService _productService = Get.put(ProductService());

  final RxList<ProductModel> _products = <ProductModel>[].obs;
  List<ProductModel> get products => _products;

  final RxList<CategoryModel> _categories = <CategoryModel>[].obs;
  List<CategoryModel> get categories => _categories;

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final RxBool _isFetchingMore = false.obs;
  bool get isFetchingMore => _isFetchingMore.value;

  int _currentPage = 1;
  bool _hasMore = true;

  final RxString _searchQuery = ''.obs;
  final Rx<CategoryModel?> _selectedCategory = Rx<CategoryModel?>(null);

  final Rx<int?> _minPrice = Rx<int?>(null);
  final Rx<int?> _maxPrice = Rx<int?>(null);

  int? get minPrice => _minPrice.value;
  int? get maxPrice => _maxPrice.value;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
    fetchProducts(reset: true);
  }

  void setMinPrice(int? price) {
    _minPrice.value = price;
  }

  void setMaxPrice(int? price) {
    _maxPrice.value = price;
  }

  void resetPriceFilter() {
    _minPrice.value = null;
    _maxPrice.value = null;
  }

  Future<void> fetchProducts({bool reset = false}) async {
    if (_isLoading.value || _isFetchingMore.value) return;

    if (reset) {
      _currentPage = 1;
      _hasMore = true;
      _products.clear();
    }

    if (!_hasMore) return;

    if (_currentPage == 1) {
      _isLoading.value = true;
    } else {
      _isFetchingMore.value = true;
    }

    try {
      final fetchedProducts = await _productService.fetchProducts(
        search: _searchQuery.value,
        categoryId: _selectedCategory.value?.id,
        minPrice: _minPrice.value,
        maxPrice: _maxPrice.value,
        page: _currentPage,
        limit: 10,
      );

      if (fetchedProducts.isEmpty) {
        _hasMore = false;
      } else {
        _products.addAll(fetchedProducts);
        _currentPage++;

        if (fetchedProducts.length < 10) {
          _hasMore = false;
        }
      }
    } catch (e) {
      print('Error fetching products: $e');
    } finally {
      _isLoading.value = false;
      _isFetchingMore.value = false;
    }
  }

  Future<void> fetchCategories() async {
    try {
      final fetchedCategories = await _productService.fetchCategories();
      _categories.value = fetchedCategories;
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  void setSearchQuery(String query) {
    _searchQuery.value = query;
    fetchProducts(reset: true);
  }

  void setSelectedCategory(CategoryModel? category) {
    _selectedCategory.value = category;
    fetchProducts(reset: true);
  }

  void loadMore() {
    if (_hasMore && !_isFetchingMore.value) {
      fetchProducts();
    }
  }
}
