import 'package:ecommerce_task6/pages/order_detail_page.dart';
import 'package:ecommerce_task6/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controller/order_controller.dart';
import '../models/order_model.dart';

class OrdersPage extends StatefulWidget {
  OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final OrderController _orderController = Get.find<OrderController>();

  @override
  void initState() {
    super.initState();
    // Pastikan controller terinisialisasi dengan benar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("Initializing order page...");
      _orderController.fetchOrder();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Riwayat Pesanan'),
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 22,
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          // Tombol untuk manual load more (untuk debugging)
          // IconButton(
          //   icon: Icon(Icons.add_circle_outline, color: Colors.black),
          //   onPressed: () {
          //     _orderController.debugLoadMoreManual();
          //   },
          //   tooltip: 'Load More (Debug)',
          // ),
          // Tombol refresh
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.black),
            onPressed: () => _orderController.fetchOrder(),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _orderController.fetchOrder(),
        child: Obx(() {
          // Tampilkan loading spinner ketika pertama kali memuat data
          if (_orderController.isLoading.value &&
              _orderController.orderList.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          // Tampilkan pesan jika tidak ada data
          if (_orderController.orderList.isEmpty) {
            return Center(
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 200),
                  Center(child: Text("Belum ada pesanan.")),
                ],
              ),
            );
          }

          // Tampilkan daftar pesanan dengan infinite scroll
          return NotificationListener<ScrollNotification>(
            // Tambahkan listener tambahan untuk menangkap scroll events
            onNotification: (ScrollNotification scrollInfo) {
              if (scrollInfo is ScrollEndNotification) {
                // Cek saat scroll berhenti di dekat bagian bawah
                if (scrollInfo.metrics.pixels >=
                    scrollInfo.metrics.maxScrollExtent - 200) {
                  if (_orderController.hasMoreData.value &&
                      !_orderController.isLoadingMore.value) {
                    print("ScrollNotification: near bottom, loading more");
                    _orderController.loadMoreOrders();
                  }
                }
              }
              return false;
            },
            child: ListView.builder(
              controller: _orderController.scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(top: 12, bottom: 80),
              itemCount:
                  _orderController.orderList.length + 1, // +1 untuk footer
              itemBuilder: (context, index) {
                // Footer item untuk indikator loading atau pesan
                if (index == _orderController.orderList.length) {
                  return Obx(() {
                    if (_orderController.isLoadingMore.value) {
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        alignment: Alignment.center,
                        child: const Column(
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 8),
                            Text('Memuat pesanan...'),
                          ],
                        ),
                      );
                    } else if (_orderController.hasMoreData.value) {
                      return GestureDetector(
                        onTap: () => _orderController.loadMoreOrders(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          alignment: Alignment.center,
                          child: const Text(
                            'Ketuk untuk memuat lebih banyak pesanan',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      );
                    } else {
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        alignment: Alignment.center,
                        child: Text(
                          'Semua pesanan telah dimuat (${_orderController.orderList.length})',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      );
                    }
                  });
                }

                // Order item
                final order = _orderController.orderList[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: OrderCard(order: order),
                );
              },
            ),
          );
        }),
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 1),
    );
  }
}

class OrderCard extends StatelessWidget {
  final Order order;

  const OrderCard({super.key, required this.order});

  String formatCurrency(int amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print("Navigasi ke detail dengan ID: ${order.id}");
        Get.toNamed('/order-detail', arguments: order.id);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.receipt_long, size: 24, color: Colors.blue),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Order #${order.code}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                _buildStatusChip(order.status),
              ],
            ),
            const Divider(height: 20),
            Text(
              'Total: ${formatCurrency(order.totalPrice)}',
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ID: ${order.id}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                Row(
                  children: [
                    Text(
                      'Lihat Detail',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                      color: Colors.blue,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color chipColor;
    switch (status.toLowerCase()) {
      case 'pending':
        chipColor = Colors.orange;
        break;
      case 'paid':
        chipColor = Colors.green;
        break;
      case 'delivered':
        chipColor = Colors.blue;
        break;
      case 'canceled':
        chipColor = Colors.red;
        break;
      default:
        chipColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: chipColor),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: chipColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
