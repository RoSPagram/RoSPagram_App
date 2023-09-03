import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utilities/supabase_util.dart';
import '../providers/my_info.dart';

class MatchDataTo extends ChangeNotifier {
  MatchDataTo({required this.context});

  final BuildContext context;
  List<dynamic> list = [];

  @override
  void notifyListeners() {
    super.notifyListeners();
  }

  void fetch() {
    supabase.rpc('get_match_to', params: {'user_id': context.read<MyInfo>().id}).then((value) {
      list = value;
      notifyListeners();
    });
  }
}