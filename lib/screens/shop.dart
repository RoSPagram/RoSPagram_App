import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../screens/avatar_editor.dart';
import '../screens/name_editor.dart';
import '../providers/my_info.dart';
import '../providers/gem_data.dart';
import '../providers/price_data.dart';
import '../providers/ranking_data.dart';
import '../widgets/shop_list_item.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/reward_ad_button.dart';
import '../utilities/supabase_util.dart';
import '../utilities/alert_dialog.dart';
import '../utilities/avatar_util.dart';
import '../utilities/ad_util.dart';
import '../constants.dart';

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
          child: Consumer<GemData>(
            builder: (context, gemData, child) {
              return Text(
                '💎 x${gemData.count}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              );
            },
          ),
        ),
        Expanded(
          child: Consumer<PriceData>(
            builder: (context, priceData, child) {
              return GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: priceData.items.length,
                itemBuilder: (context, index) {
                  final items = priceData.items;
                  switch(items[index]['id']) {
                    case 'change_name':
                      return ShopListItem(
                        itemWidget: Text(
                          '🏷️',
                          style: TextStyle(fontSize: 48),
                        ),
                        itemName: localText.shop_item_change_name,
                        price: items[index]['price'],
                        onTap: () {
                          requestRewardedInterstitialAd();
                          Navigator.push(context, MaterialPageRoute(builder: (context) => NameEditor(price: items[index]['price'])));
                        },
                      );
                    case 'random_avatar':
                      return ShopListItem(
                        itemWidget: ProfileAvatar(
                          avatarData: avatar.toJSON(),
                          width: 64,
                          height: 64,
                        ),
                        itemName: localText.shop_item_change_random_avatar,
                        price: items[index]['price'],
                        onTap: () {
                          showAlertDialog(
                            context,
                            title: localText.shop_item_change_random_avatar,
                            content: '${localText.shop_buy_alert_msg}\n💎 -${items[index]['price']}',
                            defaultActionText: localText.no,
                            destructiveActionText: localText.yes,
                            destructiveActionOnPressed: () {
                              if (context.read<GemData>().count < items[index]['price']) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(localText.shop_not_enough_msg)),
                                );
                              }
                              else {
                                supabase.rpc('use_user_gems', params: {'user_id': context.read<MyInfo>().id, 'price': items[index]['price']}).then((_) {
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
                      );
                    case 'face_pos':
                      return ShopListItem(
                        itemWidget: SvgPicture.string(
                          getAvatarFaceSVG(faceRotate: -20),
                          width: 64,
                          height: 64,
                        ),
                        itemName: localText.shop_item_face_position,
                        price: items[index]['price'],
                        onTap: () {
                          requestRewardedInterstitialAd();
                          Navigator.push(context, MaterialPageRoute(builder: (context) => AvatarEditor(avatarData: context.read<MyInfo>().avatarData, mode: 'face_pos', price: items[index]['price'])));
                        },
                      );
                    case 'body_pos':
                      return ShopListItem(
                        itemWidget: SvgPicture.string(
                          getAvatarBodySVG(bodyRotate: 30),
                          width: 64,
                          height: 64,
                        ),
                        itemName: localText.shop_item_body_position,
                        price: items[index]['price'],
                        onTap: () {
                          requestRewardedInterstitialAd();
                          Navigator.push(context, MaterialPageRoute(builder: (context) => AvatarEditor(avatarData: context.read<MyInfo>().avatarData, mode: 'body_pos', price: items[index]['price'])));
                        },
                      );
                    case 'bg_color':
                      return ShopListItem(
                        itemWidget: SvgPicture.string(
                          getAvatarBackgroundSVG(color: '#8080ff'),
                          width: 64,
                          height: 64,
                        ),
                        itemName: localText.shop_item_background_color,
                        price: items[index]['price'],
                        onTap: () {
                          requestRewardedInterstitialAd();
                          Navigator.push(context, MaterialPageRoute(builder: (context) => AvatarEditor(avatarData: context.read<MyInfo>().avatarData, mode: 'bg_color', price: items[index]['price'])));
                        },
                      );
                    case 'body_color':
                      return ShopListItem(
                        itemWidget: SvgPicture.string(
                          getAvatarBodySVG(backgroundColor: '#80ff80'),
                          width: 64,
                          height: 64,
                        ),
                        itemName: localText.shop_item_body_color,
                        price: items[index]['price'],
                        onTap: () {
                          requestRewardedInterstitialAd();
                          Navigator.push(context, MaterialPageRoute(builder: (context) => AvatarEditor(avatarData: context.read<MyInfo>().avatarData, mode: 'body_color', price: items[index]['price'])));
                        },
                      );
                    case 'cheek_color':
                      return ShopListItem(
                        itemWidget: SvgPicture.string(
                          getAvatarFaceSVG(
                            cheekColor: '#ff8080',
                            eyesOpacity: 0.25,
                            mouthOpacity: 0.25,
                          ),
                          width: 64,
                          height: 64,
                        ),
                        itemName: localText.shop_item_cheek_color,
                        price: items[index]['price'],
                        onTap: () {
                          requestRewardedInterstitialAd();
                          Navigator.push(context, MaterialPageRoute(builder: (context) => AvatarEditor(avatarData: context.read<MyInfo>().avatarData, mode: 'cheek_color', price: items[index]['price'])));
                        },
                      );
                  }
                },
              );
            },
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
