import 'dart:async';
import 'dart:io' show Platform;
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../utilities/shared_prefs.dart';

InterstitialAd? _interstitialAd;
RewardedInterstitialAd? rewardAd;

const interstitialAdDuration = Duration(minutes: 2);
const rewardAdDuration = Duration(minutes: 30);

DateTime? interstitialAdTime;
DateTime? rewardAdTime;

Future<InterstitialAd> loadInterstitialAd() {
  final completer = Completer<InterstitialAd>();
  if (_interstitialAd != null) {
    completer.complete(_interstitialAd);
    return completer.future;
  }
  // TEST ID
  // final adUnitId = Platform.isAndroid ? 'ca-app-pub-3940256099942544/1033173712' : 'ca-app-pub-3940256099942544/4411468910';
  final adUnitId = Platform.isAndroid ? dotenv.env['INTERSTITIAL_AD_ID_ANDROID'] as String : dotenv.env['INTERSTITIAL_AD_ID_IOS'] as String;
  InterstitialAd.load(
    adUnitId: adUnitId,
    request: const AdRequest(),
    adLoadCallback: InterstitialAdLoadCallback(
      onAdLoaded: (ad) {
        completer.complete(ad);
      },
      onAdFailedToLoad: (LoadAdError error) {
        completer.completeError(error);
      },
    ),
  );

  completer.future.then((ad) {
    _interstitialAd = ad;
  });
  return completer.future;
}

void showInterstitialAd() {
  if (interstitialAdTime == null) {
    interstitialAdTime = DateTime.now();
  }
  else if (interstitialAdTime!.add(interstitialAdDuration).isAfter(DateTime.now())) {
    return;
  }
  interstitialAdTime = DateTime.now();
  _interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _interstitialAd = null;
        loadInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (ad, err) {
        ad.dispose();
        _interstitialAd = null;
        loadInterstitialAd();
      }
  );
  _interstitialAd?.show();
}

Future<RewardedInterstitialAd> loadRewardAd() {
  final completer = Completer<RewardedInterstitialAd>();
  if (rewardAd != null) {
    completer.complete(rewardAd);
    return completer.future;
  }
  // TEST ID
  // final adUnitId = Platform.isAndroid ? 'ca-app-pub-3940256099942544/5354046379' : 'ca-app-pub-3940256099942544/6978759866';
  final adUnitId = Platform.isAndroid ? dotenv.env['REWARD_INTERSTITIAL_AD_ID_ANDROID'] as String : dotenv.env['REWARD_INTERSTITIAL_AD_ID_IOS'] as String;
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
    rewardAd = ad;
  });
  return completer.future;
}

void showRewardAd(RewardedInterstitialAd? rewardAd, {required FullScreenContentCallback<RewardedInterstitialAd> contentCallBack, required void Function(AdWithoutView, RewardItem) onUserEarnedReward}) {
  if (rewardAdTime == null) {
    rewardAdTime = DateTime.now();
  }
  else if (rewardAdTime!.add(rewardAdDuration).isAfter(DateTime.now())) {
    return;
  }
  rewardAdTime = DateTime.now();
  SharedPrefs.instance.setString('reward_time', rewardAdTime.toString());
  rewardAd?.fullScreenContentCallback = contentCallBack;
  rewardAd?.show(onUserEarnedReward: onUserEarnedReward);
}

void initAdmob() {
  MobileAds.instance.initialize();
  loadInterstitialAd();
  loadRewardAd();
  String? storedRewardTime = SharedPrefs.instance.getString('reward_time');
  if (storedRewardTime != null) {
    rewardAdTime = DateTime.parse(storedRewardTime);
  }
  else {
    rewardAdTime = null;
  }
}