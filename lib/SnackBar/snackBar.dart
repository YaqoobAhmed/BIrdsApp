import 'package:firebase/colors.dart';
import 'package:flutter/material.dart';

class CustomSnackBar {
  static void showCustomSnackBar(context, String message) {
    final snackBar = SnackBar(
      showCloseIcon: true,
      closeIconColor: blueColor,
      backgroundColor: Color.fromARGB(255, 255, 200, 0),
      behavior: SnackBarBehavior.floating,
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      duration: const Duration(seconds: 5),
      content: Text(
        message,
        style: TextStyle(fontWeight: FontWeight.bold, color: blueColor),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

class CustomSnackBarWithoutAnimation {}
