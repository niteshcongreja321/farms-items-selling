import 'package:cloud_firestore/cloud_firestore.dart';

class Blog {
  String? id;
  String? title;
  String? image;
  Timestamp? timestamp;

  Blog({this.id, this.title, this.image, this.timestamp});

  factory Blog.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Blog(
      id: doc.id,
      title: data['title'] ?? '',
      image: data['image'] ?? '',
      timestamp: data['timestamp'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['image'] = this.image;
    data['timestamp'] = this.timestamp = Timestamp.now();
    return data;
  }
}
