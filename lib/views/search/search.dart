import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:project_farm_shop/helper/data.dart';
import 'package:project_farm_shop/helper/themes.dart';
import 'package:project_farm_shop/services/db.dart';
import 'package:project_farm_shop/views/products/product.dart';
import 'package:project_farm_shop/widgets/product.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Product> products = [];

  Future searchProducts(v) async {
    var db = Provider.of<DatabaseService>(context, listen: false);
    if (v.length > 3) {
      db.streamSearch(v).then((value) {
        setState(() {
          products = value;
        });
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please type product name.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(child: body(context)),
    );
  }

  body(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 36, vertical: 5),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(36),
                      bottomRight: Radius.circular(36)),
                  boxShadow: [
                    BoxShadow(
                        color: Themes.shadow4,
                        offset: Offset(0, 5),
                        blurRadius: 30)
                  ]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 60),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: 24),
                      Text('Search',
                          style: TextStyle(color: Themes.green, fontSize: 20)),
                      IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: SvgPicture.asset('assets/icons/icon-close.svg'))
                    ],
                  ),
                  SizedBox(height: 35),
                  TextFormField(
                    style: TextStyle(fontSize: 16),
                    textInputAction: TextInputAction.search,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      hintText: 'Search Products',
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(15),
                        child: SvgPicture.asset('assets/icons/icon-search.svg'),
                      ),
                    ),
                    onFieldSubmitted: (v) => searchProducts(v),
                  )
                ],
              ),
            ),
            Expanded(
                child: ListView(
              shrinkWrap: true,
              children: products.map((e) => ProductWidget(product: e)).toList(),
            )),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Text(StaticData.getFacts(),
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 14, fontStyle: FontStyle.italic))),
          ],
        ),
        products.length > 0
            ? SizedBox()
            : Center(
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: SvgPicture.asset(
                    'assets/images/search.svg',
                    fit: BoxFit.contain,
                    height: 120,
                  ),
                ),
              )
      ],
    );
  }
}
