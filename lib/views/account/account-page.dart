import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_farm_shop/helper/themes.dart';
import 'package:project_farm_shop/services/db.dart';
import 'package:project_farm_shop/views/auth/user.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  var currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    var db = Provider.of<DatabaseService>(context);
    // db.getUser(currentUser?.uid).then((value) {
    //   setState(() {
    //     user = value;
    //   });
    // });

    return Scaffold(
      appBar: AppBar(
        title:
            Text('Your Account', style: GoogleFonts.lato(color: Themes.brown)),
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        elevation: 8,
      ),
      body: Stack(
        children: [
          Positioned(
              bottom: 30,
              left: 30,
              right: 30,
              child: SvgPicture.asset(
                'assets/images/account.svg',
                height: 120,
                fit: BoxFit.contain,
              )),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              child: FutureBuilder(
                  future: db.getUser(currentUser?.uid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            '${snapshot.error} occurred',
                            style: TextStyle(fontSize: 18),
                          ),
                        );
                      } else if (snapshot.hasData) {
                        FUser user = snapshot.data as FUser;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Your information',
                              style: TextStyle(
                                  fontSize: 20, color: Themes.textColor),
                            ),
                            SizedBox(height: 20),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.all(30),
                              color: Themes.brownLight2,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Full Name',
                                        style: TextStyle(
                                            color: Themes.textColor,
                                            fontSize: 16)),
                                    Text(user.displayName ?? '',
                                        style: TextStyle(
                                            color: Themes.brown, fontSize: 16)),
                                    SizedBox(height: 20),
                                    Text('Email',
                                        style: TextStyle(
                                            color: Themes.textColor,
                                            fontSize: 16)),
                                    Text(user.email ?? '',
                                        style: TextStyle(
                                            color: Themes.brown, fontSize: 16)),
                                    SizedBox(height: 20),
                                    Text('Phone number',
                                        style: TextStyle(
                                            color: Themes.textColor,
                                            fontSize: 16)),
                                    Text('${user.phoneNumber}',
                                        style: TextStyle(
                                            color: Themes.brown, fontSize: 16)),
                                  ]),
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Shipping Address',
                              style:
                                  TextStyle(fontSize: 20, color: Themes.brown),
                            ),
                            SizedBox(height: 20),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.all(30),
                              color: Themes.brownLight2,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //   ${user.address?[0].buildingName ?? ''},
                                    Text(
                                        '${user.address?[0].roomNo},'
                                        '${user.address?[0].wing}, ${user.address?[0].society}, '
                                        '${user.address?[0].locality}, ${user.address?[0].city}, '
                                        '${user.address?[0].state},\nPin - ${user.address?[0].pinCode}, ',
                                        style: TextStyle(
                                            color: Themes.textColor,
                                            fontSize: 16))
                                  ]),
                            ),
                          ],
                        );
                      }
                    }

                    return Center(child: CircularProgressIndicator());
                  })),
        ],
      ),
    );
  }
}
