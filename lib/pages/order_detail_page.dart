// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controller/order_controller.dart';
// import '../models/order_model.dart';

// class OrderDetailPage extends StatelessWidget {
//   final OrderController orderController = Get.find<OrderController>();

//   @override
//   Widget build(BuildContext context) {
//     final order = orderController.selectedOrder.value;

//     if (order == null) {
//       return Scaffold(
//         appBar: AppBar(title: Text('Order Detail')),
//         body: Center(child: Text('No order data available')),
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Order #${order.id}'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView(
//           children: [
//             _buildInfoRow('Order ID:', order.id.toString()),
//             _buildInfoRow('Status:', order.status ?? 'Unknown'),
//             _buildInfoRow('Total Price:', 'Rp ${order.totalPrice?.toStringAsFixed(0) ?? '0'}'),
//             SizedBox(height: 16),
//             Text(
//               'Items',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             Divider(),
//             ...order.orderItems.map((item) => ListTile(
//                   title: Text(item.product?.name ?? 'Product'),
//                   subtitle: Text('Quantity: ${item.quantity}'),
//                   trailing: Text('Rp ${item.product?.price?.toStringAsFixed(0) ?? '0'}'),
//                 )),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         children: [
//           Text(
//             label,
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           SizedBox(width: 8),
//           Expanded(
//             child: Text(value),
//           ),
//         ],
//       ),
//     );
//   }
// }
