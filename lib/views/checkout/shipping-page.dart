import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_farm_shop/helper/constant.dart';
import 'package:project_farm_shop/helper/themes.dart';
import 'package:project_farm_shop/routes/routes.dart';
import 'package:project_farm_shop/services/db.dart';
import 'package:project_farm_shop/views/auth/user.dart';
import 'package:project_farm_shop/views/cart/cart.dart';
import 'package:project_farm_shop/views/checkout/checkout.dart';
import 'package:provider/provider.dart';

class ShippingPage extends StatefulWidget {
  final Checkout checkout;
  const ShippingPage({Key? key, required this.checkout}) : super(key: key);

  @override
  _ShippingPageState createState() => _ShippingPageState();
}

class _ShippingPageState extends State<ShippingPage> {
  var currentUser = FirebaseAuth.instance.currentUser;
  FUser user = FUser();

  Future getUserDetails() async {
    var db = Provider.of<DatabaseService>(context, listen: false);
    db.getUser(currentUser?.uid).then((value) => setState(() => user = value));
  }

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    var cart = context.read<CartModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Shipping Details',
            style: GoogleFonts.lato(color: Themes.brown)),
        backgroundColor: Colors.white,
        elevation: 8,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total', style: TextStyle(fontSize: 24)),
                Text('₹${cart.totalPrice}',
                    style: TextStyle(fontSize: 24, color: Themes.green))
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Contact information',
              style: TextStyle(fontSize: 20, color: Themes.brown),
            ),
            SizedBox(height: 20),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(30),
              color: Themes.brownLight2,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Full Name',
                        style:
                            TextStyle(color: Themes.textColor, fontSize: 16)),
                    Text(user.displayName ?? '',
                        style: TextStyle(color: Themes.brown, fontSize: 16)),
                    SizedBox(height: 20),
                    Text('Email',
                        style:
                            TextStyle(color: Themes.textColor, fontSize: 16)),
                    Text(user.email ?? '',
                        style: TextStyle(color: Themes.brown, fontSize: 16)),
                    SizedBox(height: 20),
                    Text('Phone number',
                        style:
                            TextStyle(color: Themes.textColor, fontSize: 16)),
                    Text('${user.phoneNumber}',
                        style: TextStyle(color: Themes.brown, fontSize: 16)),
                  ]),
            ),
            SizedBox(height: 20),
            Text(
              'Shipping Address',
              style: TextStyle(fontSize: 20, color: Themes.brown),
            ),
            SizedBox(height: 20),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(30),
              color: Themes.brownLight2,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    //   ${user.address?[0].buildingName ?? ''},
                    Text(
                        '${user.address?[0].roomNo},'
                        '${user.address?[0].wing}, ${user.address?[0].society}, '
                        '${user.address?[0].locality}, ${user.address?[0].city}, '
                        '${user.address?[0].state},\nPin - ${user.address?[0].pinCode}, ',
                        style: TextStyle(color: Themes.textColor, fontSize: 16))
                  ]),
            ),
            Spacer(),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Themes.green,
                        minimumSize: Size(double.infinity, 60),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(36))),
                    onPressed: () => startPayment(),
                    child: Text('GO FOR PAYMENT',
                        style: GoogleFonts.lato(
                            fontSize: 14, fontWeight: FontWeight.bold))))
          ],
        ),
      ),
    );
  }

  startPayment() async {
    Map<String, String> map = {
      "txnid": "txn_${DateTime.now().millisecondsSinceEpoch}",
      "amount": widget.checkout.price.toString(),
      "firstname": '${user.displayName}',
      "email": '${user.email}',
      "productinfo": "SnowCorp"
    };

    try {
      Dio dio = new Dio();
      dio.options.headers['content-Type'] = 'application/json';
      Response response =
          await dio.post('${Constants.baseUrl}/hash', data: map);

      openBrowser(response.data['hash'], map);
    } catch (e) {
      print(e);
    }
  }

  openBrowser(String hash, Map<String, String> map) async {
    print('Opening browser');

    var html = """
    <html>
    <head>
      <title>PayU Money</title>
      <script src='https://code.jquery.com/jquery-3.6.0.min.js'></script>
    </head>
    <body onload="document.f.submit();">
      <p>Please wait...</p>
      <form id="f" name="f" method="post" action="https://secure.payu.in/_payment">
        <input type="hidden" name="key" value="X8H3UBax" />
        <input type="hidden" name="hash" value="$hash" />
        <input type="hidden" name="txnid" value="${map['txnid']}" />
        <input type="hidden" name="amount" value="${map['amount']}" />
        <input type="hidden" name="firstname" value="${map['firstname']}" />
        <input type="hidden" name="email" value="${map['email']}" />
        <input type="hidden" name="productinfo" value="${map['productinfo']}" />
        <input type="hidden" name="phone" value="${user.phoneNumber}" />
        <input type="hidden" name="service_provider" value="payu_paisa" />
        <input type="hidden" name="surl" value="https://www.payumoney.com/mobileapp/payumoney/success.php" />
      </form>
    </body>
    </html>
    """;

    Navigator.pushNamed(context, Routes.payment,
        arguments: {'content': html, 'checkout': widget.checkout});
  }
}
