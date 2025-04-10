import 'package:ecommerce_task6/controller/order_controller.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:get/get.dart';

class CheckoutPage extends StatefulWidget {
  final String paymentUrl;

  const CheckoutPage({Key? key, required this.paymentUrl}) : super(key: key);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  late WebViewController _controller;
  bool _isLoading = true;
  bool hasNavigated = false;
  final OrderController _orderController = Get.find<OrderController>();

  @override
  void initState() {
    super.initState();

    print("➡️ Loading Payment URL: ${widget.paymentUrl}");

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              _isLoading = progress < 100;
            });
          },
          onPageStarted: (String url) {
            print("⏳ Page started loading: $url");
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            print("✅ Page finished loading: $url");
            setState(() {
              _isLoading = false;
            });

            _handleNavigation(url);
          },
          onNavigationRequest: (NavigationRequest request) {
            if (!_isMidtransUrl(request.url) && !hasNavigated) {
              hasNavigated = true;
              Get.offAllNamed('/orders');
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          onWebResourceError: (WebResourceError error) {
            print('❌ WebView failed: ${error.description}');

            if (error.description.contains('net::ERR_NAME_NOT_RESOLVED') ||
                error.description.contains('webpage not available') ||
                error.description.contains('ERR_UNKNOWN_URL_SCHEME')) {
              Get.back(); 
              Future.delayed(Duration(milliseconds: 300), () {
                _showPaymentSuccessDialog();
              });
            } else {
              Get.snackbar(
                'Error',
                'Payment page could not load: ${error.description}',
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  bool _isMidtransUrl(String url) {
    return url.toLowerCase().contains('midtrans');
  }

  void _handleNavigation(String url) {
    if (url.contains('success')) {
      Get.back(); // Close WebView
      Future.delayed(Duration(milliseconds: 300), () {
        _showPaymentSuccessDialog();
      });
    } else if (url.contains('transaction_status=cancel') ||
        url.contains('status_code=202')) {
      _showPaymentFailedDialog();
    } else if (!_isMidtransUrl(url) && !hasNavigated) {
      hasNavigated = true;
      Get.offAllNamed('/orders');
    }
  }

  void _showPaymentSuccessDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('Payment Successful'),
        content: Text('Your payment has been processed successfully.'),
        actions: [
          TextButton(
            onPressed: () async {
              Get.back(); // Close dialog
              await Future.delayed(Duration(milliseconds: 300));
              Get.offAllNamed('/orders');
              print('➡️ Navigating to /orders');
            },
            child: Text(
              'OK',
              style: TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void _showPaymentFailedDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('Payment Failed'),
        content: Text('Your payment could not be processed. Please try again.'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // Close dialog
              Get.back(); // Close WebView
            },
            child: Text('OK'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Complete Payment'), centerTitle: true),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading) Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
