import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  late String id;
  late String image;
  late String name;
  late String? description;
  late int price;
  late int discount;
  late Timestamp timestamp;

  Product(
      {required this.id,
      required this.image,
      required this.name,
      this.description,
      required this.price,
      required this.discount,
      required this.timestamp});

  factory Product.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Product(
      id: doc.id,
      image: data['image'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      discount: data['discount'] ?? 0,
      price: data['price'] ?? 0,
      timestamp: data['timestamp'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['name'] = this.name;
    data['description'] = this.description;
    data['discount'] = this.discount;
    data['price'] = this.price;
    data['timestamp'] = this.timestamp = Timestamp.now();
    return data;
  }
}
