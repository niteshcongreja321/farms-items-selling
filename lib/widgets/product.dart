import 'package:flutter/material.dart';
import 'package:project_farm_shop/helper/themes.dart';
import 'package:project_farm_shop/routes/routes.dart';
import 'package:project_farm_shop/views/cart/cart-item.dart';
import 'package:project_farm_shop/views/products/product.dart';
import 'package:transparent_image/transparent_image.dart';

class ProductWidget extends StatelessWidget {
  final Product product;

  ProductWidget({required this.product});

  @override
  Widget build(BuildContext context) {
    CartItem item = CartItem(
        id: product.id,
        name: product.name,
        image: product.image,
        // discount: product.discount,
        price: product.price);

    

    var discountPrice = (product.price * (100 - product.discount)) / 100;

    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(color: Themes.greenLight, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image: product.image,
                      width: 120,
                      height: 120,
                      fit: BoxFit.contain)),
              SizedBox(height: 10),
              Text(product.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Themes.greenDark)),
              SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                product.discount > 0
                    ? Text('₹${item.price}',
                        style: Theme.of(context).textTheme.subtitle2!.copyWith(
                            color: Colors.red,
                            decoration: TextDecoration.lineThrough))
                    : SizedBox(),
                SizedBox(width: 10),
                Text('₹${discountPrice.round()}',
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
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
            ]),
        onTap: () => Navigator.pushNamed(context, Routes.productView,
            arguments: product),
      ),
    );
  }
}
