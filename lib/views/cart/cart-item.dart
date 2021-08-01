import 'dart:convert';

class CartItem {
  String id;
  String image;
  String name;
  int quantity;
  int price;
  // int discount;

  CartItem({
    required this.id,
    required this.image,
    required this.name,
    this.quantity = 1,
    required this.price,
    // required this.discount
  });

  factory CartItem.fromJson(Map<String, dynamic> jsonData) {
    return CartItem(
        id: jsonData['id'],
        image: jsonData['image'],
        name: jsonData['name'],
        quantity: jsonData['quantity'],
        price: jsonData['price']);
  }

  static Map<String, dynamic> toMap(CartItem cartItem) => {
        'id': cartItem.id,
        'image': cartItem.image,
        'name': cartItem.name,
        'quantity': cartItem.quantity,
        'price': cartItem.price
      };

  static String encode(List<CartItem> items) => json.encode(
        items
            .map<Map<String, dynamic>>((item) => CartItem.toMap(item))
            .toList(),
      );

  static List<CartItem> decode(String items) =>
      (json.decode(items) as List<dynamic>)
          .map<CartItem>((item) => CartItem.fromJson(item))
          .toList();

  void increaseQuantity() {
    quantity += 1;
  }

  void decreaseQuantity() {
    quantity -= 1;
  }
}
