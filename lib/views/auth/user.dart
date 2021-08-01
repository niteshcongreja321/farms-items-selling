import 'package:cloud_firestore/cloud_firestore.dart';

class FUser {
  String? uid;
  String? displayName;
  String? email;
  int? phoneNumber;
  List<Address>? address;
  List<String>? favorites;

  FUser(
      {this.uid,
      this.displayName,
      this.phoneNumber,
      this.email,
      this.address,
      this.favorites});

  FUser.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    displayName = json['displayName'];
    phoneNumber = json['phoneNumber'];
    email = json['email'];
    if (json['address'] != null) {
      address = [];
      json['address'].forEach((v) {
        address!.add(new Address.fromJson(v));
      });
    }
  }

  factory FUser.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    print(doc.id);
    List<Address> addressList = [];
    List.from(data['address']).forEach((element) {
      Address _address = Address.fromJson(element);
      addressList.add(_address);
    });

    return FUser(
        uid: doc.id,
        displayName: data['displayName'] ?? '',
        phoneNumber: data['phoneNumber'] ?? '',
        email: data['email'],
        address: addressList,
        favorites: List.from(data['favorites'] ?? []));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['displayName'] = this.displayName;
    data['email'] = this.email;
    data['phoneNumber'] = this.phoneNumber;
    if (this.address != null) {
      data['address'] = this.address!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Address {
  String? state;
  String? city;
  String? locality;
  int? pinCode;
  String? society;
  String? roomNo;
  String? wing;
  String? buildingName;

  Address(
      {this.state,
      this.city,
      this.locality,
      this.pinCode,
      this.society,
      this.roomNo,
      this.wing,
      this.buildingName});

  Address.fromJson(Map<String, dynamic> json) {
    state = json['state'];
    city = json['city'];
    locality = json['locality'];
    pinCode = json['pinCode'];
    society = json['society'];
    roomNo = json['roomNo'];
    wing = json['wing'];
    buildingName = json['buildingName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['state'] = this.state;
    data['city'] = this.city;
    data['locality'] = this.locality;
    data['pinCode'] = this.pinCode;
    data['society'] = this.society;
    data['roomNo'] = this.roomNo;
    data['wing'] = this.wing;
    return data;
  }
}
