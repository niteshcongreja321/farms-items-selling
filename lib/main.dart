import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_farm_shop/helper/themes.dart';
import 'package:project_farm_shop/services/auth.dart';
import 'package:project_farm_shop/services/db.dart';
import 'package:project_farm_shop/views/auth/form-model.dart';
import 'package:project_farm_shop/views/products/product-model.dart';
import 'package:project_farm_shop/views/products/product-view.dart';
import 'package:provider/provider.dart';

import 'onboarding.dart';
import 'routes/routes.dart';
import 'views/cart/cart.dart';
import 'views/undefined/undefined.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => CartModel()),
    ChangeNotifierProvider(create: (context) => ProductModel()),
    ChangeNotifierProvider(create: (context) => Quantity()),
    ChangeNotifierProvider(create: (context) => FormModel()),
    ChangeNotifierProvider(create: (context) => OnBoardingModel()),
    Provider(create: (_) => DatabaseService()),
    Provider(create: (_) => AuthService()),
    StreamProvider<User?>.value(
        value: FirebaseAuth.instance.authStateChanges(), initialData: null)
  ], child: MaterialApp(debugShowCheckedModeBanner: false, home: MyApp())));
}

class MyApp extends StatelessWidget {
  final navigatorKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        navigatorKey: navigatorKey,
        title: 'Project 2',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Themes.brown,
          accentColor: Themes.brown,
          primaryIconTheme: IconThemeData(color: Themes.brown),
          textTheme: GoogleFonts.latoTextTheme(),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Themes.brownLight),
                borderRadius: BorderRadius.circular(8)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Themes.brown),
                borderRadius: BorderRadius.circular(8)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Themes.brownLight),
                borderRadius: BorderRadius.circular(8)),
            errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(8)),
            focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(8)),
          ),
        ),
        onGenerateRoute: Routes.generateRoute,
        onUnknownRoute: (settings) => MaterialPageRoute(
            builder: (context) => UndefinedView(
                  name: settings.name!,
                )),
        initialRoute: Routes.root);
  }
}
