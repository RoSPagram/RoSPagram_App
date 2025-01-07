import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../utilities/ad_util.dart';
import '../utilities/alert_dialog.dart';
import '../utilities/supabase_util.dart';
import '../providers/my_info.dart';
import '../providers/gem_data.dart';

class RewardAdButton extends StatefulWidget {
  const RewardAdButton({Key? key}) : super(key: key);

  @override
  State<RewardAdButton> createState() => _RewardAdButtonState();
}

class _RewardAdButtonState extends State<RewardAdButton> {

  Timer? _timer;
  Duration? _remaining;
  int _buttonState = 0;

  void _updateRemainingTime(Timer? timer) {
    if (timer == null) return;

    DateTime now = DateTime.now();
    setState(() {
      if (now.isAfter(rewardAdTime!.add(rewardAdDuration))) {
        _buttonState = 0;
        _timer?.cancel();
        _timer = null;
      }
      else {
        _remaining = rewardAdTime!.add(rewardAdDuration).difference(now);
      }
    });
  }

  void _adDisposeCallback(RewardedInterstitialAd ad) {
    ad.dispose();
    rewardAd = null;
    loadRewardAd();
    setState(() {
      _buttonState = 1;
      _remaining = rewardAdTime!.add(rewardAdDuration).difference(DateTime.now());
      _timer = Timer.periodic(Duration(seconds: 1), _updateRemainingTime);
    });
  }

  @override
  void initState() {
    setState(() {
      if (rewardAdTime != null) {
        DateTime now = DateTime.now();
        if (now.isAfter(rewardAdTime!.add(rewardAdDuration))) {
          _buttonState = 0;
        }
        else {
          _buttonState = 1;
          _remaining = rewardAdTime!.add(rewardAdDuration).difference(now);
          _timer = Timer.periodic(Duration(seconds: 1), _updateRemainingTime);
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localText = AppLocalizations.of(context)!;
    Text text = Text(
      '💎 ${localText.reward_btn_text}',
      style: TextStyle(
        color: Colors.deepPurpleAccent,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    );
    return FilledButton(
      onPressed: () {
        if (_buttonState != 0) return;
        showAlertDialog(
          context,
          title: localText.reward_dialog_title,
          content: '\n${localText.reward_dialog_content_watch} → 💎 +1\n\n${localText.reward_dialog_content_click} → 💎 +1',
          defaultActionText: localText.no,
          destructiveActionText: localText.yes,
          destructiveActionOnPressed: () {
            bool isAdClicked = false;
            Navigator.pop(context);
            showRewardAd(
              rewardAd,
              contentCallBack: FullScreenContentCallback(
                onAdDismissedFullScreenContent: (ad) {
                  _adDisposeCallback(ad);
                },
                onAdFailedToShowFullScreenContent: (ad, err) {
                  _adDisposeCallback(ad);
                },
                onAdClicked: (ad) {
                  if (isAdClicked) return;
                  isAdClicked = true;
                  supabase.rpc('add_user_gems', params: {'user_id': context.read<MyInfo>().id}).then((_) {
                    showAlertDialog(
                      context,
                      title: localText.reward_dialog_click_title,
                      content: '💎 +1',
                      defaultActionText: localText.confirm,
                    );
                    context.read<GemData>().fetch();
                  });
                }
              ),
              onUserEarnedReward: (ad, rewardItem) {
                _buttonState = 1;
                _remaining = rewardAdTime!.add(rewardAdDuration).difference(DateTime.now());
                _timer = Timer.periodic(Duration(seconds: 1), _updateRemainingTime);
                supabase.rpc('add_user_gems', params: {'user_id': context.read<MyInfo>().id}).then((_) {
                  showAlertDialog(
                    context,
                    title: localText.reward_dialog_watch_title,
                    content: '💎 +1',
                    defaultActionText: localText.confirm,
                  );
                  context.read<GemData>().fetch();
                });
              },
            );
            setState(() {
              _buttonState = 2;
            });
          }
        );
      },
      style: FilledButton.styleFrom(backgroundColor: Colors.amber),
      child: _buttonState == 1 ? Text(
          '⏳ ${_remaining!.inMinutes.toString().padLeft(2, '0')}:${(_remaining!.inSeconds % 60).toString().padLeft(2, '0')}',
          style: TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
      ) : _buttonState == 2 ? CircularProgressIndicator() : text,
    );
  }
}