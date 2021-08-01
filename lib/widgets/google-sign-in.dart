import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_farm_shop/helper/themes.dart';
import 'package:project_farm_shop/services/auth.dart';
import 'package:provider/provider.dart';

class GoogleSignInButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<AuthService>(context);

    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
          primary: Colors.white,
          minimumSize: Size(double.infinity, 60),
          shape: RoundedRectangleBorder(
              side: BorderSide(color: Themes.brown, width: 0.5),
              borderRadius: BorderRadius.circular(36))),
      onPressed: () {
        print(" on on ");
        auth.signInWithGoogle();
      },
      icon: Image(
        image: AssetImage("assets/images/google_logo.png"),
        height: 24.0,
      ),
      label: Text(
        'Sign in with Google',
        style: GoogleFonts.lato(
            fontSize: 18, fontWeight: FontWeight.bold, color: Themes.brown),
      ),
    );

    /*OutlinedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.white),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      onPressed: () {
        auth.signInWithGoogle();
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
              image: AssetImage("assets/images/google_logo.png"),
              height: 28.0,
            ),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black54,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          ],
        ),
      ),
    );*/
  }
}
