import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rospagram/l10n/app_localizations.dart';
import '../constants.dart';
import '../widgets/profile_avatar.dart';
import '../utilities/supabase_util.dart';
import '../utilities/firebase_util.dart';
import '../utilities/alert_dialog.dart';
import '../utilities/ad_util.dart';
import '../providers/my_info.dart';
import '../providers/match_data_to.dart';
import '../providers/ranking_data.dart';
import './result.dart';

class Play extends StatefulWidget {
  const Play({super.key, required this.userId, required this.isRequest});

  final String userId;
  final bool isRequest;

  @override
  State<Play> createState() => _PlayState();
}

class _PlayState extends State<Play> {
  int handIndex = 0;

  Future<List<dynamic>> _fetchUser(String userId) async {
    final List<dynamic> userData = await supabase.rpc('get_user_data', params: {'user_id': userId});
    return userData;
  }

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final localText = AppLocalizations.of(context)!;
    // void requestRewardedInterstitialAd() {
    //   showRewardedInterstitialAd(
    //     context,
    //     msg: 'Watch ad now, get 💎 +1',
    //     actionText: 'Watch Ad',
    //     onUserEarnedReward: (ad, reward) {
    //       supabase.rpc('add_user_gems', params: {'user_id': context.read<MyInfo>().id}).then((_) {
    //         showAlertDialog(
    //           context,
    //           title: localText.reward_dialog_watch_title,
    //           content: '💎 +1',
    //           defaultActionText: localText.confirm,
    //         );
    //         context.read<GemData>().fetch();
    //       });
    //     },
    //   );
    // }
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: FutureBuilder(
            future: _fetchUser(widget.userId),
            builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data?.length == 0) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(localText.play_no_users),
                        IconButton(
                          onPressed: () {
                            showAlertDialog(
                              context,
                              title: localText.play_dialog_exit_title,
                              content: localText.play_dialog_exit_content,
                              defaultActionText: localText.no,
                              destructiveActionText: localText.yes,
                              destructiveActionOnPressed: () {
                                requestRewardedInterstitialAd();
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                            );
                          },
                          icon: Icon(Icons.cancel),
                          iconSize: 48,
                          color: Colors.black.withValues(alpha: 0.5),
                        ),
                        Text(
                          localText.cancel,
                          style: TextStyle(
                            color: Colors.black.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                final userData = snapshot.data?[0];
                return Consumer<RankingData>(
                  builder: (context, rankingData, child) {
                    final top = getTopPercentage(rankingData.rankedUsersCount, userData['index']);
                    final userRank = getUserRank(top);
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: rankColorGradient(userRank),
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: child,
                    );
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ProfileAvatar(
                        avatarData: jsonDecode(userData['avatar']),
                        width: 128,
                        height: 128,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16, bottom: 16),
                        child: Text(
                          userData['username'],
                          style: TextStyle(
                            color: Colors.black.withValues(alpha: 0.5),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Consumer<RankingData>(builder: (context, rankingData, child) {
                        final top = getTopPercentage(rankingData.rankedUsersCount, userData['index']);
                        final userRank = getUserRank(top);
                        return Text(
                          getRankNameFromCode(userRank),
                          style: TextStyle(
                            color: Colors.black.withValues(alpha: 0.5),
                            fontSize: 16,
                          ),
                        );
                      }),
                      Padding(
                        padding: EdgeInsets.only(top: 32, bottom: 32),
                        child: Column(
                          children: [
                            Text(
                              localText.play_select,
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black.withValues(alpha: 0.75),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 8, bottom: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        handIndex = 1;
                                      });
                                    },
                                    child: Text('✊',
                                      style: TextStyle(
                                        fontSize: 48,
                                        color: handIndex == 1 ? null : Colors.black.withValues(alpha: 0.5),
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        handIndex = 2;
                                      });
                                    },
                                    child: Text('✌️',
                                      style: TextStyle(
                                        fontSize: 48,
                                        color: handIndex == 2 ? null : Colors.black.withValues(alpha: 0.5),
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        handIndex = 3;
                                      });
                                    },
                                    child: Text('🖐️',
                                      style: TextStyle(
                                        fontSize: 48,
                                        color: handIndex == 3 ? null : Colors.black.withValues(alpha: 0.5),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: !widget.isRequest ? null : () {
                                    setState(() {
                                      handIndex = 0;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.arrow_back,
                                        color: Colors.white,
                                      ),
                                      Text(localText.back),
                                    ],
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: handIndex == 0 ? null : () {
                                    if (widget.isRequest) {
                                      supabase.from('match').insert({
                                        'from': context.read<MyInfo>().id,
                                        'to': userData['id'],
                                        'send': handIndex
                                      }).then((_) {
                                        sendPushMessage(
                                            userData['fcm_token'],
                                            context.read<MyInfo>().username,
                                            '🚩 ${lookupAppLocalizations(Locale(userData['lang'] ?? 'en')).push_msg_body_match_req}',
                                            {'type': 'match_from'}
                                        );
                                        context.read<MatchDataTo>().fetch();
                                        requestRewardedInterstitialAd();
                                        Navigator.pop(context);
                                      }).onError((error, stackTrace) {
                                        showAlertDialog(
                                          context,
                                          title: localText.play_dialog_already_title,
                                          content: localText.play_dialog_already_content,
                                          defaultActionText: localText.cancel,
                                          destructiveActionText: localText.play_dialog_already_action,
                                          destructiveActionOnPressed: () {
                                            setState(() {
                                              handIndex = 0;
                                            });
                                            Navigator.pop(context);
                                          },
                                        );
                                      });
                                    }
                                    else {
                                      supabase.from('match').update({
                                        'respond': handIndex,
                                      }).match({'from': widget.userId, 'to': context.read<MyInfo>().id})
                                          .then((_) {
                                        Navigator.pop(context);
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => Result(from: widget.userId, to: context.read<MyInfo>().id)));
                                      });
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.check,
                                        color: Colors.white,
                                      ),
                                      Text(localText.confirm),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Column(
                          children: [
                            IconButton(
                              onPressed: () {
                                showAlertDialog(
                                  context,
                                  title: localText.play_dialog_exit_title,
                                  content: localText.play_dialog_exit_content,
                                  defaultActionText: localText.no,
                                  destructiveActionText: localText.yes,
                                  destructiveActionOnPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                );
                              },
                              icon: Icon(Icons.cancel),
                              iconSize: 48,
                              color: Colors.black.withValues(alpha: 0.5),
                            ),
                            Text(
                              localText.cancel,
                              style: TextStyle(
                                color: Colors.black.withValues(alpha: 0.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
              else {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: LinearProgressIndicator(
                      color: Colors.black12,
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
