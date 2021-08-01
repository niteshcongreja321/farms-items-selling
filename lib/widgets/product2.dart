import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:project_farm_shop/helper/themes.dart';
import 'package:project_farm_shop/routes/routes.dart';
import 'package:project_farm_shop/views/cart/cart-item.dart';
import 'package:project_farm_shop/views/products/product-model.dart';
import 'package:project_farm_shop/views/products/product.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class ProductWidget2 extends StatelessWidget {
  final Product product;

  ProductWidget2({required this.product});

  @override
  Widget build(BuildContext context) {
    // var isInCart = context.select<CartModel, bool>((cart) =>
    //     cart.items.where((element) => element.id == item.id).isNotEmpty);
    var model = context.watch<ProductModel>();
    var discountPrice = (product.price * (100 - product.discount)) / 100;

    var cartItem = model.cartItem(product.id);

    CartItem item = CartItem(
        id: product.id,
        name: product.name,
        image: product.image,
        price: discountPrice.toInt());

    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          Expanded(
            child: InkWell(
                child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 30,
                              offset: Offset(0, 5),
                              color: Themes.shadow3)
                        ]),
                    child: Column(children: [
                      Expanded(
                          child: FadeInImage.memoryNetwork(
                              placeholder: kTransparentImage,
                              image: product.image,
                              height: 200,
                              fit: BoxFit.fitWidth)),
                      SizedBox(height: 10),
                      Text(product.name,
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(fontSize: 16, color: Themes.greenDark)),
                      // SizedBox(height: 3),
                      // Text('Quantity: ${product.}',
                      //     textAlign: TextAlign.center,
                      //     style: TextStyle(fontSize: 12, color: Themes.greenDark)),
                      SizedBox(height: 10),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            product.discount > 0
                                ? Text('₹${product.price}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle2!
                                        .copyWith(
                                            color: Colors.red,
                                            decoration:
                                                TextDecoration.lineThrough))
                                : SizedBox(),
                            SizedBox(width: 10),
                            Text('₹${discountPrice.round()}',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(
                                      color: Themes.green,
                                    )),
                          ])
                      // ElevatedButton(
                      //     onPressed: isInCart
                      //         ? null
                      //         : () {
                      //             var cart = context.read<CartModel>();
                      //             cart.add(item);
                      //           },
                      //     child: isInCart
                      //         ? Icon(Icons.check, semanticLabel: 'ADDED')
                      //         : Text('ADD'))
                    ])),
                onTap: () => Navigator.pushNamed(context, Routes.productView,
                    arguments: product)),
          ),
          SizedBox(height: 15),
          Container(
              decoration: BoxDecoration(
                  color: Themes.brownLight,
                  borderRadius: BorderRadius.circular(8)),
              child: ButtonBar(
                  buttonPadding: EdgeInsets.zero,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        onPressed: cartItem != null
                            ? cartItem.quantity > 0
                                ? () => model.decrease(cartItem)
                                : null
                            : null,
                        icon: Icon(Icons.remove_rounded,
                            size: 16, color: Themes.brown)),
                    Text(
                      cartItem != null ? cartItem.quantity.toString() : '0',
                      style: TextStyle(fontSize: 19, color: Themes.brown),
                      textAlign: TextAlign.center,
                    ),
                    IconButton(
                        onPressed: () => model.increase(cartItem ?? item),
                        icon: Icon(Icons.add_rounded,
                            size: 16, color: Themes.brown)),
                  ]))
        ],
      ),
    );
  }
}
