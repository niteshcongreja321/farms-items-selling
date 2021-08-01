import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:project_farm_shop/helper/themes.dart';
import 'package:project_farm_shop/views/cart/cart-item.dart';
import 'package:project_farm_shop/views/cart/cart.dart';
import 'package:transparent_image/transparent_image.dart';

class CartWidget extends StatelessWidget {
  final CartItem item;
  final CartModel cart;
  const CartWidget({Key? key, required this.item, required this.cart})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        child: Container(
          decoration: BoxDecoration(
              color: Themes.brownLight2,
              borderRadius: BorderRadius.circular(8)),
          child: ListTile(
              leading: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage, image: item.image),
              title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                SizedBox(
                  width: 100,
                  child: Text(
                    '${item.name}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Spacer(),
                Text('${item.quantity}'),
                Spacer(),
                Text('₹${item.price}'),
              ])),
        ),
        secondaryActions: <Widget>[
          IconSlideAction(
            // caption: 'Delete',
            color: Colors.red,
            // icon: Icons.delete,
            iconWidget: SvgPicture.asset('assets/icons/icon-trash.svg',
                color: Colors.white),
            onTap: () => cart.remove(item),
          ),
          // IconSlideAction(
          //   caption: 'Share',
          //   color: Colors.indigo,
          //   icon: Icons.share,
          //   onTap: () => _showSnackBar('Share'),
          // ),
        ]);
  }
}
