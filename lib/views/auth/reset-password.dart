import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_farm_shop/helper/data.dart';
import 'package:project_farm_shop/helper/themes.dart';

class PasswordResetPage extends StatefulWidget {
  @override
  _PasswordResetPageState createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends State<PasswordResetPage> {
  FirebaseAuth auth = FirebaseAuth.instance;

  bool _isSubmitted = false;
  final _ctrlEmail = TextEditingController();

  void _passwordReset() async {
    setState(() => _isSubmitted = true);
    try {
      await auth.sendPasswordResetEmail(email: _ctrlEmail.text);
      setState(() => _isSubmitted = false);

      showSnackBar('We sent an email to ${_ctrlEmail.text} ' +
          'so you can pick your new password.');
    } on FirebaseAuthException catch (e) {
      setState(() => _isSubmitted = false);
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        showSnackBar('No user found!');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        showSnackBar('Invalid credentials!');
      } else {
        showSnackBar('Something went wrong!');
      }
    } catch (e) {
      setState(() => _isSubmitted = false);
      print(e);
    }
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(duration: Duration(seconds: 3), content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            icon: SvgPicture.asset('assets/icons/icon-arrow.svg',
                color: Themes.brown),
            onPressed: () => Navigator.pop(context)),
        title: Text('Forget Password',
            style: GoogleFonts.lato(color: Themes.brown)),
        elevation: 8,
      ),
      body: Container(
          padding: EdgeInsets.only(bottom: 30, left: 45, right: 45),
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(height: 80),
              SvgPicture.asset(
                'assets/images/forgot-password.svg',
                height: 150,
              ),
              SizedBox(height: 64),
              TextFormField(
                enabled: !_isSubmitted,
                controller: _ctrlEmail,
                textAlignVertical: TextAlignVertical.center,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Themes.brownLight2,
                    hintText: 'Enter registered email',
                    prefixIcon: Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: SvgPicture.asset('assets/icons/icon-mail.svg',
                          color: Themes.brown),
                    )),
              ),
              Spacer(),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Text(StaticData.getFacts(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14, fontStyle: FontStyle.italic))),
              Spacer(),
              _isSubmitted
                  ? Center(child: CircularProgressIndicator())
                  : Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Themes.green,
                              minimumSize: Size(double.infinity, 60),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(36))),
                          onPressed: () {
                            if (_ctrlEmail.text.trim().length > 0) {
                              _passwordReset();
                            } else {
                              showSnackBar('Please fill all fields!');
                            }
                          },
                          child: Text('SEND LINK',
                              style: GoogleFonts.lato(
                                  fontSize: 14, fontWeight: FontWeight.bold))))
            ],
          )),
      /*body: Stack(
        children: [
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                  padding: EdgeInsets.only(bottom: 30, left: 45, right: 45),
                  color: Colors.white,
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      TextFormField(
                        enabled: !_isSubmitted,
                        controller: _ctrlEmail,
                        textAlignVertical: TextAlignVertical.center,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            isDense: true,
                            hintText: 'Email',
                            prefixIcon: Padding(
                              padding: EdgeInsets.symmetric(vertical: 15),
                              child: SvgPicture.asset(
                                  'assets/icons/icon-mail.svg',
                                  color: Themes.brown),
                            )),
                      ),
                      SizedBox(height: 16),
                      _isSubmitted
                          ? Center(child: CircularProgressIndicator())
                          : SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                child: Text('Reset Password'),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.blueAccent,
                                  onPrimary: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: BorderSide(color: Colors.blueAccent),
                                  ),
                                ),
                                onPressed: () {
                                  if (_ctrlEmail.text.trim().length > 0) {
                                    _passwordReset();
                                  } else {
                                    showSnackBar('Please fill all fields!');
                                  }
                                },
                              ),
                            )
                    ],
                  )))
        ],
      ),*/
    );
  }
}
