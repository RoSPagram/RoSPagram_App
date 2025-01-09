import 'package:flutter/material.dart';
import '../utilities/supabase_util.dart';

class PriceData extends ChangeNotifier {
  List<dynamic> items = [];

  @override
  void notifyListeners() {
    super.notifyListeners();
  }

  void fetch() {
    supabase.from('item_price').select().then((priceData) {
      priceData.sort((a, b) => b['price'].compareTo(a['price']));
      items = priceData;
      notifyListeners();
    });
  }
}