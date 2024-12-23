import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
            '💎 x10',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        Expanded(
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: 6,
            itemBuilder: (BuildContext context, int index) {
              return ShopListItem(
                itemWidget: Text(
                  '🏷️',
                  style: TextStyle(fontSize: 48),
                ),
                itemName: '${localText.shop_item_change_name}',
                price: 100,
                onTap: () {},
              );
            },
          ),
        ),
      ],
    );
  }
}
