import 'package:collection/collection.dart';

import 'package:flutter/material.dart';
import 'package:project_farm_shop/views/cart/cart-item.dart';

class ProductModel extends ChangeNotifier {
  final List<CartItem> _items = [];

  UnmodifiableListView<CartItem> get items => UnmodifiableListView(_items);
  int get totalItem => _items.length;

  CartItem? cartItem(String id) {
    return _items.firstWhereOrNull((element) => element.id == id);
  }

  // void add(CartItem item) {
  //   _items.add(item);
  //   notifyListeners();
  // }

  // void remove(CartItem item) {
  //   _items.remove(item);
  //   notifyListeners();
  // }

  void removeAll() {
    _items.clear();
    notifyListeners();
  }

  void increase(CartItem item) {
    if (_items.contains(cartItem(item.id))) {
      item.increaseQuantity();
      _items[_items.indexWhere((element) => element.id == item.id)] = item;
    } else {
      _items.add(item);
    }

    notifyListeners();
  }

  void decrease(CartItem item) {
    item.decreaseQuantity();
    if (item.quantity == 0) {
      _items.removeWhere((element) => element.id == item.id);
    } else {
      _items[_items.indexWhere((element) => element.id == item.id)] = item;
    }
    notifyListeners();
  }

  void updateItem() {}
}
