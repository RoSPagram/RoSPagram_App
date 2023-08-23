import 'package:flutter/material.dart';
import '../models/user.dart';

class MyInfo with ChangeNotifier implements User {
  String _id = "";
  String _name = "";

  String get id => _id;
  set id(String value) {
    _id = value;
    notifyListeners();
  }

  String get name => _name;
  set name(String value) {
    _name = value;
    notifyListeners();
  }
}