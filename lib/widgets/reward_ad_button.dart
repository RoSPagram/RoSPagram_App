import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../utilities/ad_util.dart';
import '../utilities/alert_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const text = Text(
  '💎 +2',
  style: TextStyle(
    color: Colors.deepPurpleAccent,
    fontWeight: FontWeight.bold,
    fontSize: 18,
  ),
);

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
    return FilledButton(
      onPressed: () {
        if (_buttonState != 0) return;
        int bonus = 0;
        showAlertDialog(
          context,
          title: 'Earn Gem',
          content: 'Watch Ad = 💎 +1\nClick Ad = Bonus 💎 +1',
          defaultActionText: localText.no,
          destructiveActionText: localText.yes,
          destructiveActionOnPressed: () {
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
                  bonus++;
                }
              ),
              onUserEarnedReward: (ad, rewardItem) {
                _buttonState = 1;
                _remaining = rewardAdTime!.add(rewardAdDuration).difference(DateTime.now());
                _timer = Timer.periodic(Duration(seconds: 1), _updateRemainingTime);
                showAlertDialog(
                  context,
                  title: 'Earned',
                  content: 'You got 💎 +${rewardItem.amount+bonus}',
                  defaultActionText: localText.confirm,
                );
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