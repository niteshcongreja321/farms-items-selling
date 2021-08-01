import 'package:flutter/material.dart';

class FormModel extends ChangeNotifier {
  bool isSubmitted = false;
  bool passwordVisible = false;

  void togglePassword() {
    passwordVisible = !passwordVisible;
    notifyListeners();
  }

  void submitted(bool value) {
    isSubmitted = value;
    notifyListeners();
  }

  void showSnackBar(BuildContext context, String? message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 3),
        content: Text(message != null ? message : '')));
  }
}
