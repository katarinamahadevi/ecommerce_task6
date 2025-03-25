import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/cart_controller.dart';
import '../models/cart_model.dart';

class CartPage extends StatefulWidget {
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartController _cartController = Get.find<CartController>();

  @override
  void initState() {
    
    // TODO: implement initState
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Obx(() {
        // Menampilkan loading indicator jika sedang memuat
        if (_cartController.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        // Menampilkan pesan jika keranjang kosong
        if (_cartController.cartItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  size: 100,
                  color: Colors.grey[400],
                ),
                SizedBox(height: 16),
                Text(
                  'Your cart is empty',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Get.toNamed('/home'),
                  child: Text('Start Shopping'),
                ),
              ],
            ),
          );
        }

        // Daftar item di keranjang
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: _cartController.cartItems.length,
                itemBuilder: (context, index) {
                  final cartItem = _cartController.cartItems[index];
                  return _buildCartItemCard(cartItem);
                },
              ),
            ),
            
            // Total dan Checkout
            _buildCheckoutSection(),
          ],
        );
      }),
    );
  }

  Widget _buildCartItemCard(CartModel cartItem) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Gambar Produk
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(cartItem.product.image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 16),
            
            // Detail Produk
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cartItem.product.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Text(
                    cartItem.product.rupiah,
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  
                  // Kontrol Kuantitas
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Tombol Kurangi Kuantitas
                      IconButton(
                        icon: Icon(Icons.remove_circle_outline),
                        onPressed: () {
                          if (cartItem.quantity > 1) {
                            _cartController.updateCartItemQuantity(
                              cartItem, 
                              cartItem.quantity - 1
                            );
                          } else {
                            _cartController.removeFromCart(cartItem);
                          }
                        },
                      ),
                      
                      // Jumlah
                      Text(
                        '${cartItem.quantity}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      
                      // Tombol Tambah Kuantitas
                      IconButton(
                        icon: Icon(Icons.add_circle_outline),
                        onPressed: () {
                          _cartController.updateCartItemQuantity(
                            cartItem, 
                            cartItem.quantity + 1
                          );
                        },
                      ),
                      
                      // Tombol Hapus
                      IconButton(
                        icon: Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () {
                          _cartController.removeFromCart(cartItem);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckoutSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Obx(() => Text(
                    'Rp ${_cartController.totalPrice.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
            ],
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Implementasi checkout
              ScaffoldMessenger.of(Get.context!).showSnackBar(
                SnackBar(
                  content: Text('Checkout process coming soon'),
                  backgroundColor: Colors.blue,
                ),
              );
            },
            child: Text(
              'Checkout',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 50),
            ),
          ),
        ],
      ),
    );
  }
}