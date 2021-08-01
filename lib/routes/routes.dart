import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_farm_shop/views/account/account-page.dart';
import 'package:project_farm_shop/views/account/profile-page.dart';
import 'package:project_farm_shop/views/auth/signup.dart';
import 'package:project_farm_shop/views/auth/reset-password.dart';
import 'package:project_farm_shop/views/auth/signin.dart';
import 'package:project_farm_shop/views/blog/blogs-page.dart';
import 'package:project_farm_shop/views/cart/cart-page.dart';
import 'package:project_farm_shop/views/checkout/checkout-page.dart';
import 'package:project_farm_shop/views/checkout/checkout.dart';
import 'package:project_farm_shop/views/checkout/shipping-page.dart';
import 'package:project_farm_shop/views/home/home-page.dart';
import 'package:project_farm_shop/views/home/main-page.dart';
import 'package:project_farm_shop/views/live-chat/live-chat.dart';
import 'package:project_farm_shop/views/order/orders-page.dart';
import 'package:project_farm_shop/views/products/favorite-page.dart';
import 'package:project_farm_shop/views/products/product-view.dart';
import 'package:project_farm_shop/views/products/product.dart';
import 'package:project_farm_shop/views/products/products-page.dart';
import 'package:project_farm_shop/views/search/search.dart';
import 'package:project_farm_shop/views/undefined/undefined.dart';
import 'package:project_farm_shop/views/checkout/payment-page.dart';
import 'package:project_farm_shop/widgets/order-confirm.dart';
import 'package:provider/provider.dart';

import '../onboarding.dart';

class Routes {
  static const String root = '/';
  static const String home = '/home';
  static const String signIn = '/login';
  static const String signUp = '/register';
  static const String resetPassword = '/reset-password';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String products = '/products';
  static const String productView = '/product/:id';
  static const String about = '/about';
  static const String contact = '/contact';
  static const String blogs = '/blogs';
  static const String shipping = '/shipping';
  static const String search = '/search';
  static const String account = '/account';
  static const String profile = '/profile';
  static const String favorites = '/favorites';
  static const String orders = '/orders';
  static const String orderConfirm = '/orderConfirm';
  static const String payment = '/payment';
  static const String liveChat = '/live-chat';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case root:
        return MaterialPageRoute(builder: (context) {
          var user = context.watch<User?>();
          if (user != null) {
            return MainPage();
          }
          return OnBoardingPage();
        });
      case signIn:
        return MaterialPageRoute(builder: (context) => SignInPage());
      case signUp:
        return MaterialPageRoute(builder: (context) => SignUpPage());
      case resetPassword:
        return MaterialPageRoute(builder: (context) => PasswordResetPage());
      case home:
        return MaterialPageRoute(builder: (context) => HomePage());
      case cart:
        return MaterialPageRoute(builder: (context) => CartPage());
      case checkout:
        return MaterialPageRoute(builder: (context) => CheckoutPage());
      case blogs:
        return MaterialPageRoute(builder: (context) => BlogsPage());
      case shipping:
        return MaterialPageRoute(
            builder: (context) =>
                ShippingPage(checkout: settings.arguments as Checkout));
      case search:
        return MaterialPageRoute(builder: (context) => SearchPage());
      case profile:
        return MaterialPageRoute(builder: (context) => ProfilePage());
      case favorites:
        return MaterialPageRoute(builder: (context) => FavoritePage());
      case account:
        return MaterialPageRoute(builder: (context) => AccountPage());
      case orders:
        return MaterialPageRoute(builder: (context) => OrdersPage());
      case liveChat:
        return MaterialPageRoute(builder: (context) => LiveChat());
      case orderConfirm:
        return MaterialPageRoute(
            builder: (context) =>
                OrderConfirm(orderId: settings.arguments as String));
      case payment:
        return MaterialPageRoute(builder: (context) {
          dynamic args = settings.arguments;
          return PaymentPage(
              content: args['content'], checkout: args['checkout']);
        });
      case products:
        return MaterialPageRoute(
            builder: (context) => ProductsPage(settings.arguments as String));
      case productView:
        return MaterialPageRoute(builder: (context) {
          Product product = settings.arguments as Product;
          return ProductViewPage(id: product.id, item: product);
        });
      default:
        return MaterialPageRoute(
            builder: (context) => UndefinedView(
                  name: settings.name!,
                ));
    }
  }
}
