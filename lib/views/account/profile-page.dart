import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_farm_shop/helper/themes.dart';
import 'package:project_farm_shop/routes/routes.dart';
import 'package:project_farm_shop/services/auth.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:
              Text('My Profile', style: GoogleFonts.lato(color: Themes.brown)),
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          elevation: 8,
        ),
        body: Stack(children: [
          Positioned(
              bottom: 30,
              left: 30,
              right: 30,
              child: SvgPicture.asset(
                'assets/images/profile.svg',
                height: 120,
                fit: BoxFit.contain,
              )),
          Container(
            padding: EdgeInsets.all(30),
            margin: EdgeInsets.only(bottom: 90),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ListTile(
                  tileColor: Themes.brownLight2,
                  title: Text('Your Account', style: TextStyle(fontSize: 16)),
                  leading: SvgPicture.asset('assets/icons/icon-account.svg',
                      color: Themes.brown),
                  trailing: RotationTransition(
                    turns: AlwaysStoppedAnimation(270 / 360),
                    child: SvgPicture.asset('assets/icons/icon-chevron.svg',
                        color: Themes.brown),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  onTap: () => Navigator.pushNamed(context, Routes.account),
                ),
                SizedBox(height: 5),
                ListTile(
                  tileColor: Themes.brownLight2,
                  title: Text('Your Orders', style: TextStyle(fontSize: 16)),
                  leading: SvgPicture.asset('assets/icons/icon-orders.svg',
                      color: Themes.brown),
                  trailing: RotationTransition(
                    turns: AlwaysStoppedAnimation(270 / 360),
                    child: SvgPicture.asset('assets/icons/icon-chevron.svg',
                        color: Themes.brown),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  onTap: () => Navigator.pushNamed(context, Routes.orders),
                ),
                SizedBox(height: 5),
                ListTile(
                  tileColor: Themes.brownLight2,
                  title: Text('Your Favorites', style: TextStyle(fontSize: 16)),
                  leading: Icon(Icons.favorite,//SvgPicture.asset('assets/icons/icon-orders.svg',
                      color: Themes.brown),
                  trailing: RotationTransition(
                    turns: AlwaysStoppedAnimation(270 / 360),
                    child: SvgPicture.asset('assets/icons/icon-chevron.svg',
                        color: Themes.brown),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  onTap: () => Navigator.pushNamed(context, Routes.favorites),
                ),
                SizedBox(height: 5),
                ListTile(
                  tileColor: Themes.brownLight2,
                  title: Text('Live Chat', style: TextStyle(fontSize: 16)),
                  leading: SvgPicture.asset('assets/icons/icon-chat.svg',
                      color: Themes.brown),
                  trailing: RotationTransition(
                    turns: AlwaysStoppedAnimation(270 / 360),
                    child: SvgPicture.asset('assets/icons/icon-chevron.svg',
                        color: Themes.brown),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  onTap: () => Navigator.pushNamed(context, Routes.liveChat),
                ),
                SizedBox(height: 5),
                ListTile(
                  tileColor: Themes.brownLight2,
                  title: Text('Sign Out', style: TextStyle(fontSize: 16)),
                  leading: SvgPicture.asset('assets/icons/icon-sign-out.svg',
                      color: Themes.brown),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  onTap: () => context.read<AuthService>().signOut(context),
                ),
              ],
            ),
          )
        ]));
  }
}
