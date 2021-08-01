import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:project_farm_shop/helper/themes.dart';
import 'package:project_farm_shop/routes/routes.dart';

class OrderConfirm extends StatefulWidget {
  final String orderId;
  const OrderConfirm({Key? key, required this.orderId}) : super(key: key);

  @override
  _OrderConfirmState createState() => _OrderConfirmState();
}

class _OrderConfirmState extends State<OrderConfirm> {
  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 3), () {
      Navigator.pushNamedAndRemoveUntil(context, Routes.root, (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/images/confirmation.svg'),
              SizedBox(height: 45),
              Text('Order placed.\nYour order number is',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, color: Themes.textColor2)),
              SizedBox(height: 10),
              Text('#${widget.orderId}',
                  style: TextStyle(fontSize: 30, color: Themes.green)),
            ]),
      ),
    );
  }
}
