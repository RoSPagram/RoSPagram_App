import 'package:flutter/material.dart';
import '../models/user.dart';

class MyInfo extends User with ChangeNotifier {
  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}