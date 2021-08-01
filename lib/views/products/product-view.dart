import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_farm_shop/helper/themes.dart';
import 'package:project_farm_shop/routes/routes.dart';
import 'package:project_farm_shop/services/db.dart';
import 'package:project_farm_shop/views/cart/cart-item.dart';
import 'package:project_farm_shop/views/cart/cart.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transparent_image/transparent_image.dart';

import 'product.dart';

class ProductViewPage extends StatefulWidget {
  final String id;
  final Product item;
  const ProductViewPage({required this.id, required this.item});

  @override
  _ProductViewPageState createState() => _ProductViewPageState();
}

class _ProductViewPageState extends State<ProductViewPage> {
  var user = FirebaseAuth.instance.currentUser;
  late Product item;

  bool isFavorite = false;

  checkFavorite() async {
    var sharedPref = await SharedPreferences.getInstance();
    var favorites = sharedPref.getStringList('favorites');

    setState(() {
      isFavorite = favorites!.contains(item.id);
      print('isFavorite => $isFavorite');
      print(favorites);
    });
  }

  @override
  void initState() {
    super.initState();
    item = widget.item;

    checkFavorite();
  }

  @override
  Widget build(BuildContext context) {
    var db = context.watch<DatabaseService>();
    var cart = context.watch<CartModel>();
    context.read<Quantity>().value = 1;

    var discountPrice = (item.price * (100 - item.discount)) / 100;

    var isInCart = context.select<CartModel, bool>((cart) =>
        cart.items.where((element) => element.id == item.id).isNotEmpty);

    return Scaffold(
        bottomNavigationBar: Container(
          color: Colors.transparent,
          height: 50,
          child: InkWell(
            child: MaterialButton(
              onPressed: () {
                var cart = context.read<CartModel>();
                var quantity = context.read<Quantity>();

                CartItem cartItem = CartItem(
                    id: item.id,
                    name: item.name,
                    image: item.image,
                    // discount: item.discount,
                    quantity: quantity.value,
                    price: discountPrice.toInt());

                if (isInCart) {
                  cart.update(cartItem);
                } else {
                  cart.add(cartItem);
                }

                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Product successfully added!')));
              },
              color: Themes.green,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/icon-cart.svg',
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'ADD TO CART',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.white,
          brightness: Brightness.dark,
          title: Text(item.name, style: GoogleFonts.lato(color: Themes.brown)),
          actions: [
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
                onPressed: () => Navigator.pushNamed(context, Routes.cart)),
            IconButton(
                onPressed: () {
                  isFavorite
                      ? db
                          .removeFavorites(user!.uid, item.id)
                          .then((value) => setState(() => isFavorite = value))
                      : db
                          .saveFavorites(user!.uid, item)
                          .then((value) => setState(() => isFavorite = value));
                },
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_outline,
                  color: isFavorite ? Themes.red : Colors.brown,
                ))
          ],
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          FadeInImage.memoryNetwork(
            placeholder: kTransparentImage,
            image: item.image,
            height: 300,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.fill,
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Quantity',
                            style:
                                TextStyle(fontSize: 20, color: Themes.green)),
                        SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                              color: Themes.brownLight,
                              borderRadius: BorderRadius.circular(8)),
                          child: Consumer<Quantity>(
                              builder: (context, quantity, child) {
                            return ButtonBar(
                                buttonPadding: EdgeInsets.zero,
                                children: [
                                  IconButton(
                                      onPressed: quantity.value > 1
                                          ? () => quantity.decrement()
                                          : null,
                                      icon: Icon(Icons.remove_rounded,
                                          size: 16, color: Themes.brown)),
                                  Text(
                                    quantity.value.toString(),
                                    style: TextStyle(
                                        fontSize: 20, color: Themes.brown),
                                    textAlign: TextAlign.center,
                                  ),
                                  IconButton(
                                      onPressed: () => quantity.increment(),
                                      icon: Icon(Icons.add_rounded,
                                          size: 16, color: Themes.brown)),
                                ]);
                          }),
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Text('Price: ',
                                style: TextStyle(
                                    fontSize: 20, color: Themes.green)),
                            Text('₹${item.price}',
                                style: TextStyle(
                                    fontSize: 24,
                                    color: item.discount > 0
                                        ? Themes.red
                                        : Themes.green,
                                    decoration: item.discount > 0
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none))
                          ],
                        ),
                        item.discount > 0
                            ? Text('₹${discountPrice.toInt()}',
                                style: TextStyle(
                                    fontSize: 20, color: Themes.green))
                            : SizedBox()
                      ],
                    )
                  ],
                ),
                SizedBox(height: 30),
                Text('Description',
                    style: TextStyle(fontSize: 20, color: Themes.green)),
                SizedBox(height: 15),
                Text(item.description ?? '',
                    style: TextStyle(fontSize: 16, color: Themes.textColor)),
              ],
            ),
          ),
          // Expanded(
          //   child: ListView(shrinkWrap: true, children: [

          //     Padding(
          //       padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          //       child: Row(children: [
          //         Text(item.name,
          //             style: Theme.of(context).textTheme.headline6),
          //         // IconButton(onPressed: () {
          //         //   print()
          //         // }, icon: Icon(Icons.share_rounded))
          //       ]),
          //     ),
          //     Padding(
          //       padding: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
          //       child: Row(children: [
          //         item.discount > 0
          //             ? Text('₹${item.price}',
          //                 style: Theme.of(context)
          //                     .textTheme
          //                     .subtitle1!
          //                     .copyWith(
          //                         color: Colors.red,
          //                         decoration: TextDecoration.lineThrough))
          //             : SizedBox(),
          //         SizedBox(width: 10),
          //         Text('₹${discountPrice.round()}',
          //             style: Theme.of(context).textTheme.subtitle1),
          //       ]),
          //     ),
          //     Divider(height: 1, color: Colors.green[300]),
          //     Padding(
          //       padding: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
          //       child: Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: [
          //             Text('Quantity',
          //                 style: Theme.of(context)
          //                     .textTheme
          //                     .subtitle1!
          //                     .copyWith(fontSize: 20)),
          // Consumer<Quantity>(
          //     builder: (context, quantity, child) {
          //   return ButtonBar(children: [
          //     OutlinedButton(
          //         style: OutlinedButton.styleFrom(
          //             minimumSize: Size(48, 48)),
          //         onPressed: quantity.value > 1
          //             ? () => quantity.decrement()
          //             : null,
          //         child: Icon(Icons.remove_rounded)),
          //     SizedBox(
          //         width: 32,
          //         child: Text(
          //           quantity.value.toString(),
          //           style: TextStyle(fontSize: 24),
          //           textAlign: TextAlign.center,
          //         )),
          //     OutlinedButton(
          //         style: OutlinedButton.styleFrom(
          //             minimumSize: Size(48, 48)),
          //         onPressed: () => quantity.increment(),
          //         child: Icon(Icons.add_rounded)),
          //   ]);
          // })
          //           ]),
          //     ),
          //     Divider(height: 1, color: Colors.green[300]),
          //     Padding(
          //         padding:
          //             EdgeInsets.symmetric(vertical: 5, horizontal: 16),
          //         child: Text(
          //           item.description ?? '',
          //           style: Theme.of(context).textTheme.subtitle1,
          //         )),
          //   ]),
          // ),
          // ConstrainedBox(
          //     constraints:
          //         BoxConstraints(minWidth: double.infinity, minHeight: 48),
          //     child: ElevatedButton(
          //         onPressed: () {
          // var cart = context.read<CartModel>();
          // var quantity = context.read<Quantity>();
          // cart.add(CartItem(
          //     id: item.id,
          //     name: item.name,
          //     image: item.image,
          //     discount: item.discount,
          //     quantity: quantity.value,
          //     price: item.price));
          //         },
          //         child: Text('ADD TO CART')))
        ])));
  }
}

class Quantity with ChangeNotifier {
  int value = 1;

  void increment() {
    value += 1;
    notifyListeners();
  }

  void decrement() {
    value -= 1;
    notifyListeners();
  }
}
