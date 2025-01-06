import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
  const Play({super.key, this.userId = '', required this.isRequest});

  final String userId;
  final bool isRequest;

  @override
  State<Play> createState() => _PlayState();
}

class _PlayState extends State<Play> {
  bool isStart = false;
  bool fetchData = true;
  int handIndex = 0;
  int userIndex = 0;

  Future<List<dynamic>> _fetchRandomUsers() async {
    final List<dynamic> usersData = await supabase.rpc('find_users_to_match', params: {'sender_id': context.read<MyInfo>().id});
    return usersData;
  }

  Future<List<dynamic>> _fetchUser(String userId) async {
    final List<dynamic> userData = await supabase.rpc('get_user_data', params: {'user_id': userId});
    return userData;
  }

  @override
  initState() {
    super.initState();
    isStart = !widget.isRequest;
  }

  @override
  Widget build(BuildContext context) {
    final localText = AppLocalizations.of(context)!;
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: FutureBuilder(
            future: fetchData ? widget.isRequest ? _fetchRandomUsers() : _fetchUser(widget.userId) : null,
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
                              title: '${localText.play_dialog_exit_title}',
                              content: '${localText.play_dialog_exit_content}',
                              defaultActionText: '${localText.no}',
                              destructiveActionText: '${localText.yes}',
                              destructiveActionOnPressed: () {
                                showInterstitialAd();
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                            );
                          },
                          icon: Icon(Icons.cancel),
                          iconSize: 48,
                          color: Colors.black.withOpacity(0.5),
                        ),
                        Text(
                          '${localText.cancel}',
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                final userData = snapshot.data?[userIndex];
                final top = getTopPercentage(context.watch<RankingData>().rankedUsersCount, userData['index']);
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ProfileAvatar(
                        avatarData: userData['avatar'],
                        width: 128,
                        height: 128,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16, bottom: 16),
                        child: Text(
                          '${userData['username']}',
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.5),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        getRankNameFromCode(userRank),
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.5),
                          fontSize: 16,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 32, bottom: 32),
                        child: isStart ? Column(
                          children: [
                            Text(
                              '${localText.play_select}',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black.withOpacity(0.75),
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
                                        fetchData = false;
                                      });
                                    },
                                    child: Text('✊',
                                      style: TextStyle(
                                        fontSize: 48,
                                        color: handIndex == 1 ? null : Colors.black.withOpacity(0.5),
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        handIndex = 2;
                                        fetchData = false;
                                      });
                                    },
                                    child: Text('✌️',
                                      style: TextStyle(
                                        fontSize: 48,
                                        color: handIndex == 2 ? null : Colors.black.withOpacity(0.5),
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        handIndex = 3;
                                        fetchData = false;
                                      });
                                    },
                                    child: Text('🖐️',
                                      style: TextStyle(
                                        fontSize: 48,
                                        color: handIndex == 3 ? null : Colors.black.withOpacity(0.5),
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
                                      isStart = false;
                                      handIndex = 0;
                                      fetchData = false;
                                    });
                                  },
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.arrow_back,
                                        color: Colors.white,
                                      ),
                                      Text('${localText.back}'),
                                    ],
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey,
                                    foregroundColor: Colors.white,
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
                                            '${context.read<MyInfo>().username}',
                                            '🚩 ${lookupAppLocalizations(Locale(userData['lang'] ?? 'en')).push_msg_body_match_req}',
                                            {'type': 'match_from'}
                                        );
                                        context.read<MatchDataTo>().fetch();
                                        Navigator.pop(context);
                                      }).onError((error, stackTrace) {
                                        showAlertDialog(
                                          context,
                                          title: '${localText.play_dialog_already_title}',
                                          content: '${localText.play_dialog_already_content}',
                                          defaultActionText: '${localText.cancel}',
                                          destructiveActionText: '${localText.play_dialog_already_action}',
                                          destructiveActionOnPressed: () {
                                            setState(() {
                                              isStart = false;
                                              handIndex = 0;
                                              fetchData = false;
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
                                    showInterstitialAd();
                                  },
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.check,
                                        color: Colors.white,
                                      ),
                                      Text('${localText.confirm}'),
                                    ],
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ) : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  isStart = true;
                                  fetchData = false;
                                });
                              },
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.flag,
                                    size: 64,
                                    color: Colors.white,
                                  ),
                                  Text('${localText.play_btn_start}'),
                                ],
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  userIndex = ++userIndex < snapshot.data!.length ? userIndex : 0;
                                  fetchData = userIndex == 0 ? true : false;
                                });
                              },
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.refresh,
                                    size: 64,
                                    color: Colors.white,
                                  ),
                                  Text('${localText.play_btn_reload}'),
                                ],
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                              ),
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
                                  title: '${localText.play_dialog_exit_title}',
                                  content: '${localText.play_dialog_exit_content}',
                                  defaultActionText: '${localText.no}',
                                  destructiveActionText: '${localText.yes}',
                                  destructiveActionOnPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                );
                              },
                              icon: Icon(Icons.cancel),
                              iconSize: 48,
                              color: Colors.black.withOpacity(0.5),
                            ),
                            Text(
                              '${localText.cancel}',
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.5),
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
                  child: Text('Loading...'),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}