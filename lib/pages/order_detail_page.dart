import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controller/order_controller.dart';
import '../models/order_model.dart';

class OrderDetailPage extends StatefulWidget {
  final int orderId;

  const OrderDetailPage({super.key, required this.orderId});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  final OrderController _orderController = Get.find<OrderController>();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _orderController.fetchOrderDetail(widget.orderId);
    });
  }

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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Detail Pesanan',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Obx(() {
        // if (_orderController.isOrderDetailLoading.value) {
        //   return const Center(child: CircularProgressIndicator());
        // }

        final order = _orderController.selectedOrderDetail.value;

        if (order == null) {
          return const Center(child: Text('Gagal memuat detail pesanan.'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Kode Pesanan: ${order.code}', style: titleStyle),
              const SizedBox(height: 8),
              Text('Status: ${order.status}', style: infoStyle),
              const SizedBox(height: 4),
              Text(
                'Metode Pembayaran: ${order.midtransPaymentType}',
                style: infoStyle,
              ),
              const SizedBox(height: 4),
              Text(
                'Tanggal: ${DateFormat('dd MMM yyyy, HH:mm').format(order.createdAt)}',
                style: infoStyle,
              ),
              const SizedBox(height: 12),
              Divider(),
              Text('Produk', style: titleStyle),
              const SizedBox(height: 8),
              ...order.orderItems.map((item) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          item.product?.image ?? '',
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 60,
                              height: 60,
                              color: Colors.grey[300],
                              child: const Icon(Icons.broken_image),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.product?.name ?? 'Produk tidak ditemukan',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 4),
                            Text('Qty: ${item.quantity}'),
                            Text('Harga: ${formatCurrency(item.price)}'),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),

              Divider(),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Harga',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    formatCurrency(order.totalPrice),
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              if (order.status.toLowerCase() == 'pending' &&
                  order.midtransPaymentUrl.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.toNamed(
                          '/checkout',
                          arguments: order.midtransPaymentUrl,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Bayar Sekarang',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  TextStyle get titleStyle =>
      const TextStyle(fontWeight: FontWeight.bold, fontSize: 16);
  TextStyle get infoStyle =>
      const TextStyle(fontSize: 14, color: Colors.black54);
}
