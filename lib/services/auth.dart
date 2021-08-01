import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:project_farm_shop/routes/routes.dart';

class AuthService {
  final auth = FirebaseAuth.instance;

  Future<UserCredential?> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    print("check bla bla");
    print("check this" + googleUser.toString());

    if (googleUser == null) {
      return null;
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await auth.signInWithCredential(credential);
  }

  Future<String?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      return 'Login success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        return 'No user found for that email.';
        // showSnackBar('No user found!');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        return 'Wrong password provided for that user.';
        // showSnackBar('Invalid credentials!');
      } else {
        // showSnackBar('Something went wrong!');
        return 'Something went wrong!';
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future signInWithPhone(phoneNumber) async {
    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }
      },
      codeSent: (String verificationId, int? resendToken) async {
        // Update the UI - wait for the user to enter the SMS code
        String smsCode = 'xxxx';

        // Create a PhoneAuthCredential with the code
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: verificationId, smsCode: smsCode);

        // Sign the user in (or link) with the credential
        await auth.signInWithCredential(credential);
      },
      timeout: const Duration(seconds: 120),
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<UserCredential?> verificationCompleted(
      PhoneAuthCredential phoneAuthCredential) async {
    return await auth.signInWithCredential(phoneAuthCredential);
  }

  String? verificationFailed(FirebaseAuthException authException) {
    return authException.message;
  }

  // PhoneCodeSent codeSent(String verificationId, [int forceResendingToken]) async {
  //   showSnackbar('Please check your phone for the verification code.');
  //   _verificationId = verificationId;
  // };

  Future<void> signOut(context) async {
    await auth.signOut();
    Navigator.of(context)
        .pushNamedAndRemoveUntil(Routes.root, (route) => false);
  }
}
