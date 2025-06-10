import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rospagram/l10n/app_localizations.dart';
import '../screens/random_match_list.dart';
import '../widgets/profile_header.dart';
import '../widgets/token_view.dart';
import '../providers/my_info.dart';
import '../providers/token_data.dart';
import '../utilities/ad_util.dart';
import '../utilities/alert_dialog.dart';
import './user_profile.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final localText = AppLocalizations.of(context)!;

    void play() async {
      bool isEmpty = await context.read<TokenData>().isTokenEmpty();
      if (isEmpty) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.token_view_msg_no)),
        );
        return;
      }
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => RandomMatchList())
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          ProfileHeader(
            onTap: () {
              requestRewardedInterstitialAd();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserProfile(userId: context.read<MyInfo>().id),
                  )
              );
            },
          ),
          TokenView(),
          ElevatedButton(
            onPressed: () {
              showAlertDialog(
                context,
                title: localText.play_btn_dialog_title,
                content: '${localText.play_btn_dialog_content}\n🪙 -1',
                defaultActionText: localText.no,
                destructiveActionText: localText.yes,
                destructiveActionOnPressed: play,
              );
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.only(left: 48, right: 48),
              backgroundColor: Colors.deepOrange,
              foregroundColor: Colors.white,
            ),
            child: Column(
              children: [
                Text(
                  localText.play_btn_text,
                  style: TextStyle(
                    fontSize: 32,
                  ),
                ),
                Text(
                  '🪙 -1',
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ),
          // Text('Your ID : ${context.watch<MyInfo>().id}'),
        ],
      ),
    );
  }
}