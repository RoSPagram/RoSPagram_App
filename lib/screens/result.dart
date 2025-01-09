import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../providers/my_info.dart';
import '../providers/match_data_from.dart';
import '../providers/match_data_to.dart';
import '../providers/ranking_data.dart';
import '../providers/gem_data.dart';
import '../utilities/supabase_util.dart';
import '../utilities/firebase_util.dart';
import '../utilities/ad_util.dart';
import '../widgets/profile_avatar.dart';

class Result extends StatelessWidget {
  const Result({super.key, required this.from, required this.to});

  final String from, to;

  Future<List<dynamic>> _fetch(bool isSender) async {
    final List<dynamic> resultData = await supabase.from('match').select().match({'from': this.from, 'to': this.to});
    final List<dynamic> opponentData = await supabase.rpc('get_user_data', params: {'user_id': isSender ? this.to : this.from});
    return [resultData[0], opponentData[0]];
  }

  String getResult(int me, int opponent) {
    if (me == 1) return opponent == 1 ? 'draw' : opponent == 2 ? 'win' : 'lose';
    if (me == 2) return opponent == 1 ? 'lose' : opponent == 2 ? 'draw' : 'win';
    if (me == 3) return opponent == 1 ? 'win' : opponent == 2 ? 'lose' : 'draw';
    return 'draw';
  }

  String getHandEmoji(int handIndex) {
    return handIndex == 1 ? '✊' : handIndex == 2 ? '✌️' : '🖐️';
  }

  @override
  Widget build(BuildContext context) {
    final localText = AppLocalizations.of(context)!;
    final myInfo = context.read<MyInfo>();
    final matchFrom = context.read<MatchDataFrom>();
    final matchTo = context.read<MatchDataTo>();
    final rankingData = context.read<RankingData>();
    final gemData = context.read<GemData>();
    final isSender = myInfo.id == this.from ? true : false;

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: FutureBuilder(
            future: _fetch(isSender),
            builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.hasData) {
                final resultData = snapshot.data?[0];
                final opponentData = snapshot.data?[1];
                final result = isSender ? getResult(resultData['send'], resultData['respond']) : getResult(resultData['respond'], resultData['send']);

                FutureOr<dynamic> updateResult(dynamic _) {
                  myInfo.fetch();
                  matchFrom.fetch();
                  rankingData.fetch();
                  gemData.fetch();
                  sendPushMessage(
                      opponentData['fcm_token'],
                      '${myInfo.username}',
                      result == 'win' ? '😭 ${lookupAppLocalizations(Locale(opponentData['lang'] ?? 'en')).push_msg_body_result_loss}' : result == 'lose' ? '🏆 ${lookupAppLocalizations(Locale(opponentData['lang'] ?? 'en')).push_msg_body_result_win}' : '😯 ${lookupAppLocalizations(Locale(opponentData['lang'] ?? 'en')).push_msg_body_result_draw}',
                      {'type': 'match_to', 'user_id': this.to}
                  );
                }

                if (isSender) {
                  supabase.rpc('delete_finished_match', params: {'from_id': this.from, 'to_id': this.to}).then((_) {
                    matchTo.fetch();
                    myInfo.fetch();
                    rankingData.fetch();
                    gemData.fetch();
                  });
                }
                else {
                  switch(result) {
                    case 'win':
                      supabase.rpc('set_win_loss', params: {'winner_id': this.to, 'loser_id': this.from}).then(updateResult);
                      break;
                    case 'lose':
                      supabase.rpc('set_win_loss', params: {'winner_id': this.from, 'loser_id': this.to}).then(updateResult);
                      break;
                    default:
                      supabase.rpc('set_draw', params: {'id1': this.from, 'id2': this.to}).then(updateResult);
                  }
                }

                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: result == 'win'?
                      [Color(0xFF428BCA), Color(0xFFD6E7F6)]
                          : result == 'lose' ?
                      [Color(0xFFD9534F), Color(0xFFFAD6D5)]
                          : result == 'draw' ?
                      [Color(0xFF888888), Color(0xFFE7E7E7)]
                          : [Color(0xFFFFFFFF)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ProfileAvatar(
                        avatarData: jsonDecode(opponentData['avatar']),
                        width: 128,
                        height: 128,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Text(
                          '${opponentData['username']}',
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.5),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        isSender ? getHandEmoji(resultData['respond']) : getHandEmoji(resultData['send']),
                        style: TextStyle(
                          fontSize: 48,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(
                          result == 'win'? '${localText.result_text_win}' : result == 'lose' ? '${localText.result_text_lose }' : '${localText.result_text_draw}',
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.5),
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        isSender ? getHandEmoji(resultData['send']) : getHandEmoji(resultData['respond']),
                        style: TextStyle(
                          fontSize: 48,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: IconButton(
                          onPressed: () {
                            requestRewardedInterstitialAd();
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.exit_to_app_rounded, size: 48, color: Colors.black.withOpacity(0.5)),
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