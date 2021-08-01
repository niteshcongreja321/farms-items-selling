import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_farm_shop/helper/themes.dart';
import 'package:project_farm_shop/routes/routes.dart';
import 'package:project_farm_shop/services/auth.dart';
import 'package:project_farm_shop/widgets/google-sign-in.dart';
import 'package:provider/provider.dart';

import 'form-model.dart';

class SignInPage extends StatelessWidget {
  final _ctrlEmail = TextEditingController();
  final _ctrlPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var fModel = context.watch<FormModel>();
    var auth = context.read<AuthService>();

    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(Routes.root, (route) => false);
      }
    });

    return Scaffold(
      // appBar: AppBar(
      //     brightness: Brightness.dark,
      //     leading: IconButton(
      //         icon: Icon(Icons.arrow_back),
      //         onPressed: () => Navigator.pop(context))),
      body: Container(
          padding: EdgeInsets.only(bottom: 30, left: 45, right: 45),
          color: Colors.white,
          child: ListView(
            children: [
              SizedBox(height: 90),
              SvgPicture.asset(
                'assets/images/login.svg',
                height: 120,
              ),
              SizedBox(height: 16),
              Text(
                'Login',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, color: Themes.brown),
              ),
              SizedBox(height: 64),
              TextFormField(
                enabled: !fModel.isSubmitted,
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
              ),
              SizedBox(height: 10),
              TextFormField(
                enabled: !fModel.isSubmitted,
                controller: _ctrlPassword,
                obscureText: !fModel.passwordVisible,
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
                        onPressed: () =>
                            Provider.of<FormModel>(context, listen: false)
                                .togglePassword(),
                        icon: Icon(
                            fModel.passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            size: 20,
                            color: Theme.of(context).accentColor))),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  child: Text('Forgot password?',
                      style: TextStyle(color: Themes.brown)),
                  style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.resetPassword);
                  },
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  fModel.isSubmitted
                      ? Expanded(
                          child: Center(child: CircularProgressIndicator()))
                      : Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                primary: Themes.green,
                                minimumSize: Size(double.infinity, 60),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(36))),
                            onPressed: () {
                              if (_ctrlEmail.text.trim().length > 0 &&
                                  _ctrlPassword.text.trim().length > 0) {
                                fModel.submitted(true);
                                auth
                                    .signInWithEmailAndPassword(
                                        _ctrlEmail.text, _ctrlPassword.text)
                                    .then((v) {
                                  fModel.submitted(false);
                                  fModel.showSnackBar(context, v);
                                });
                              } else {
                                fModel.showSnackBar(
                                    context, 'Please fill all fields!');
                              }
                            },
                            icon: Icon(Icons.arrow_forward_rounded),
                            label: Text(
                              'LOGIN',
                              style: GoogleFonts.lato(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          primary: Themes.brownLight2,
                          minimumSize: Size(double.infinity, 60),
                          shape: RoundedRectangleBorder(
                              side: BorderSide(color: Themes.brown, width: 0.5),
                              borderRadius: BorderRadius.circular(36))),
                      onPressed: () {
                        Navigator.pushNamed(context, Routes.signUp);
                      },
                      icon: Icon(Icons.arrow_forward_rounded,
                          color: Themes.brown),
                      label: FittedBox(
                        child: Text(
                          'CREATE \nACCOUNT',
                          style: GoogleFonts.lato(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Themes.brown),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16),
              ConstrainedBox(
                constraints: BoxConstraints(minWidth: double.infinity),
                child: GoogleSignInButton(),
              ),
              SizedBox(height: 10),
              // ConstrainedBox(
              //   constraints: BoxConstraints(minWidth: double.infinity),
              //   child: ElevatedButton(
              //     child: Text('SIGN IN WITH PHONE',
              //         style: TextStyle(fontSize: 18)),
              //     style: ElevatedButton.styleFrom(
              //       primary: Colors.blueAccent,
              //       padding: EdgeInsets.all(12),
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(8),
              //       ),
              //     ),
              //     onPressed: () {
              //       showModalBottomSheet(
              //           context: context,
              //           isScrollControlled: true,
              //           builder: (context) {
              //             return Container(
              //               margin: EdgeInsets.only(bottom: 16),
              //               padding: EdgeInsets.only(
              //                   top: 16,
              //                   left: 16,
              //                   right: 16,
              //                   bottom:
              //                       MediaQuery.of(context).viewInsets.bottom),
              //               child: Column(
              //                   mainAxisSize: MainAxisSize.min,
              //                   children: [
              //                     Text(
              //                       'Sign in with Phone Number',
              //                       style: TextStyle(fontSize: 24),
              //                     ),
              //                     SizedBox(
              //                       height: 12,
              //                     ),
              //                     TextFormField(
              //                         controller: _ctrlPhone,
              //                         keyboardType: TextInputType.phone,
              //                         maxLength: 10,
              //                         decoration: InputDecoration(
              //                             labelText: 'Phone number',
              //                             border: OutlineInputBorder(
              //                                 borderRadius:
              //                                     BorderRadius.circular(20)))),
              //                     SizedBox(height: 12),
              //                     ConstrainedBox(
              //                         constraints: BoxConstraints(
              //                             minWidth: double.infinity),
              //                         child: ElevatedButton(
              //                           child: Text('CONTINUE',
              //                               style: TextStyle(fontSize: 18)),
              //                           style: ElevatedButton.styleFrom(
              //                             primary: Colors.blueAccent,
              //                             padding: EdgeInsets.all(12),
              //                             shape: RoundedRectangleBorder(
              //                               borderRadius:
              //                                   BorderRadius.circular(8),
              //                             ),
              //                           ),
              //                           onPressed: () {
              //                             if (_ctrlPhone.text.trim().length >
              //                                 0) {
              //                               auth.signInWithPhone(
              //                                   '+91${_ctrlPhone.text}');
              //                             } else {
              //                               fModel.showSnackBar(context,
              //                                   'Please type your phone number');
              //                             }
              //                           },
              //                         ))
              //                   ]),
              //             );
              //           });
              //     },
              //   ),
              // )
            ],
          )),
    );
  }
}
