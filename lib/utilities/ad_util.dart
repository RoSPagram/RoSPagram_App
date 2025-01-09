import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../providers/my_info.dart';
import '../providers/gem_data.dart';
import '../utilities/shared_prefs.dart';
import '../utilities/supabase_util.dart';
import '../utilities/alert_dialog.dart';

RewardedInterstitialAd? _rewardedInterstitialAd;
RewardedAd? rewardedAd;

Duration interstitialAdDuration = Duration(minutes: 10);
Duration rewardedAdDuration = Duration(minutes: 30);

DateTime? rewardedInterstitialAdTime;
DateTime? rewardedAdTime;

Future<RewardedInterstitialAd> loadRewardedInterstitialAd() {
  final completer = Completer<RewardedInterstitialAd>();
  if (_rewardedInterstitialAd != null) {
    completer.complete(_rewardedInterstitialAd);
    return completer.future;
  }
  // TEST ID
  final adUnitId = Platform.isAndroid ? 'ca-app-pub-3940256099942544/5354046379' : 'ca-app-pub-3940256099942544/6978759866';
  // final adUnitId = Platform.isAndroid ? dotenv.env['REWARD_INTERSTITIAL_AD_ID_ANDROID'] as String : dotenv.env['REWARD_INTERSTITIAL_AD_ID_IOS'] as String;
  RewardedInterstitialAd.load(
    adUnitId: adUnitId,
    request: const AdRequest(),
    rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
      onAdLoaded: (ad) {
        completer.complete(ad);
      },
      onAdFailedToLoad: (LoadAdError error) {
        completer.completeError(error);
      },
    ),
  );

  completer.future.then((ad) {
    _rewardedInterstitialAd = ad;
  });
  return completer.future;
}

void showRewardedInterstitialAd() {
  _rewardedInterstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _rewardedInterstitialAd = null;
        loadRewardedInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (ad, err) {
        ad.dispose();
        _rewardedInterstitialAd = null;
        loadRewardedInterstitialAd();
      }
  );
  _rewardedInterstitialAd?.show(onUserEarnedReward: (ad, reward) {
    final localText = AppLocalizations.of(navigatorKey.currentState!.context)!;
    supabase.rpc('add_user_gems', params: {'user_id': navigatorKey.currentState!.context.read<MyInfo>().id, 'amount': 1}).then((_) {
      showAlertDialog(
        navigatorKey.currentState!.context,
        title: localText.reward_dialog_watch_title,
        content: '💎 +1',
        defaultActionText: localText.confirm,
      );
      navigatorKey.currentState!.context.read<GemData>().fetch();
    });
  });
}

void requestRewardedInterstitialAd() {
  if (rewardedInterstitialAdTime == null) {
    rewardedInterstitialAdTime = DateTime.now();
  }
  else if (rewardedInterstitialAdTime!.add(interstitialAdDuration).isAfter(DateTime.now())) {
    return;
  }
  rewardedInterstitialAdTime = DateTime.now();
  SharedPrefs.instance.setString('interstitial_time', rewardedInterstitialAdTime.toString());
  final localText = AppLocalizations.of(navigatorKey.currentState!.context)!;
  ScaffoldMessenger.of(navigatorKey.currentState!.context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.amber,
      content: Text(
        '${localText.reward_snackbar_msg} 💎 +1',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.deepPurpleAccent,
        ),
      ),
      duration: Duration(seconds: 15),
      action: SnackBarAction(
        backgroundColor: Colors.deepPurpleAccent,
        textColor: Colors.white,
        label: localText.reward_snackbar_action,
        onPressed: () {
          showRewardedInterstitialAd();
        },
      ),
    ),
  );
}

Future<RewardedAd> loadRewardedAd() {
  final completer = Completer<RewardedAd>();
  if (rewardedAd != null) {
    completer.complete(rewardedAd);
    return completer.future;
  }
  // TEST ID
  final adUnitId = Platform.isAndroid ? 'ca-app-pub-3940256099942544/5224354917' : 'ca-app-pub-3940256099942544/1712485313';
  // final adUnitId = Platform.isAndroid ? dotenv.env['REWARD_AD_ID_ANDROID'] as String : dotenv.env['REWARD_AD_ID_IOS'] as String;
  RewardedAd.load(
    adUnitId: adUnitId,
    request: const AdRequest(),
    rewardedAdLoadCallback: RewardedAdLoadCallback(
      onAdLoaded: (ad) {
        completer.complete(ad);
      },
      onAdFailedToLoad: (LoadAdError error) {
        completer.completeError(error);
      },
    ),
  );

  completer.future.then((ad) {
    rewardedAd = ad;
  });
  return completer.future;
}

void showRewardedAd(RewardedAd? rewardedAd, {
  required FullScreenContentCallback<RewardedAd> contentCallBack,
  required void Function(AdWithoutView, RewardItem) onUserEarnedReward
}) {
  if (rewardedAdTime == null) {
    rewardedAdTime = DateTime.now();
  }
  else if (rewardedAdTime!.add(rewardedAdDuration).isAfter(DateTime.now())) {
    return;
  }
  rewardedAdTime = DateTime.now();
  SharedPrefs.instance.setString('reward_time', rewardedAdTime.toString());
  rewardedAd?.fullScreenContentCallback = contentCallBack;
  rewardedAd?.show(onUserEarnedReward: onUserEarnedReward);
}

void initAdmob() {
  MobileAds.instance.initialize();
  loadRewardedInterstitialAd();
  loadRewardedAd();
  String? storedInterstitialTime = SharedPrefs.instance.getString('interstitial_time');
  String? storedRewardTime = SharedPrefs.instance.getString('reward_time');
  if (storedInterstitialTime != null) {
    rewardedInterstitialAdTime = DateTime.parse(storedInterstitialTime);
  }
  if (storedRewardTime != null) {
    rewardedAdTime = DateTime.parse(storedRewardTime);
  }
  else {
    rewardedAdTime = null;
  }
}