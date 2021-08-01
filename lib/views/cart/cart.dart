import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cart-item.dart';

class CartModel extends ChangeNotifier {
  /// Internal, private state of the cart.
  List<CartItem> _items = [];
  int totalPrice = 0;

  /// An unmodifiable view of the items in the cart.
  UnmodifiableListView<CartItem> get items => UnmodifiableListView(_items);

  /// The current total price of all items (assuming all items cost $42).
  int get totalItem => _items.length;
  bool get couponApplied => false;

  /// Adds [item] to cart. This and [removeAll] are the only ways to modify the
  /// cart from the outside.
  void add(CartItem item) {
    _items.add(item);
    saveSharedPref();

    notifyListeners();
  }

  void remove(CartItem item) {
    _items.removeAt(_items.indexWhere((element) => element.id == item.id));
    saveSharedPref();

    notifyListeners();
  }

  /// Add all item list
  void addAll(List<CartItem> items) {
    _items.addAll(items);
    saveSharedPref();

    notifyListeners();
  }

  /// Removes all items from the cart.
  void removeAll() {
    _items.clear();
    deleteSharedPref();

    notifyListeners();
  }

  void update(CartItem item) {
    _items[_items.indexWhere((element) => element.id == item.id)] = item;

    saveSharedPref();
    notifyListeners();
  }

  void increase(CartItem item) {
    item.increaseQuantity();
    notifyListeners();
  }

  void decrease(CartItem item) {
    item.decreaseQuantity();
    if (item.quantity == 0) {
      _items.remove(item);
    }
    notifyListeners();
  }

  void calculateCart() {
    totalPrice = 0;
    if (items.length > 0) {
      items.forEach((element) {
        totalPrice += element.price * element.quantity;
      });
    }
  }

  void saveSharedPref() async {
    print(CartItem.encode(items));

    var pref = await SharedPreferences.getInstance();
    pref.setString('cart', CartItem.encode(items));
  }

  void getSharedPref() async {
    var pref = await SharedPreferences.getInstance();
    var cartPref = pref.getString('cart');
    _items = cartPref != null ? CartItem.decode(cartPref) : [];
    notifyListeners();
  }

  void deleteSharedPref() async {
    var pref = await SharedPreferences.getInstance();
    pref.remove('cart');
  }

  void removeSharedPref() async {
    var pref = await SharedPreferences.getInstance();
    pref.remove('cart');
  }
}
