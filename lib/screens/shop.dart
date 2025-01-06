import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../providers/my_info.dart';
import '../providers/gem_data.dart';
import '../providers/ranking_data.dart';
import '../widgets/shop_list_item.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/reward_ad_button.dart';
import '../utilities/supabase_util.dart';
import '../utilities/alert_dialog.dart';
import '../utilities/avatar_util.dart';
import '../utilities/ad_util.dart';

const PRICE_RANDOM_AVATAR = 20;

class Shop extends StatelessWidget {
  const Shop({super.key});

  @override
  Widget build(BuildContext context) {
    final localText = AppLocalizations.of(context)!;
    Avatar avatar = new Avatar();
    avatar.applyRandom();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            '💎 x${context.watch<GemData>().count}',
            textAlign: TextAlign.center,
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
                itemWidget: ProfileAvatar(
                  avatarData: jsonEncode(avatar.toJSON()),
                  width: 64,
                  height: 64,
                ),
                itemName: '${localText.shop_item_change_random_avatar}',
                price: PRICE_RANDOM_AVATAR,
                onTap: () {
                  showAlertDialog(
                    context,
                    title: localText.shop_item_change_random_avatar,
                    content: '${localText.shop_buy_alert_msg}\n💎 -$PRICE_RANDOM_AVATAR',
                    defaultActionText: localText.no,
                    destructiveActionText: localText.yes,
                    destructiveActionOnPressed: () {
                      if (context.read<GemData>().count < PRICE_RANDOM_AVATAR) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(localText.shop_not_enough_msg)),
                        );
                      }
                      else {
                        supabase.rpc('use_user_gems', params: {'user_id': context.read<MyInfo>().id, 'price': PRICE_RANDOM_AVATAR}).then((_) {
                          avatar.applyRandom();
                          context.read<MyInfo>().avatarData = jsonEncode(avatar.toJSON());
                          supabase.from('users').update({
                            'avatar': context.read<MyInfo>().avatarData,
                          }).eq('id', context.read<MyInfo>().id).then((_) {
                            context.read<GemData>().fetch();
                            context.read<RankingData>().fetchTopten();
                            context.read<MyInfo>().notifyListeners();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(localText.shop_avatar_change_msg)),
                            );
                          });
                        });
                      }
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8),
          child: RewardAdButton(),
        ),
      ],
    );
  }
}
