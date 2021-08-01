import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_farm_shop/helper/themes.dart';
import 'package:project_farm_shop/routes/routes.dart';
import 'package:project_farm_shop/views/checkout/checkout.dart';
import 'package:project_farm_shop/widgets/cart.dart';
import 'package:provider/provider.dart';

import 'cart.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.read<CartModel>().getSharedPref();
    context.watch<CartModel>().calculateCart();
    return Scaffold(
      appBar: AppBar(
          title: Text('Cart', style: GoogleFonts.lato(color: Themes.brown)),
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          actions: [
            TextButton(
                onPressed: () {
                  Provider.of<CartModel>(context, listen: false).removeAll();
                },
                child:
                    Text('Clear', style: GoogleFonts.lato(color: Themes.brown)))
          ]),
      body: Container(
        child: Consumer<CartModel>(builder: (context, cart, child) {
          var discount = cart.couponApplied ? 10 : 0;
          var total = cart.totalPrice - (cart.totalPrice * discount) / 100;
          return cart.items.length == 0
              ? Container(
                  color: Colors.white,
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/cart.jpg',
                          height: 250,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text('Your Cart is Empty',
                            style: GoogleFonts.lato(
                                color: Themes.brown, fontSize: 24)),
                      ],
                    ),
                  ),
                )
              : Column(
                  children: [
                    Padding(
                        padding: EdgeInsets.all(16),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text('Item'),
                              SizedBox(width: 45),
                              Text('Quantity'),
                              Text('Price'),
                            ])),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: ListView.separated(
                            itemBuilder: (context, index) {
                              return CartWidget(
                                  item: cart.items[index], cart: cart);
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return SizedBox(
                                height: 10,
                              );
                            },
                            itemCount: cart.items.length),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 25),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 20,
                                offset: Offset(0, 3),
                                color: Themes.shadow)
                          ]),
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Themes.brownLight2,
                                hintText: 'Enter coupon code'),
                          ),
                          cart.couponApplied
                              ? Align(
                                  alignment: Alignment.centerRight,
                                  child: Text('coupon code applied',
                                      style:
                                          TextStyle(color: Themes.greenDark)),
                                )
                              : SizedBox(),
                          SizedBox(height: 18),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Sub-total',
                                  style: TextStyle(
                                      color: Themes.textColor, fontSize: 16)),
                              Text('₹${cart.totalPrice}',
                                  style: TextStyle(
                                      color: Themes.brown, fontSize: 16))
                            ],
                          ),
                          SizedBox(height: 8),
                          cart.couponApplied
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Coupon code',
                                        style: TextStyle(
                                            color: Themes.textColor,
                                            fontSize: 16)),
                                    Text('$discount% off',
                                        style: TextStyle(
                                            color: Themes.brown, fontSize: 16))
                                  ],
                                )
                              : SizedBox(),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Total',
                                  style: TextStyle(
                                      color: Themes.textColor, fontSize: 24)),
                              Text('₹$total',
                                  style: TextStyle(
                                      color: Themes.green, fontSize: 24))
                            ],
                          ),
                          Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Text('Minimum order amount is ₹300')),
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 16),
                              child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                      primary: Themes.green,
                                      minimumSize: Size(double.infinity, 60),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(36))),
                                  icon: Icon(
                                    Icons.arrow_forward_rounded,
                                  ),
                                  label: Text('CHECKOUT',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold)),
                                  onPressed: cart.totalItem > 0
                                      ? () {
                                          if (total >= 300) {
                                            Checkout checkout = Checkout(
                                                price: total,
                                                items: cart.items);
                                            Navigator.pushNamed(
                                                context, Routes.shipping,
                                                arguments: checkout);
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                                        'You need to add more item of minimum ₹${300 - total}')));
                                          }
                                        }
                                      : null))
                        ],
                      ),
                    )
                  ],
                );
        }),
      ),
    );
  }

  Widget cartView() {
    return Container();
  }
}

//Card(
//     child: InkWell(
//   child: Row(
//     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     children: [
//       ClipRRect(
//         borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(8),
//             bottomLeft: Radius.circular(8)),
//         child: FadeInImage.memoryNetwork(
//           placeholder: kTransparentImage,
//           image: item.image,
//           width: 120,
//           height: 120,
//           fit: BoxFit.cover,
//         ),
//       ),
//       Expanded(
//           child: Container(
//               padding: EdgeInsets.only(
//                   top: 12, left: 25, bottom: 12),
//               child: Column(
//                 crossAxisAlignment:
//                     CrossAxisAlignment.start,
//                 children: [
//                   Text(item.name,
//                       style: Theme.of(context)
//                           .textTheme
//                           .headline6!
//                           .copyWith(
//                               fontWeight: FontWeight.bold)),
//                   SizedBox(height: 20),
//                   Text('₹${item.price}',
//                       style: Theme.of(context)
//                           .textTheme
//                           .subtitle1!
//                           .copyWith(
//                               fontWeight: FontWeight.bold))
//                 ],
//               ))),
//       Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ButtonBar(
//               children: [
//                 IconButton(
//                     onPressed: () => cart.decrease(item),
//                     icon: Icon(Icons.remove_rounded)),
//                 Text('${item.quantity}',
//                     style: Theme.of(context)
//                         .textTheme
//                         .subtitle1!
//                         .copyWith(
//                             fontWeight: FontWeight.bold)),
//                 IconButton(
//                     onPressed: () => cart.increase(item),
//                     icon: Icon(Icons.add_rounded))
//               ],
//             ),
//             IconButton(
//                 onPressed: () => cart.remove(item),
//                 icon: Icon(Icons.delete_rounded))
//           ]),
//     ],
//   ),
//   onTap: () {},
// ))
