import 'package:firebase/colors.dart';
import 'package:flutter/material.dart';

class CustomSnackBar {
  static void showCustomSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: blueColor,
      showCloseIcon: true,
      duration: const Duration(seconds: 5),
      behavior: SnackBarBehavior.floating,
      content: Text(
        message,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    ));
  }
}
