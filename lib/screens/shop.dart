import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../screens/avatar_editor.dart';
import '../screens/name_editor.dart';
import '../providers/my_info.dart';
import '../providers/gem_data.dart';
import '../providers/ranking_data.dart';
import '../widgets/shop_list_item.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/reward_ad_button.dart';
import '../utilities/supabase_util.dart';
import '../utilities/alert_dialog.dart';
import '../utilities/avatar_util.dart';
import '../constants.dart';

const PRICE_CHANGE_NAME = 50;
const PRICE_RANDOM_AVATAR = 20;
const PRICE_FACE_POSITION = 20;
const PRICE_BODY_POSITION = 20;
const PRICE_BODY_COLOR = 20;
const PRICE_BACKGROUND_COLOR = 20;
const PRICE_CHEEK_COLOR = 10;

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
                itemWidget: Text(
                  '🏷️',
                  style: TextStyle(fontSize: 48),
                ),
                itemName: localText.shop_item_change_name,
                price: PRICE_CHANGE_NAME,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => NameEditor(price: PRICE_CHANGE_NAME)));
                },
              ),
              ShopListItem(
                itemWidget: ProfileAvatar(
                  avatarData: avatar.toJSON(),
                  width: 64,
                  height: 64,
                ),
                itemName: localText.shop_item_change_random_avatar,
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
              ShopListItem(
                itemWidget: SvgPicture.string(
                  getAvatarFaceSVG(faceRotate: -20),
                  width: 64,
                  height: 64,
                ),
                itemName: localText.shop_item_face_position,
                price: PRICE_FACE_POSITION,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AvatarEditor(avatarData: context.read<MyInfo>().avatarData, mode: 'face_pos', price: PRICE_FACE_POSITION)));
                },
              ),
              ShopListItem(
                itemWidget: SvgPicture.string(
                  getAvatarBodySVG(bodyRotate: 30),
                  width: 64,
                  height: 64,
                ),
                itemName: localText.shop_item_body_position,
                price: PRICE_BODY_POSITION,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AvatarEditor(avatarData: context.read<MyInfo>().avatarData, mode: 'body_pos', price: PRICE_BODY_POSITION)));
                },
              ),
              ShopListItem(
                itemWidget: SvgPicture.string(
                  getAvatarBackgroundSVG(color: '#8080ff'),
                  width: 64,
                  height: 64,
                ),
                itemName: localText.shop_item_background_color,
                price: PRICE_BACKGROUND_COLOR,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AvatarEditor(avatarData: context.read<MyInfo>().avatarData, mode: 'bg_color', price: PRICE_BACKGROUND_COLOR)));
                },
              ),
              ShopListItem(
                itemWidget: SvgPicture.string(
                  getAvatarBodySVG(backgroundColor: '#80ff80'),
                  width: 64,
                  height: 64,
                ),
                itemName: localText.shop_item_body_color,
                price: PRICE_BODY_COLOR,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AvatarEditor(avatarData: context.read<MyInfo>().avatarData, mode: 'body_color', price: PRICE_BODY_COLOR)));
                },
              ),
              ShopListItem(
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
                price: PRICE_CHEEK_COLOR,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AvatarEditor(avatarData: context.read<MyInfo>().avatarData, mode: 'cheek_color', price: PRICE_CHEEK_COLOR)));
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
