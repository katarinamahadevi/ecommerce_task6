import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:get/get.dart';
import '../models/order_model.dart';

class CheckoutPage extends StatefulWidget {
  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  late WebViewController _controller;
  final Order order = Get.arguments; // Ambil data order dari arguments

  @override
  void initState() {
    super.initState();
    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted) // Izinkan JavaScript
          ..loadRequest(
            Uri.parse(order.midtransPaymentUrl),
          ); // Load halaman pembayaran
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pembayaran"), backgroundColor: Colors.green),
      body: WebViewWidget(controller: _controller),
    );
  }
}
