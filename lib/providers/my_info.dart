import 'package:flutter/material.dart';
import '../models/user.dart';

class MyInfo extends User with ChangeNotifier {
  @override set id(String value) {
    super.id = value;
    notifyListeners();
  }

  @override set username(String value) {
    super.username = value;
    notifyListeners();
  }
}