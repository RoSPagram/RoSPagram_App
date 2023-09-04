import 'package:flutter/material.dart';
import '../utilities/supabase_util.dart';

class RankingData extends ChangeNotifier {
  List<dynamic> list = [];

  @override
  void notifyListeners() {
    super.notifyListeners();
  }

  void fetch() {
    supabase.from('top_ten').select('index, id, username, img_url, rank').then((value) {
      list = value;
      notifyListeners();
    });
  }
}