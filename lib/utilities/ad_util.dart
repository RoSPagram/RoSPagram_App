import 'dart:io' show Platform;
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../utilities/shared_prefs.dart';

const interstitialAdDuration = Duration(seconds: 30);
const rewardAdDuration = Duration(minutes: 1);

DateTime? interstitialAdTime;
DateTime? rewardAdTime;

void loadInterstitialAd() {
  if (interstitialAdTime == null) {
    interstitialAdTime = DateTime.now();
  }
  else if (interstitialAdTime!.add(interstitialAdDuration).isAfter(DateTime.now())) {
    return;
  }

  final adUnitId = Platform.isAndroid ? 'ca-app-pub-3940256099942544/1033173712' : 'ca-app-pub-3940256099942544/4411468910';
  InterstitialAd.load(
    adUnitId: adUnitId,
    request: const AdRequest(),
    adLoadCallback: InterstitialAdLoadCallback(
      onAdLoaded: (ad) {
        interstitialAdTime = DateTime.now();
        ad.show();
        ad.fullScreenContentCallback = FullScreenContentCallback(
          onAdDismissedFullScreenContent: (ad) {
            ad.dispose();
          },
          onAdFailedToShowFullScreenContent: (ad, err) {
            ad.dispose();
          }
        );
      },
      onAdFailedToLoad: (LoadAdError error) {
        print(error);
      },
    ),
  );
}

void loadRewardAd(void Function(AdWithoutView, RewardItem) onUserEarnedReward) {
  if (rewardAdTime == null) {
    rewardAdTime = DateTime.now();
  }
  else if (rewardAdTime!.add(rewardAdDuration).isAfter(DateTime.now())) {
    return;
  }

  final adUnitId = Platform.isAndroid ? 'ca-app-pub-3940256099942544/5354046379' : 'ca-app-pub-3940256099942544/6978759866';
  RewardedInterstitialAd.load(
    adUnitId: adUnitId,
    request: const AdRequest(),
    rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
      onAdLoaded: (ad) {
        rewardAdTime = DateTime.now();
        SharedPrefs.instance.setString('reward_time', rewardAdTime.toString());
        ad.show(onUserEarnedReward: onUserEarnedReward);
        ad.fullScreenContentCallback = FullScreenContentCallback(
          onAdDismissedFullScreenContent: (ad) {
            ad.dispose();
          },
          onAdFailedToShowFullScreenContent: (ad, err) {
            ad.dispose();
          },
        );
      },
      onAdFailedToLoad: (LoadAdError error) {
        print(error);
      },
    ),
  );
}
