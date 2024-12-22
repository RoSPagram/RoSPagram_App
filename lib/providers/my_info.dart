import 'package:flutter/material.dart';
import '../models/user.dart';
import '../utilities/supabase_util.dart';

class MyInfo extends User with ChangeNotifier {
  @override
  void notifyListeners() {
    super.notifyListeners();
  }

  void fetch() {
    if (id.isEmpty) return;
    supabase.rpc('get_user_data', params: {'user_id': id}).then((userData) {
      id = userData[0]['id'];
      username = userData[0]['username'];
      img_url = userData[0]['img_url'];
      index = userData[0]['index'];
      win = userData[0]['win'];
      loss = userData[0]['loss'];
      draw = userData[0]['draw'];
      avatarData = userData[0]['avatar'];
      notifyListeners();
    });
  }
}