import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  String? id;
  String? name;
  String? image;
  Timestamp? timestamp;

  Category({this.id, this.name, this.image, this.timestamp});

  factory Category.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Category(
      id: doc.id,
      name: data['name'] ?? '',
      image: data['image'] ?? '',
      timestamp: data['timestamp'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['image'] = this.image;
    data['timestamp'] = this.timestamp = Timestamp.now();
    return data;
  }
}
