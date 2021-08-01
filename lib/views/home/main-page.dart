import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:project_farm_shop/helper/themes.dart';
import 'package:project_farm_shop/views/cart/cart-page.dart';
import 'package:project_farm_shop/views/cart/cart.dart';

import 'package:project_farm_shop/views/order/orders-page.dart';
import 'package:provider/provider.dart';

import 'home-page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  List<Widget> _widgetOptions = <Widget>[HomePage(), CartPage(), OrdersPage()];

  @override
  Widget build(BuildContext context) {
    var cart = context.watch<CartModel>();
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedItemColor: Themes.brown,
        unselectedItemColor: Themes.textColor2,
        items: [
          BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/icons/icon-store.svg',
                  color:
                      _selectedIndex == 0 ? Themes.brown : Themes.textColor2),
              label: 'Home'),
          BottomNavigationBarItem(
              icon: Stack(children: [
                SvgPicture.asset('assets/icons/icon-cart.svg',
                    color:
                        _selectedIndex == 1 ? Themes.brown : Themes.textColor2),
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
              label: 'Cart'),
          BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/icons/icon-orders.svg',
                  color:
                      _selectedIndex == 3 ? Themes.brown : Themes.textColor2),
              label: 'Orders'),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
    );
  }
}
