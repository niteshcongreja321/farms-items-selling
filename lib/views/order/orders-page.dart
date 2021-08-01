import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_farm_shop/helper/themes.dart';
import 'package:project_farm_shop/services/db.dart';
import 'package:project_farm_shop/views/order/order.dart';
import 'package:provider/provider.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  var user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:
              Text('Your Orders', style: GoogleFonts.lato(color: Themes.brown)),
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          elevation: 8),
      body: body(context),
    );
  }

  body(BuildContext context) {
    var db = context.read<DatabaseService>();
    return Stack(children: [
      Positioned(
        top: 100,
        left: 30,
        right: 30,
        child: Column(
          children: [
            SvgPicture.asset(
              'assets/images/orders.svg',
              height: 250,
              fit: BoxFit.contain,
            ),
            SizedBox(
              height: 20,
            ),
            Text('No Orders Found!',
                style: GoogleFonts.lato(color: Themes.brown, fontSize: 24)),
          ],
        ),
      ),
      Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(30),
        margin: EdgeInsets.only(bottom: 90),
        alignment: Alignment.center,
        child: FutureBuilder(
            future: db.getOrders(user?.uid),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Order> orders = snapshot.data as List<Order>;

                return ListView(
                  shrinkWrap: true,
                  children: orders
                      .map((e) => ListTile(
                            tileColor: Themes.brownLight2,
                            title: Text('Order ID #${e.orderId}',
                                style: TextStyle(fontSize: 16)),
                            trailing: SvgPicture.asset(
                                'assets/icons/icon-chevron.svg',
                                color: Themes.brown),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            // onTap: () =>
                            //     Navigator.pushNamed(context, Routes.account),
                          ))
                      .toList(),
                );
              }
              return Center(child: CircularProgressIndicator());
            }),
      )
    ]);
  }
}
