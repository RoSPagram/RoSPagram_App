import 'dart:async';
import 'package:flutter/material.dart';
import '../utilities/shared_prefs.dart';
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

  @override
  void initState() {
    String? storedRewardTime = SharedPrefs.instance.getString('reward_time');
    setState(() {
      if (storedRewardTime != null) {
        rewardAdTime = DateTime.parse(storedRewardTime);
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
        showAlertDialog(
          context,
          title: 'Watch Ad',
          content: 'Watch ad to get 💎 +2',
          defaultActionText: localText.no,
          destructiveActionText: localText.yes,
          destructiveActionOnPressed: () {
            Navigator.pop(context);
            loadRewardAd((ad, rewardItem) {
              _buttonState = 1;
              _remaining = rewardAdTime!.add(rewardAdDuration).difference(DateTime.now());
              _timer = Timer.periodic(Duration(seconds: 1), _updateRemainingTime);
              showAlertDialog(
                context,
                title: 'Earned',
                content: 'You got 💎 +2',
                defaultActionText: localText.confirm,
              );
            });
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