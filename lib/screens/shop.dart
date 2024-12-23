import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../providers/gem_data.dart';
import '../widgets/shop_list_item.dart';
import '../utilities/supabase_util.dart';

class Shop extends StatelessWidget {
  const Shop({super.key});

  @override
  Widget build(BuildContext context) {
    final localText = AppLocalizations.of(context)!;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            '💎 x${context.watch<GemData>().count}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        Expanded(
          child: GridView(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            children: [
              ShopListItem(
                itemWidget: Text(
                  '🏷️',
                  style: TextStyle(fontSize: 48),
                ),
                itemName: '${localText.shop_item_change_name}',
                price: 100,
                onTap: () {},
              ),
              ShopListItem(
                itemWidget: Text(
                  '🏷️',
                  style: TextStyle(fontSize: 48),
                ),
                itemName: 'TEST',
                price: 1,
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}
