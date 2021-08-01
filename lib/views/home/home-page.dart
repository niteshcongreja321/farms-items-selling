import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_farm_shop/helper/themes.dart';
import 'package:project_farm_shop/routes/routes.dart';
import 'package:project_farm_shop/services/auth.dart';
import 'package:project_farm_shop/services/db.dart';
import 'package:project_farm_shop/views/cart/cart.dart';
import 'package:project_farm_shop/views/categories/category.dart';
import 'package:project_farm_shop/views/products/product.dart';
import 'package:project_farm_shop/widgets/carousel.dart';
import 'package:project_farm_shop/widgets/category.dart';
import 'package:project_farm_shop/widgets/product.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var user = FirebaseAuth.instance.currentUser;

  categories() {
    var db = Provider.of<DatabaseService>(context);
    return FutureBuilder(
        future: db.streamCategories(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var categories = snapshot.data as List<Category>;
            return ExpansionTile(
                leading: SvgPicture.asset('assets/icons/icon-store.svg',
                    color: Themes.greenLight),
                title: Text('Shop by Category',
                    style: TextStyle(color: Themes.greenLight, fontSize: 18)),
                children: categories.map((cat) {
                  return ListTile(
                      leading: SizedBox(width: 24),
                      title: Text(
                        cat.name!,
                        style:
                            TextStyle(color: Themes.greenLight, fontSize: 16),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, Routes.products,
                            arguments: cat.name!);
                      });
                }).toList());
          }
          return ExpansionTile(
              leading: SvgPicture.asset('assets/icons/icon-store.svg',
                  color: Themes.greenLight),
              title: Text('Shop by Category',
                  style: TextStyle(color: Themes.greenLight, fontSize: 18)),
              children: []);
        });
  }

  String _greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    }
    if (hour < 17) {
      return 'Good Afternoon';
    }
    return 'Good Evening';
  }

  getUserData() async {
    var db = Provider.of<DatabaseService>(context, listen: false);
    var sharedPref = await SharedPreferences.getInstance();
    db.getUser(user?.uid).then((fUser) {
      sharedPref.setString('user', fUser.toJson().toString());
      sharedPref.setStringList('favorites', fUser.favorites!);
    });
  }

  @override
  void initState() {
    super.initState();
    getUserData();
    Provider.of<CartModel>(context, listen: false).getSharedPref();
  }

  @override
  Widget build(BuildContext context) {
    var db = context.watch<DatabaseService>();
    var cart = context.watch<CartModel>();
    

    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/images/logo.png', height: 48),
        backgroundColor: Colors.white,
        elevation: 8,
        actions: [
          IconButton(
              onPressed: () => Navigator.pushNamed(context, Routes.search),
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
      drawer: Drawer(
        child: drawer(context),
      ),
      body: home(context, db),
    );
  }

  drawer(BuildContext context) {
    
    return Column(
      children: [
        DrawerHeader(
            child: Container(
          padding: EdgeInsets.all(24),
          child: Image.asset('assets/images/logo.png'),
        )),
        Expanded(
          child: ListView(padding: const EdgeInsets.only(top: 10.0), children: [
            ListTile(
                leading: SvgPicture.asset('assets/icons/icon-store.svg',
                    color: Themes.greenLight),
                title: Text(
                  'Home',
                  style: TextStyle(color: Themes.greenLight, fontSize: 18),
                ),
                onTap: () {
                  Navigator.pop(context);
                }),
            // Profile
            ListTile(
                leading: SvgPicture.asset('assets/icons/icon-account.svg',
                    color: Themes.greenLight),
                title: Text(
                  'My Profile',
                  style: TextStyle(color: Themes.greenLight, fontSize: 18),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, Routes.profile);
                }),
            // Category
            categories(),
            // Blogs
            ListTile(
                leading: SvgPicture.asset('assets/icons/icon-store.svg',
                    color: Themes.greenLight),
                title: Text(
                  'Blogs',
                  style: TextStyle(color: Themes.greenLight, fontSize: 18),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, Routes.blogs);
                }),
            // Follow
            ExpansionTile(
                leading: SvgPicture.asset('assets/icons/icon-account.svg',
                    color: Themes.greenLight),
                title: Text(
                  'Follow us',
                  style: TextStyle(color: Themes.greenLight, fontSize: 18),
                ),
                children: [
                  ListTile(
                      leading: SizedBox(width: 24),
                      title: Text(
                        'Facebook page',
                        style:
                            TextStyle(color: Themes.greenLight, fontSize: 16),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      }),
                  ListTile(
                      leading: SizedBox(width: 24),
                      title: Text(
                        'Instagram page',
                        style:
                            TextStyle(color: Themes.greenLight, fontSize: 16),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      })
                ]),
            // More
            ExpansionTile(
                leading: SvgPicture.asset('assets/icons/icon-store.svg',
                    color: Themes.greenLight),
                title: Text(
                  'More',
                  style: TextStyle(color: Themes.greenLight, fontSize: 18),
                ),
                children: [
                  ListTile(
                      leading: SizedBox(width: 24),
                      title: Text(
                        'Return & refund policy',
                        style:
                            TextStyle(color: Themes.greenLight, fontSize: 16),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      }),
                  ListTile(
                      leading: SizedBox(width: 24),
                      title: Text(
                        'Terms & conditions',
                        style:
                            TextStyle(color: Themes.greenLight, fontSize: 16),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      })
                ]),
          ]),
        ),
        Divider(
          color: Themes.brownLight,
          thickness: 0.5,
        ),
        ListTile(
            leading: SizedBox(),
            title: Text(
              'Sign out',
              style: TextStyle(color: Themes.textColor, fontSize: 18),
            ),
            onTap: () {
              Navigator.pop(context);
              context.read<AuthService>().signOut(context);
            }),
      ],
    );
  }

  home(BuildContext context, DatabaseService db) {
    var user = FirebaseAuth.instance.currentUser;
    return Container(
        child: ListView(children: [
      Padding(
          padding: EdgeInsets.all(16),
          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Text('${_greeting()},',
                style: TextStyle(color: Themes.green, fontSize: 16)),
            SizedBox(width: 3),
            Text('${user?.displayName ?? ''}',
                style: TextStyle(color: Themes.brown, fontSize: 16))
          ])),
      FutureBuilder(
          future: db.streamCategories(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var categories = snapshot.data as List<Category>;
              if (categories.length > 0) {
                return CategoryWidget(items: categories);
              }
            }
            return SizedBox();
          }),
      SizedBox(height: 15),
      FutureBuilder(
          future: db.streamBannersHome(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                var banners = snapshot.data as List<String>;
                return CarouselWidget(items: banners);
              }
            }
            return SizedBox();
          }),
      SizedBox(height: 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(width: 16),
          Text('Vegetables',
              style: GoogleFonts.dancingScript(
                  fontSize: 28, color: Themes.greenDark)),
          Spacer(),
          OutlinedButton(
              onPressed: () => Navigator.pushNamed(context, Routes.products,
                  arguments: 'Vegetables'),
              style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Themes.greenDark, width: 1),
                      borderRadius: BorderRadius.circular(16))),
              child: Text(
                'View All',
                style: TextStyle(color: Themes.greenDark),
              )),
          SizedBox(width: 16),
        ],
      ),
      Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: latestVegetables(context, db)),
      SizedBox(height: 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(width: 16),
          Text('Fruits',
              style: GoogleFonts.dancingScript(
                  fontSize: 28, color: Themes.greenDark)),
          Spacer(),
          OutlinedButton(
              onPressed: () => Navigator.pushNamed(context, Routes.products,
                  arguments: 'Fruits'),
              style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Themes.greenDark, width: 1),
                      borderRadius: BorderRadius.circular(16))),
              child: Text(
                'View All',
                style: TextStyle(color: Themes.greenDark),
              )),
          SizedBox(width: 16),
        ],
      ),
      Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: latestFruits(context, db)),
      SizedBox(height: 30)
    ]));
  }

  Widget latestVegetables(BuildContext context, DatabaseService db) {
    var orientation = MediaQuery.of(context).orientation;
    return StreamBuilder(
        stream: db.streamNewProducts('Vegetables'),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Product> products = snapshot.data as List<Product>;
            if (products.length > 0) {
              return GridView.count(
                shrinkWrap: true,
                crossAxisCount: orientation == Orientation.portrait ? 2 : 4,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                physics: NeverScrollableScrollPhysics(),
                children: products.map((item) {
                  return ProductWidget(product: item);
                }).toList(),
              );
            }
          }
          return SizedBox();
        });
  }

  Widget latestFruits(BuildContext context, DatabaseService db) {
    var orientation = MediaQuery.of(context).orientation;
    return StreamBuilder(
        stream: db.streamNewProducts('Fruits'),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Product> products = snapshot.data as List<Product>;
            if (products.length > 0) {
              return GridView.count(
                shrinkWrap: true,
                crossAxisCount: orientation == Orientation.portrait ? 2 : 4,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                physics: NeverScrollableScrollPhysics(),
                children: products.map((item) {
                  return ProductWidget(product: item);
                }).toList(),
              );
            }
          }
          return SizedBox();
        });
  }
}
