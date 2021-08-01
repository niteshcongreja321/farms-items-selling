import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_farm_shop/helper/themes.dart';
import 'package:project_farm_shop/routes/routes.dart';
import 'package:project_farm_shop/services/db.dart';
import 'package:project_farm_shop/views/cart/cart.dart';
import 'package:project_farm_shop/views/products/product.dart';
import 'package:project_farm_shop/widgets/product.dart';
import 'package:provider/provider.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  var user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    var cart = context.watch<CartModel>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Favorites', style: GoogleFonts.lato(color: Themes.brown)),
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        elevation: 8,
        actions: [
          IconButton(
              onPressed: () {},
              icon: SvgPicture.asset('assets/icons/icon-refresh.svg',
                  color: Themes.brown)),
          IconButton(
              onPressed: () {},
              icon: SvgPicture.asset('assets/icons/icon-search.svg',
                  color: Themes.brown)),
          IconButton(
              icon: Stack(children: [
                SvgPicture.asset('assets/icons/icon-cart.svg',
                    color: Themes.brown),
                cart.totalItem > 0
                    ? Positioned(
                        right: 0,
                        child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(1),
                            constraints: BoxConstraints(
                              minWidth: 12,
                              minHeight: 12,
                            ),
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(6)),
                            child: Text(cart.totalItem.toString(),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 8))))
                    : SizedBox()
              ]),
              onPressed: () => Navigator.pushNamed(context, Routes.cart))
        ],
      ),
      body: body(context),
    );
  }

  body(BuildContext context) {
    var db = context.watch<DatabaseService>();
    // var cart = context.watch<CartModel>();
    var orientation = MediaQuery.of(context).orientation;

    return FutureBuilder(
        future: db.streamFavorites(user!.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  '${snapshot.error} occurred',
                  style: TextStyle(fontSize: 18),
                ),
              );
            } else if (snapshot.hasData) {
              var products = snapshot.data as List<Product>;
              return Container(
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 16),
                  child: Column(children: [
                    Expanded(
                      child: products.length > 0
                          ? GridView(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount:
                                    orientation == Orientation.portrait ? 2 : 4,
                                crossAxisSpacing: 5.0,
                                mainAxisSpacing: 5.0,
                              ),
                              children: products.map((item) {
                                return ProductWidget(product: item);
                              }).toList())
                          : Container(
                              color: Colors.white,
                              child: Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/fav.jpg',
                                      height: 250,
                                      fit: BoxFit.contain,
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text('No Favorites added!',
                                        style: GoogleFonts.lato(
                                            color: Themes.brown, fontSize: 24)),
                                  ],
                                ),
                              ),
                            ),
                    ),
                    // Padding(
                    //     padding:
                    //         EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                    //     child: ElevatedButton.icon(
                    //         style: ElevatedButton.styleFrom(
                    //             primary: Themes.green,
                    //             minimumSize: Size(double.infinity, 60),
                    //             shape: RoundedRectangleBorder(
                    //                 borderRadius: BorderRadius.circular(36))),
                    //         onPressed: products.length < 1 ? null : () {},
                    //         icon: SvgPicture.asset(
                    //           'assets/icons/icon-cart.svg',
                    //           color: products.length > 0
                    //               ? Colors.white
                    //               : Colors.grey,
                    //         ),
                    //         label: Text('ADD TO CART',
                    //             style: GoogleFonts.lato(
                    //                 fontWeight: FontWeight.bold))))
                  ]));
            }
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}
