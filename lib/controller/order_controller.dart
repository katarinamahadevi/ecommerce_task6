import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/cart_controller.dart';
import '../controller/auth_controller.dart';
import '../services/order_service.dart';
import '../models/order_model.dart';

class OrderController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();
  final CartController _cartController = Get.find<CartController>();
  var isLoading = false.obs;
  var isLoadingMore = false.obs;
  Rx<Order?> currentOrder = Rx<Order?>(null);
  var orderList = <Order>[].obs;
  Rx<Order?> selectedOrder = Rx<Order?>(null);
  var selectedOrderDetail = Rx<Order?>(null);
  var isOrderDetailLoading = false.obs;
  
  // Pagination parameters
  var currentPage = 1.obs;
  var lastPage = 1.obs;
  var hasMoreData = true.obs;
  var scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_scrollListener);
    print("Scroll listener added");
  }

  @override
  void onClose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.onClose();
  }

  void _scrollListener() {
    if (scrollController.hasClients && 
        scrollController.position.pixels > 0 &&
        scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
      
      if (hasMoreData.value && !isLoadingMore.value) {
        print("Scroll detected near bottom, loading more data");
        loadMoreOrders();
      }
    }
  }

  void debugLoadMoreManual() {
    if (hasMoreData.value && !isLoadingMore.value) {
      print("Manual load more triggered");
      loadMoreOrders();
    }
  }

  Future<void> createOrder() async {
    if (_cartController.cartItems.isEmpty) {
      Get.snackbar('Error', 'Your cart is empty');
      return;
    }
    isLoading(true);
    try {
      final items =
          _cartController.cartItems
              .map(
                (item) => {
                  'product_id': item.productId,
                  'quantity': item.quantity,
                },
              )
              .toList();
      final order = await OrderService.createOrder(
        _cartController.totalPrice.value.toInt(),
        items,
      );
      currentOrder.value = order;
      if (order.midtransPaymentUrl.isNotEmpty) {
        Future.delayed(Duration.zero, () {
          Get.toNamed('/checkout', arguments: order.midtransPaymentUrl);
        });
      } else {
        Get.snackbar('Error', 'Payment URL not available');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to create order: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchOrder() async {
    try {
      isLoading(true);
      currentPage.value = 1;  
      hasMoreData.value = true; 
      print("Mulai fetch order halaman ${currentPage.value}...");
      
      final response = await OrderService.fetchOrders(currentPage.value);
      final orders = response['orders'] as List<Order>;
      final metaData = response['meta'] as Map<String, dynamic>;
      
      print("Order berhasil diambil: ${orders.length}");
      print("Pagination meta: $metaData");
      
      orderList.assignAll(orders);
      
            lastPage.value = metaData['last_page'] ?? 1;
      hasMoreData.value = currentPage.value < lastPage.value;
      
      print("Has more data: ${hasMoreData.value}, Current: ${currentPage.value}, Last: ${lastPage.value}");
    } catch (e) {
      print("Gagal ambil order: $e");
      Future.delayed(Duration.zero, () {
        Get.snackbar('Error', 'Failed to fetch order history');
      });
    } finally {
      isLoading(false);
    }
  }

  Future<void> loadMoreOrders() async {
    if (!hasMoreData.value || isLoadingMore.value) {
      print("Skip loading more: hasMoreData=${hasMoreData.value}, isLoadingMore=${isLoadingMore.value}");
      return;
    }
    
    try {
      isLoadingMore(true);
      final nextPage = currentPage.value + 1;
      print("Loading more orders, page: $nextPage");
      
      final response = await OrderService.fetchOrders(nextPage);
      final newOrders = response['orders'] as List<Order>;
      final metaData = response['meta'] as Map<String, dynamic>;
      
      print("Loaded ${newOrders.length} more orders from page $nextPage");
      
      if (newOrders.isNotEmpty) {
        orderList.addAll(newOrders);
        currentPage.value = nextPage;
        lastPage.value = metaData['last_page'] ?? lastPage.value;
        hasMoreData.value = currentPage.value < lastPage.value;
        print("Updated pagination: Current=${currentPage.value}, Last=${lastPage.value}, HasMore=${hasMoreData.value}");
      } else {
        hasMoreData.value = false;
        print("No more orders to load");
      }
    } catch (e) {
      print("Failed to load more orders: $e");
      Get.snackbar('Error', 'Failed to load more orders');
    } finally {
      isLoadingMore(false);
    }
  }

  Future<void> fetchOrderDetail(int id) async {
    try {
      print("Fetch detail for order ID: $id");
      isOrderDetailLoading(true);
      final order = await OrderService.fetchOrderDetail(id);
      print("Order detail fetched: $order");
      selectedOrderDetail.value = order;
    } catch (e) {
      print("Error fetching order detail: $e");
      Future.delayed(Duration.zero, () {
        Get.snackbar('Error', 'Gagal mengambil detail pesanan');
      });
    } finally {
      isOrderDetailLoading(false);
    }
  }
}