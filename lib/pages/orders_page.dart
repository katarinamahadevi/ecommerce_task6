// import 'package:ecommerce_task6/controller/order_controller.dart';
// import 'package:ecommerce_task6/widgets/navbar.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../models/order_model.dart';

// class OrdersPage extends StatelessWidget {
//   final OrderController _orderController = Get.find<OrderController>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: Text(
//           'My Orders',
//           style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//         ),

//         centerTitle: true,
//         automaticallyImplyLeading: false, // Menghilangkan tombol back
//       ),
//       body: Obx(() {
//         if (_orderController.isLoading) {
//           return Center(child: CircularProgressIndicator());
//         }

//         if (_orderController.orders.isEmpty) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   Icons.shopping_bag_outlined,
//                   size: 80,
//                   color: Colors.grey[400],
//                 ),
//                 SizedBox(height: 16),
//                 Text(
//                   'No orders yet',
//                   style: TextStyle(fontSize: 18, color: Colors.grey[600]),
//                 ),
//               ],
//             ),
//           );
//         }

//         return ListView.builder(
//           padding: EdgeInsets.all(16),
//           itemCount: _orderController.orders.length,
//           itemBuilder: (context, index) {
//             final order = _orderController.orders[index];
//             return _buildOrderCard(order);
//           },
//         );
//       }),
//       bottomNavigationBar: BottomNavBar(currentIndex: 1),
//     );
//   }

//   Widget _buildOrderCard(Order order) {
//     return Card(
//       margin: EdgeInsets.only(bottom: 16),
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Order #${order.code}',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 _buildStatusChip(order.status),
//               ],
//             ),
//             SizedBox(height: 12),
//             Text(
//               'Total: \$${order.totalPrice}',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//             ),
//             SizedBox(height: 8),
//             Text(
//               'Ordered on: ${order.createdAt.toLocal()}',
//               style: TextStyle(color: Colors.grey[600]),
//             ),
//             SizedBox(height: 12),
//             _buildOrderItemsList(order),
//             SizedBox(height: 12),
//             _buildOrderActions(order),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildStatusChip(String status) {
//     Color chipColor;
//     switch (status.toLowerCase()) {
//       case 'pending':
//         chipColor = Colors.orange;
//         break;
//       case 'processing':
//         chipColor = Colors.blue;
//         break;
//       case 'completed':
//         chipColor = Colors.green;
//         break;
//       case 'cancelled':
//         chipColor = Colors.red;
//         break;
//       default:
//         chipColor = Colors.grey;
//     }

//     return Chip(
//       label: Text(
//         status,
//         style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//       ),
//       backgroundColor: chipColor,
//     );
//   }

//   Widget _buildOrderItemsList(Order order) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Items:',
//           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//         ),
//         ...order.orderItems.map(
//           (item) => Padding(
//             padding: const EdgeInsets.symmetric(vertical: 4.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: Text(
//                     item.product.name,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//                 Text('x${item.quantity}'),
//                 Text('\$${item.price * item.quantity}'),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildOrderActions(Order order) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         ElevatedButton.icon(
//           onPressed: () => _viewOrderDetails(order),
//           icon: Icon(Icons.receipt_long),
//           label: Text('View Details'),
//           style: ElevatedButton.styleFrom(
//             foregroundColor: Colors.white,
//             backgroundColor: Colors.blue,
//           ),
//         ),
//         if (order.status.toLowerCase() == 'pending')
//           OutlinedButton(
//             onPressed: () => _proceedToPayment(order),
//             child: Text('Pay Now'),
//             style: OutlinedButton.styleFrom(
//               foregroundColor: Colors.green,
//               side: BorderSide(color: Colors.green),
//             ),
//           ),
//       ],
//     );
//   }

//   void _viewOrderDetails(Order order) {
//     // Navigate to order details page or show bottom sheet
//     Get.dialog(
//       AlertDialog(
//         title: Text('Order Details'),
//         content: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('Order Code: ${order.code}'),
//               Text('Total Price: \$${order.totalPrice}'),
//               Text('Status: ${order.status}'),
//               // Add more details as needed
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(onPressed: () => Get.back(), child: Text('Close')),
//         ],
//       ),
//     );
//   }

//   void _proceedToPayment(Order order) {
//     // Implement payment logic using Midtrans
//     // You can use the midtransPaymentUrl or midtransSnapToken
//     // This is a placeholder - integrate with actual payment gateway
//     ScaffoldMessenger.of(Get.context!).showSnackBar(
//       SnackBar(
//         content: Text('Proceeding to payment for Order ${order.code}'),
//         backgroundColor: Colors.blue,
//       ),
//     );
//   }
// }
