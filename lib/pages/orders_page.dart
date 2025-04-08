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
    Future.delayed(Duration.zero, () {
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
          fontSize: 20,
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Obx(() {
        if (_orderController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_orderController.orderList.isEmpty) {
          return const Center(child: Text("Belum ada pesanan."));
        }

        return ListView.builder(
          padding: const EdgeInsets.only(top: 12),
          itemCount: _orderController.orderList.length,
          itemBuilder: (context, index) {
            final order = _orderController.orderList[index];
            return OrderTile(order: order);
          },
        );
      }),
      bottomNavigationBar: BottomNavBar(currentIndex: 1),
    );
  }
}

class OrderTile extends StatelessWidget {
  final Order order;

  const OrderTile({super.key, required this.order});

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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          const Icon(Icons.receipt_long, size: 30, color: Colors.black),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order #${order.code}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Total: ${formatCurrency(order.totalPrice)}',
                  style: const TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 2),
                Text(
                  'Status: ${order.status}',
                  style: const TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
    );
  }
}
