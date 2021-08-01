class Pincode {
  final data = [
    {
      "officeName": "Mulund East S.O",
      "pincode": 400081,
      "districtName": "Mumbai",
      "stateName": "MAHARASHTRA"
    },
    {
      "officeName": "Mhada Colony S.O",
      "pincode": 400081,
      "districtName": "Mumbai",
      "stateName": "MAHARASHTRA"
    },
    {
      "officeName": "Mulund West S.O",
      "pincode": 400080,
      "districtName": "Mumbai",
      "stateName": "MAHARASHTRA"
    },
    {
      "officeName": "Nahur S.O",
      "pincode": 400080,
      "districtName": "Mumbai",
      "stateName": "MAHARASHTRA"
    },
    {
      "officeName": "Nehru Road S.O (Mumbai)",
      "pincode": 400080,
      "districtName": "Mumbai",
      "stateName": "MAHARASHTRA"
    },
    {
      "officeName": "Mulund Dd Road S.O",
      "pincode": 400080,
      "districtName": "Mumbai",
      "stateName": "MAHARASHTRA"
    },
    {
      "officeName": "S.B. Road S.O",
      "pincode": 400080,
      "districtName": "Mumbai",
      "stateName": "MAHARASHTRA"
    },
    {
      "officeName": "Bhandup West S.O",
      "pincode": 400078,
      "districtName": "Mumbai",
      "stateName": "MAHARASHTRA"
    },
    {
      "officeName": "J.M. Road S.O",
      "pincode": 400078,
      "districtName": "Mumbai",
      "stateName": "MAHARASHTRA"
    },
    {
      "officeName": "Bhandup Ind. Estate S.O",
      "pincode": 400078,
      "districtName": "Mumbai",
      "stateName": "MAHARASHTRA"
    },
    {
      "officeName": "P.H. Colony S.O",
      "pincode": 400078,
      "districtName": "Mumbai",
      "stateName": "MAHARASHTRA"
    },
    {
      "officeName": "Usha Nagar S.O",
      "pincode": 400078,
      "districtName": "Mumbai",
      "stateName": "MAHARASHTRA"
    },
    {
      "officeName": "Apna Bazar S.O",
      "pincode": 400610,
      "districtName": "Thane",
      "stateName": "MAHARASHTRA"
    },
    {
      "officeName": "Thane Bazar S.O",
      "pincode": 400601,
      "districtName": "Thane",
      "stateName": "MAHARASHTRA"
    },
    {
      "officeName": "Shrirangnagar B.O",
      "pincode": 400601,
      "districtName": "Thane",
      "stateName": "MAHARASHTRA"
    },
    {
      "officeName": "Thane H.O",
      "pincode": 400601,
      "districtName": "Thane",
      "stateName": "MAHARASHTRA"
    },
    {
      "officeName": "Tapasenagar B.O",
      "pincode": 400601,
      "districtName": "Thane",
      "stateName": "MAHARASHTRA"
    },
    {
      "officeName": "Thane R.S. S.O",
      "pincode": 400601,
      "districtName": "Thane",
      "stateName": "MAHARASHTRA"
    },
    {
      "officeName": "Kasarvadavali B.O",
      "pincode": 400601,
      "districtName": "Thane",
      "stateName": "MAHARASHTRA"
    },
    {
      "officeName": "Chitalsar Manpada B.O",
      "pincode": 400607,
      "districtName": "Thane",
      "stateName": "MAHARASHTRA"
    },
    {
      "officeName": "Sandozbaugh S.O",
      "pincode": 400607,
      "districtName": "Thane",
      "stateName": "MAHARASHTRA"
    }
  ];

  getData(int pincode) {
    return data
        .where((element) => element['pincode'] == pincode)
        .map((e) => Pincode.fromJson(e))
        .toList();
  }

  late String officeName;
  late int pincode;
  late String districtName;
  late String stateName;

  Pincode(
      {this.officeName = '',
      this.pincode = 0,
      this.districtName = '',
      this.stateName = ''});

  Pincode.fromJson(Map<String, dynamic> json) {
    officeName = json['officeName'];
    pincode = json['pincode'];
    districtName = json['districtName'];
    stateName = json['stateName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['officeName'] = this.officeName;
    data['pincode'] = this.pincode;
    data['districtName'] = this.districtName;
    data['stateName'] = this.stateName;
    return data;
  }
}
