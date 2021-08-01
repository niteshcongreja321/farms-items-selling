import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  String? id;
  String? orderId;

  Order({this.id, this.orderId});

  factory Order.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    print(doc.id);
    // List<CartItem> addressList = [];
    // List.from(data['address']).forEach((element) {
    //   CartItem _address = CartItem.from(element);
    //   addressList.add(_address);
    // });

    return Order(
      id: doc.id,
      orderId: data['orderId'] ?? '',
    );
  }
}
