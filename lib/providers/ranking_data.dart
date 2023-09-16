import 'package:flutter/material.dart';
import '../utilities/supabase_util.dart';

class RankingData extends ChangeNotifier {
  List<dynamic> list = [];
  int rankedUsersCount = 0;

  @override
  void notifyListeners() {
    super.notifyListeners();
  }

  void fetchTopten() {
    supabase.from('top_ten').select('index, id, username, img_url, rank').then((value) {
      list = value;
      notifyListeners();
    });
  }
  
  void fetchRankedUsersCount() {
    supabase.rpc('get_ranked_users_count').then((value) {
      rankedUsersCount = value;
      notifyListeners();
    });
  }

  void fetch() {
    fetchTopten();
    fetchRankedUsersCount();
  }
}