import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/cart_controller.dart';
import '../controller/order_controller.dart';
import '../services/order_service.dart';

class CartPage extends StatelessWidget {
  final CartController cartController = Get.find<CartController>();
  final OrderController orderController = Get.put(OrderController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Your Cart",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Obx(() {
        if (cartController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (cartController.cartItems.isEmpty) {
          return Center(
            child: Text(
              "Your cart is empty",
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cartController.cartItems.length,
                itemBuilder: (context, index) {
                  final cartItem = cartController.cartItems[index];

                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: ListTile(
                      leading: Image.network(
                        cartItem.product.image,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.image_not_supported,
                            color: Colors.grey,
                          );
                        },
                      ),
                      title: Text(cartItem.product.name),
                      subtitle: Text(
                        "Rp ${cartItem.product.price} x ${cartItem.quantity}",
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove, color: Colors.red),
                            onPressed:
                                () => cartController.updateCartQuantity(
                                  cartItem,
                                  cartItem.quantity - 1,
                                ),
                          ),
                          Text(
                            "${cartItem.quantity}",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.add, color: Colors.green),
                            onPressed:
                                () => cartController.updateCartQuantity(
                                  cartItem,
                                  cartItem.quantity + 1,
                                ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed:
                                () => cartController.removeFromCart(cartItem),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            // Total Price and Checkout Section
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.grey.shade300)),
              ),
              child: Column(
                children: [
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total:",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Rp ${cartController.totalPrice.value.toStringAsFixed(0)}",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Obx(
                    () => SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                            orderController.isLoading.value
                                ? null
                                : () async {
                                  // Validate cart is not empty
                                  if (cartController.cartItems.isEmpty) {
                                    Get.snackbar(
                                      'Error',
                                      'Your cart is empty',
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                    );
                                    return;
                                  }

                                  // Call create order method
                                  await orderController.createOrder();
                                },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: Colors.black,
                          disabledBackgroundColor: Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child:
                            orderController.isLoading.value
                                ? CircularProgressIndicator(color: Colors.white)
                                : Text(
                                  "Checkout",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
