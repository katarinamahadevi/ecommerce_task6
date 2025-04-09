import 'package:ecommerce_task6/controller/cart_controller.dart';
import 'package:ecommerce_task6/controller/product_controller.dart';
import 'package:ecommerce_task6/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ProductController _productController = Get.find<ProductController>();
  final CartController _cartController = Get.find<CartController>();
  final ScrollController _scrollController = ScrollController();

  CategoryModel? _selectedCategory;
  double _minPrice = 0;
  double _maxPrice = 0;
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _productController.fetchCategories();
    _setupScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  void _setupScrollController() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 300) {
        // Load more data when user scrolls to near the end
        _productController.loadMore();
      }
    });
  }

  void _showFilterBottomSheet(BuildContext context) {
    // _selectedCategory = _productController.selectedCategory;
    _minPriceController.text =
        _minPrice > 0 ? _minPrice.toStringAsFixed(0) : '';
    _maxPriceController.text =
        _maxPrice > 0 ? _maxPrice.toStringAsFixed(0) : '';

    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                padding: EdgeInsets.all(20),
                height: MediaQuery.of(context).size.height * 0.8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Filter Products',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.black54),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    Divider(color: Colors.grey[300]),
                    SizedBox(height: 10),
                    Text(
                      'Categories',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 10),
                    Obx(() {
                      final allCategories = [
                        null,
                        ...?_productController.categories,
                      ];
                      return Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children:
                            allCategories.map((category) {
                              return ChoiceChip(
                                label: Text(category?.name ?? 'All'),
                                selected: _selectedCategory == category,
                                onSelected: (bool selected) {
                                  setState(() {
                                    _selectedCategory = category;
                                  });
                                },
                                selectedColor: Colors.black,
                                labelStyle: TextStyle(
                                  color:
                                      _selectedCategory == category
                                          ? Colors.white
                                          : Colors.black,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(
                                    color:
                                        _selectedCategory == category
                                            ? Colors.transparent
                                            : Colors.grey[300]!,
                                  ),
                                ),
                              );
                            }).toList(),
                      );
                    }),

                    SizedBox(height: 20),

                    // Price Range Filter
                    Text(
                      'Price Range',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        // Minimum Price
                        Expanded(
                          child: TextField(
                            controller: _minPriceController,
                            decoration: InputDecoration(
                              hintText: 'Min Price',
                              prefixText: 'Rp ',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.grey[300]!,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                        ),
                        SizedBox(width: 10),
                        Text('-', style: TextStyle(fontSize: 18)),
                        SizedBox(width: 10),
                        // Maximum Price
                        Expanded(
                          child: TextField(
                            controller: _maxPriceController,
                            decoration: InputDecoration(
                              hintText: 'Max Price',
                              prefixText: 'Rp ',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.grey[300]!,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                        ),
                      ],
                    ),

                    Spacer(),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              _minPrice =
                                  _minPriceController.text.isEmpty
                                      ? 0
                                      : double.parse(_minPriceController.text);
                              _maxPrice =
                                  _maxPriceController.text.isEmpty
                                      ? 0
                                      : double.parse(_maxPriceController.text);

                              _productController.setSelectedCategory(
                                _selectedCategory,
                              );
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              padding: EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'Apply',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          'Tokopaedi',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          Obx(() {
            final cartItemCount = _cartController.cartItems.length;
            return Stack(
              alignment: Alignment.topRight,
              children: [
                IconButton(
                  icon: Icon(Icons.shopping_cart, color: Colors.black),
                  onPressed: () => Get.toNamed('/cart'),
                ),
                if (cartItemCount > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: BoxConstraints(minWidth: 18, minHeight: 18),
                      child: Text(
                        '$cartItemCount',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            );
          }),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Row
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                // Expanded Search Bar
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Cari produk...',
                      prefixIcon: Icon(Icons.search, color: Colors.black),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    onChanged: (value) {
                      _productController.setSearchQuery(value);
                    },
                  ),
                ),

                // Filter Icon
                SizedBox(width: 10),
                IconButton(
                  icon: Icon(Icons.filter_list, color: Colors.black),
                  onPressed: () => _showFilterBottomSheet(context),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Obx(() {
              if (_productController.isLoading &&
                  _productController.products.isEmpty) {
                return Center(
                  child: CircularProgressIndicator(color: Colors.black),
                );
              }

              if (_productController.products.isEmpty) {
                return Center(
                  child: Text(
                    'No products found',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                );
              }

              return CustomScrollView(
                controller: _scrollController,
                slivers: [
                  // Products Grid
                  SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.7,
                    ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final product = _productController.products[index];
                      return ProductCard(
                        product: product,
                        onAddToCart: () {
                          _cartController.addToCart(product);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${product.name} added to cart'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                        onTap: () {
                          // Get.toNamed('/product-detail', arguments: product);
                        },
                      );
                    }, childCount: _productController.products.length),
                  ),

                  SliverToBoxAdapter(
                    child: Obx(() {
                      if (_productController.isFetchingMore) {
                        return Container(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.black,
                            ),
                            strokeWidth: 3,
                          ),
                        );
                      } else {
                        return SizedBox(height: 20);
                      }
                    }),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 0),
    );
  }
}

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onAddToCart;
  final VoidCallback onTap;

  const ProductCard({
    Key? key,
    required this.product,
    required this.onAddToCart,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final imageHeight = constraints.maxWidth * 0.7;
        final fontSize = constraints.maxWidth * 0.045;

        return GestureDetector(
          onTap: onTap,
          child: Container(
            margin: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  child: Container(
                    height: imageHeight,
                    width: double.infinity,
                    color: Colors.grey[200],
                    child: Image.network(
                      product.image,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value:
                                loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                            color: Colors.black54,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.grey,
                            size: imageHeight * 0.5,
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Product Details
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Product Name
                        Text(
                          product.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: fontSize,
                            color: Colors.black,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          product.description,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: fontSize * 0.8,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                product.rupiah,
                                style: TextStyle(
                                  color: Colors.green[700],
                                  fontWeight: FontWeight.bold,
                                  fontSize: fontSize,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: onAddToCart,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                              ),
                              child: Text(
                                'Add',
                                style: TextStyle(
                                  fontSize: fontSize * 0.8,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
