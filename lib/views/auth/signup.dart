import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_farm_shop/helper/data.dart';
import 'package:project_farm_shop/helper/pincodes.dart';
import 'package:project_farm_shop/helper/themes.dart';
import 'package:project_farm_shop/routes/routes.dart';
import 'package:project_farm_shop/views/auth/user.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;

  bool _passwordVisible = false;
  bool _isSubmitted = false;

  final _ctrlName = TextEditingController();
  final _ctrlEmail = TextEditingController();
  final _ctrlMobile = TextEditingController();
  final _ctrlPassword = TextEditingController();
  final _ctrlOtp = TextEditingController();

  final formKey = new GlobalKey<FormState>();

  FUser fUser = FUser();
  Address address = Address();
  List<Pincode> pinCodes = [];
  List<String> localities = [];
  List<String> societies = [];

  PageController controller = PageController();

  Future registerWithEmailAndPassword() async {
    setState(() => _isSubmitted = true);
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _ctrlEmail.text, password: _ctrlPassword.text);
      User? user = userCredential.user;
      user?.updateProfile(displayName: _ctrlName.text);

      if (user != null) {
        fUser.uid = user.uid;
        await db.collection('users').doc(user.uid).set(fUser.toJson());
      }

      setState(() => _isSubmitted = false);
    } on FirebaseAuthException catch (e) {
      setState(() => _isSubmitted = false);
      if (e.code == 'weak-password') {
        showSnackBar('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        showSnackBar('The account already exists for that email.');
      }
    } catch (e) {
      setState(() => _isSubmitted = false);
      print(e);
    }
  }

  Future getPinCode(pincode) async {
    List<Pincode> _pinCodes = await Pincode().getData(int.parse(pincode));

    setState(() {
      pinCodes = _pinCodes;
      address.state = pinCodes[0].stateName;
      address.city = pinCodes[0].districtName;
      address.locality = null;
      localities = _pinCodes.map((e) => e.officeName).toList();
      localities = _pinCodes.map((e) => e.officeName).toList();
    });
  }

  TextEditingController _pincodeCtr = TextEditingController();

  //  Phone Auth
  // _verifyMobile(v) async {
  //   auth.verifyPhoneNumber(
  //       phoneNumber: '+91$v',
  //       timeout: Duration(seconds: 60),
  //       verificationCompleted: (phoneAuthCredential) {},
  //       verificationFailed: (error) {},
  //       codeSent: (verificationId, forceResendingToken) {},
  //       codeAutoRetrievalTimeout: (verificationId) {});
  // }

  Future getSociety() async {
    societies.addAll(StaticData.sunday);
    societies.addAll(StaticData.tuesday);
    societies.addAll(StaticData.thursday);
    societies.addAll(StaticData.friday);
    societies.addAll(StaticData.saturday);

    societies = [
      ...{...societies}
    ];
  }

  String? pincodeValue;
  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(duration: Duration(seconds: 3), content: Text(message)));
  }

  void togglePassword() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }

  @override
  void initState() {
    super.initState();
    auth.authStateChanges().listen((User? user) {
      if (user != null) {
        print('User is signed in!');
        Navigator.of(context)
            .pushNamedAndRemoveUntil(Routes.root, (route) => false);
      }
    });

    getSociety();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: EdgeInsets.only(bottom: 30, left: 45, right: 45),
          color: Colors.white,
          child: PageView(
            controller: controller,
            scrollDirection: Axis.horizontal,
            physics: NeverScrollableScrollPhysics(),
            children: [registerForm(), pincodeForm(), addressForm()],
          )),
    );
  }

  pincodeForm() {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Please Verify Your Location'),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              enabled: true,
              controller: _pincodeCtr,
              textAlignVertical: TextAlignVertical.center,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                filled: true,
                fillColor: Themes.brownLight2,
                hintText: 'Enter Pincode',
                prefixIcon: Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Icon(
                    Icons.location_city,
                    color: Themes.brown,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: Get.width / 2,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    primary: Themes.green,
                    minimumSize: Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(
                        side: BorderSide(color: Themes.brown, width: 0.5),
                        borderRadius: BorderRadius.circular(36))),
                onPressed: () {
                  if (_pincodeCtr.text == "400081" ||
                      _pincodeCtr.text == "400080" ||
                      _pincodeCtr.text == "400078" ||
                      _pincodeCtr.text == "400610" ||
                      _pincodeCtr.text == "400601" ||
                      _pincodeCtr.text == "400607") {
                    getPinCode(_pincodeCtr.text);
                    address.pinCode = int.parse(_pincodeCtr.text);
                    controller.jumpToPage(2);
                  } else {
                    showAlertDialog(context);
                  }
                },
                icon: Icon(
                  Icons.arrow_forward_rounded,
                ),
                label: FittedBox(
                  child: Text(
                    'Next',
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              width: Get.width / 2,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    primary: Themes.brownLight2,
                    minimumSize: Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(
                        side: BorderSide(color: Themes.brown, width: 0.5),
                        borderRadius: BorderRadius.circular(36))),
                onPressed: () {
                  controller.jumpToPage(0);
                },
                icon: Icon(Icons.arrow_back, color: Themes.brown),
                label: FittedBox(
                  child: Text(
                    'Back',
                    style: GoogleFonts.lato(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Themes.brown),
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  registerForm() {
    return ListView(
      children: [
        SizedBox(height: 25),
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: SvgPicture.asset('assets/icons/icon-close.svg')),
        ),
        SizedBox(height: 20),
        SvgPicture.asset(
          'assets/images/register.svg',
          height: 120,
        ),
        SizedBox(height: 16),
        Text(
          'Create Account',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24, color: Themes.brown),
        ),
        SizedBox(height: 64),

        TextFormField(
          enabled: !_isSubmitted,
          controller: _ctrlName,
          textAlignVertical: TextAlignVertical.center,
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
              filled: true,
              fillColor: Themes.brownLight2,
              hintText: 'Full Name',
              prefixIcon: Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: SvgPicture.asset('assets/icons/icon-account.svg',
                    color: Themes.brown),
              )),
          onChanged: (v) {
            setState(() {
              fUser.displayName = v;
            });
          },
        ),
        SizedBox(height: 10),
        TextFormField(
          enabled: !_isSubmitted,
          controller: _ctrlEmail,
          textAlignVertical: TextAlignVertical.center,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
              filled: true,
              fillColor: Themes.brownLight2,
              hintText: 'Email',
              prefixIcon: Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: SvgPicture.asset('assets/icons/icon-mail.svg',
                    color: Themes.brown),
              )),
          onChanged: (v) {
            setState(() {
              fUser.email = v;
            });
          },
        ),
        SizedBox(height: 10),
        TextFormField(
          enabled: !_isSubmitted,
          controller: _ctrlPassword,
          obscureText: !_passwordVisible,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
              filled: true,
              fillColor: Themes.brownLight2,
              hintText: 'Password',
              prefixIcon: Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: SvgPicture.asset('assets/icons/icon-padlock.svg',
                    color: Themes.brown),
              ),
              suffixIcon: IconButton(
                  onPressed: () => togglePassword(),
                  icon: Icon(
                      _passwordVisible
                          ? Icons.visibility_rounded
                          : Icons.visibility_off_rounded,
                      size: 20,
                      color: Theme.of(context).accentColor))),
        ),
        SizedBox(height: 10),
        TextFormField(
          enabled: !_isSubmitted,
          controller: _ctrlMobile,
          textAlignVertical: TextAlignVertical.center,
          keyboardType: TextInputType.phone,
          maxLength: 10,
          decoration: InputDecoration(
            filled: true,
            fillColor: Themes.brownLight2,
            hintText: 'Mobile number',
            prefixIcon: Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Icon(Icons.phone, color: Themes.brown),
            ),
          ),
          onChanged: (v) {
            setState(() {
              fUser.phoneNumber = int.parse(v);
              // if (v.length == 10) {
              // _isShowOtp = true;
              // _verifyMobile(v);
              // }
            });
          },
        ),
        SizedBox(height: 16),
        // _isShowOtp ? otpVerify() : SizedBox(),
        Row(
          children: [
            _isSubmitted
                ? Expanded(child: Center(child: CircularProgressIndicator()))
                : Expanded(
                    child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            primary: Themes.green,
                            minimumSize: Size(double.infinity, 60),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(36))),
                        onPressed: () {
                          if (_ctrlName.text.trim().length > 0 &&
                              _ctrlEmail.text.trim().length > 0 &&
                              _ctrlPassword.text.trim().length > 0 &&
                              _ctrlMobile.text.trim().length == 10) {
                            controller.jumpToPage(1);
                          }
                        },
                        icon: Icon(Icons.arrow_forward_rounded),
                        label: Text('NEXT',
                            style: GoogleFonts.lato(
                                fontSize: 14, fontWeight: FontWeight.bold))),
                  ),
            SizedBox(
              width: 10,
            ),
            // Login Button
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    primary: Themes.brownLight2,
                    minimumSize: Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(
                        side: BorderSide(color: Themes.brown, width: 0.5),
                        borderRadius: BorderRadius.circular(36))),
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_forward_rounded, color: Themes.brown),
                label: Text(
                  'LOGIN',
                  style: GoogleFonts.lato(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Themes.brown),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  addressForm() {
    return Form(
        key: formKey,
        child: ListView(
          children: [
            SizedBox(height: 74),
            Align(
                alignment: Alignment.center,
                child: Text('Your Address', style: TextStyle(fontSize: 24))),
            SizedBox(height: 54),
            DropdownButtonFormField<String>(
                items: societies
                    .map((e) =>
                        DropdownMenuItem<String>(child: Text(e), value: e))
                    .toList(),
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Themes.brownLight2,
                    hintText: 'Society Name'),
                value: address.society,
                onChanged: (v) {
                  setState(() {
                    address.society = v;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select society name';
                  }
                  return null;
                }),
            address.society != "Other"
                ? SizedBox.shrink()
                : Column(
                    children: [
                      SizedBox(height: 16),
                      TextFormField(
                        enabled: true,
                        //  controller: _pincodeCtr,
                        textAlignVertical: TextAlignVertical.center,

                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Themes.brownLight2,
                          hintText: 'Enter Society',
                        ),
                      ),
                    ],
                  ),
            SizedBox(height: 16),
            TextFormField(
                initialValue: address.roomNo,
                enabled: !_isSubmitted,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Themes.brownLight2,
                  hintText: 'Room Number',
                ),
                onChanged: (v) {
                  setState(() {
                    address.roomNo = v;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please type room number';
                  }
                  return null;
                }),
            SizedBox(height: 16),
            TextFormField(
                initialValue: address.wing,
                enabled: !_isSubmitted,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Themes.brownLight2,
                  hintText: 'Wing',
                ),
                onChanged: (v) {
                  setState(() {
                    address.wing = v;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please type wing';
                  }
                  return null;
                }),
            SizedBox(height: 16),
            TextFormField(
                initialValue: address.buildingName,
                enabled: !_isSubmitted,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Themes.brownLight2,
                  hintText: 'Building Name',
                ),
                onChanged: (v) {
                  setState(() {
                    address.buildingName = v;
                  });
                }),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Themes.brownLight2,
                  hintText: 'Locality'),
              value: address.locality,
              onChanged: (v) {
                setState(() {
                  address.locality = v;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select locality';
                }
                return null;
              },
              items: localities
                  .map(
                      (e) => DropdownMenuItem<String>(value: e, child: Text(e)))
                  .toList(),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                    flex: 1,
                    child: MaterialButton(
                      onPressed: () {
                        controller.jumpToPage(1);
                      },
                      color: Themes.brownLight2,
                      textColor: Colors.white,
                      child: Icon(Icons.arrow_back, color: Themes.brown),
                      padding: EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(36),
                        ),
                      ),
                    )),
                SizedBox(
                  width: 10,
                ),
                _isSubmitted
                    ? Expanded(
                        flex: 3,
                        child: Center(child: CircularProgressIndicator()))
                    : Expanded(
                        flex: 3,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              primary: Themes.green,
                              minimumSize: Size(double.infinity, 60),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(36))),
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              setState(() {
                                fUser.address = [];
                                fUser.address!.add(address);
                              });

                              print(fUser.toJson());

                              registerWithEmailAndPassword();
                            } else {
                              showSnackBar('Please fill all fields!');
                            }
                          },
                          icon: Icon(Icons.arrow_forward_rounded),
                          label: Text(
                            'CREATE \nACCOUNT',
                            style: GoogleFonts.lato(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
              ],
            )
          ],
        ));
  }

  otpVerify() {
    return Row(children: [
      Expanded(
          child: TextFormField(
        controller: _ctrlOtp,
        decoration: InputDecoration(
            hintText: 'OTP',
            filled: true,
            fillColor: Themes.brownLight2,
            prefixIcon: Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: SvgPicture.asset('assets/icons/icon-account.svg',
                  color: Themes.brown),
            )),
      )),
      SizedBox(height: 20),
      TextButton(onPressed: () {}, child: Text('Verify'))
    ]);
  }
}

showAlertDialog(BuildContext context) {
  // Create button
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.of(context, rootNavigator: true).pop();
    },
  );

  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Alert"),
    content: Text(
        "Sorry we are not operating at this location currently, we will be updating you if we do soon. Try using some other Pincode"),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
