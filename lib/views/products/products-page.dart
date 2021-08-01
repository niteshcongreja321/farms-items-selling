import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_farm_shop/helper/themes.dart';
import 'package:project_farm_shop/routes/routes.dart';
import 'package:project_farm_shop/services/db.dart';
import 'package:project_farm_shop/views/cart/cart.dart';
import 'package:project_farm_shop/widgets/product2.dart';
import 'package:provider/provider.dart';

import 'product-model.dart';
import 'product.dart';

class ProductsPage extends StatelessWidget {
  final String category;

  ProductsPage(this.category);

  @override
  Widget build(BuildContext context) {
    var db = context.watch<DatabaseService>();
    var cart = context.watch<CartModel>();
    return Scaffold(
      appBar: AppBar(
        title: Text(category, style: GoogleFonts.lato(color: Themes.brown)),
        brightness: Brightness.dark,
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
      body: StreamProvider<List<Product>>.value(
          initialData: [],
          value: db.streamProducts(category),
          catchError: (context, error) => [],
          child: ProductList()),
    );
  }
}

class ProductList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var products = context.watch<List<Product>>();
    var model = context.watch<ProductModel>();
    var cart = context.read<CartModel>();
    var orientation = MediaQuery.of(context).orientation;

    return Container(
        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 16),
        child: Column(children: [
          Expanded(
              child: StaggeredGridView.countBuilder(
            shrinkWrap: true,
            crossAxisCount: orientation == Orientation.portrait ? 2 : 4,
            itemCount: products.length,
            itemBuilder: (BuildContext context, int index) {
              return ProductWidget2(product: products[index]);
            },
            staggeredTileBuilder: (int index) => StaggeredTile.count(1, 1.8),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          )),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 16),
              child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      primary: Themes.green,
                      minimumSize: Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(36))),
                  onPressed: model.totalItem > 0
                      ? () {
                          model.items.forEach((e) {
                            // var isInCart = context.select<CartModel, bool>(
                            //     (cart) => cart.items
                            //         .where((element) => element.id == e.id)
                            //         .isNotEmpty);

                            var isInCart = cart.items
                                .where((element) => element.id == e.id)
                                .isNotEmpty;
                            isInCart ? cart.update(e) : cart.add(e);
                          });

                          // cart.addAll(model.items);
                          // model.removeAll();

                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Products successfully added!')));
                        }
                      : null,
                  icon: SvgPicture.asset(
                    'assets/icons/icon-cart.svg',
                    color: model.totalItem > 0 ? Colors.white : Colors.grey,
                  ),
                  label: Text('ADD TO CART',
                      style: GoogleFonts.lato(fontWeight: FontWeight.bold))))
        ]));
  }
}
