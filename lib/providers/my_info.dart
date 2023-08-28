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

  @override set img_url(String value) {
    super.img_url = value;
    notifyListeners();
  }

  @override set index(int value) {
    super.index = value;
    notifyListeners();
  }

  @override set rank(int value) {
    super.rank = value;
    notifyListeners();
  }

  @override set win(int value) {
    super.win = value;
    notifyListeners();
  }

  @override set loss(int value) {
    super.loss = value;
    notifyListeners();
  }

  @override set draw(int value) {
    super.draw = value;
    notifyListeners();
  }

  @override set score(double value) {
    super.score = value;
    notifyListeners();
  }
}