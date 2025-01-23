import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../constants.dart';
import '../utilities/supabase_util.dart';
import '../providers/ranking_data.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/level_view.dart';
import '../widgets/win_loss_record.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key, required this.userId});

  final String userId;

  Future<List<dynamic>> _fetch() async {
    final userData = await supabase.rpc('get_user_data', params: {'user_id': this.userId});
    return userData;
  }

  @override
  Widget build(BuildContext context) {
    final localText = AppLocalizations.of(context)!;
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: _fetch(),
          builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.hasData) {
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
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.all(16),
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.close,
                            color: Colors.black.withValues(alpha: 0.5),
                            size: 32,
                          ),
                        ),
                      ),
                      // ProfileImage(
                      //   url: userData['img_url'],
                      //   width: 64,
                      //   height: 64,
                      // ),
                      ProfileAvatar(
                        avatarData: jsonDecode(userData['avatar']),
                        width: 150,
                        height: 150,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Text(
                          '${userData['username']}',
                          style: TextStyle(
                            color: Colors.black.withValues(alpha: 0.5),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      LevelView(xp: userData['xp']),
                      Consumer<RankingData>(
                        builder: (context, rankingData, child) {
                          final top = getTopPercentage(rankingData.rankedUsersCount, userData['index']);
                          final userRank = getUserRank(top);
                          return Text(
                            getRankNameFromCode(userRank),
                            style: TextStyle(
                              color: Colors.black.withValues(alpha: 0.5),
                              fontSize: 16,
                            ),
                          );
                        },
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 32, bottom: 32),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text(
                                  localText.ranking,
                                  style: TextStyle(
                                    color: Colors.black.withValues(alpha: 0.5),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  '#${userData['index']}',
                                  style: TextStyle(
                                    color: Colors.black.withValues(alpha: 0.5),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  localText.top,
                                  style: TextStyle(
                                    color: Colors.black.withValues(alpha: 0.5),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                Consumer<RankingData>(
                                  builder: (context, rankingData, child) {
                                    final top = getTopPercentage(rankingData.rankedUsersCount, userData['index']);
                                    return Text(
                                      top == 0 ? '---' : '${top.toStringAsFixed(2)}%',
                                      style: TextStyle(
                                        color: Colors.black.withValues(alpha: 0.5),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Text(
                      //   'Win-Loss Record',
                      //   style: TextStyle(
                      //     color: Colors.black.withValues(alpha: 0.5),
                      //     fontWeight: FontWeight.w500,
                      //     fontSize: 20,
                      //   ),
                      // ),
                      WinLossRecord(
                        win: userData['win'],
                        loss: userData['loss'],
                        draw: userData['draw'],
                        margin: EdgeInsets.all(16),
                      ),
                      // ElevatedButton(
                      //   onPressed: () {
                      //     sendPushMessage(
                      //         userData['fcm_token'],
                      //         '${myInfo.username}',
                      //         '${lookupAppLocalizations(Locale(userData['lang'] ?? 'en')).test_msg}'
                      //     );
                      //   },
                      //   child: Text('SEND_TEST_NOTIFICATION'),
                      // ),
                    ],
                  ),
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
    );
  }
}