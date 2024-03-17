import 'package:flutter/material.dart';

class PhoneProvider extends ChangeNotifier {
  String? phoneNumber;

  setPhoneNumber(String? phoneNumber) {
    this.phoneNumber = phoneNumber;
    notifyListeners();
  }
}
