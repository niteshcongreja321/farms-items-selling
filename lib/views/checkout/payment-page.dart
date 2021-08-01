import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_farm_shop/helper/themes.dart';
import 'package:project_farm_shop/routes/routes.dart';
import 'package:project_farm_shop/services/db.dart';
import 'package:project_farm_shop/views/cart/cart.dart';
import 'package:project_farm_shop/views/checkout/checkout.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentPage extends StatefulWidget {
  final String? content;
  final Checkout? checkout;
  const PaymentPage({Key? key, this.content, this.checkout}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  WebViewController? controller;
  String? content;

  var user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    var db = context.read<DatabaseService>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment', style: GoogleFonts.lato(color: Themes.brown)),
        backgroundColor: Colors.white,
        elevation: 8,
        centerTitle: true,
      ),
      body: WebView(
        javascriptMode: JavascriptMode.unrestricted,
        gestureNavigationEnabled: true,
        initialUrl: 'about:blank',
        onWebViewCreated: (WebViewController webViewController) {
          // _controller.complete(webViewController);
          controller = webViewController;
          controller?.loadUrl(
              Uri.dataFromString(widget.content!, mimeType: 'text/html')
                  .toString());
        },
        onProgress: (int progress) {
          // print("WebView is loading (progress : $progress%)");
        },
        onPageFinished: (_) {
          readResponse(db);
        },
      ),
    );
  }

  readResponse(DatabaseService db) async {
    setState(() {
      controller!
          .evaluateJavascript("document.documentElement.innerHTML")
          .then((value) async {
        // print(value);
        if (value.contains("PayU.onSuccess(")) {
          String orderId = '${DateTime.now().millisecondsSinceEpoch}';
          await db.saveOrder(user!.uid, widget.checkout!, orderId);
          Provider.of<CartModel>(context, listen: false).removeAll();

          Navigator.popAndPushNamed(context, Routes.orderConfirm,
              arguments: orderId);
        }
      });
    });
  }
}
