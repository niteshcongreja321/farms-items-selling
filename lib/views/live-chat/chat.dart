import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  String? id;
  bool isSelf;
  String? uid;
  String to;
  String? message;
  Timestamp? timestamp;

  Chat(
      {this.id,
      this.isSelf = true,
      this.uid,
      this.to = 'admin',
      this.message,
      this.timestamp});

  factory Chat.fromFirestore(DocumentSnapshot doc, String uid) {
    Map data = doc.data() as Map;
    return Chat(
      id: doc.id,
      isSelf: data['uid'] == uid,
      uid: data['uid'] ?? '',
      to: data['to'] ?? '',
      message: data['message'] ?? '',
      timestamp: data['timestamp'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['to'] = this.to;
    data['message'] = this.message;
    data['timestamp'] = this.timestamp = Timestamp.now();
    return data;
  }
}
