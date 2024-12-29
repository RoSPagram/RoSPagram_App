import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utilities/supabase_util.dart';
import 'my_info.dart';

class GemData extends ChangeNotifier {
  GemData({required this.context});

  final BuildContext context;
  int count = 0;

  @override
  void notifyListeners() {
    super.notifyListeners();
  }

  void fetch() {
    supabase.rpc('get_user_gems', params: {'user_id': context.read<MyInfo>().id}).then((gem) {
      if (gem == null) {
        supabase.from('user_gems').insert({'id': context.read<MyInfo>().id}).then((_) {
          count = 0;
        });
      }
      else {
        count = gem;
      }
      notifyListeners();
    });
  }
}