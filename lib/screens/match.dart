import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../widgets/match_list_item.dart';
import '../widgets/counter_badge.dart';
import '../utilities/supabase_util.dart';
import '../utilities/alert_dialog.dart';
import '../screens/play.dart';
import '../screens/result.dart';
import '../providers/my_info.dart';
import '../providers/match_data_from.dart';
import '../providers/match_data_to.dart';

class Match extends StatelessWidget {
  const Match({super.key});

  @override
  Widget build(BuildContext context) {
    final localText = AppLocalizations.of(context)!;
    final myInfo = context.read<MyInfo>();

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              '🚩 ${localText.match_title}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
          // ElevatedButton(
          //   onPressed: () {
          //     supabase.rpc('create_test_match', params: {'user_id': myInfo.id}).then((_) {
          //       from.fetch();
          //     });
          //   },
          //   child: Text('CREATE_TEST_MATCH'),
          // ),
          // ElevatedButton(
          //   onPressed: () {
          //     supabase.from('match').delete().not('respond', 'eq', 0).then((_) {
          //       from.fetch();
          //     });
          //   },
          //   child: Text('CLEAR_FINISH_MATCHES'),
          // ),
          TabBar(
            indicatorColor: Colors.black,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            tabs: <Widget>[
              Consumer<MatchDataFrom>(
                builder: (context, from, child) {
                  return Tab(
                    text: '${localText.match_tab_from}',
                    icon: from.list.isNotEmpty ? CounterBadge(value: from.list.length) : SizedBox.shrink(),
                  );
                },
              ),
              Consumer<MatchDataTo>(
                builder: (context, to, child) {
                  return Tab(
                    text: '${localText.match_tab_to}',
                    icon: to.list.isNotEmpty ? CounterBadge(value: to.list.length) : SizedBox.shrink(),
                  );
                },
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                Consumer<MatchDataFrom>(
                  builder: (context, from, child) {
                    return from.list.isEmpty ? Center(child: Text('${localText.match_no}')) : ListView.builder(
                      itemCount: from.list.length,
                      itemBuilder: (BuildContext context, int index) {
                        return MatchListItem(
                          userName: from.list[index]['username'],
                          avatarData: from.list[index]['avatar'],
                          description: '${localText.match_item_from_desc}',
                          desciptionColor: Colors.red,
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Play(userId: from.list[index]['id'], isRequest: false)));
                          },
                        );
                      },
                    );
                  },
                ),
                Consumer<MatchDataTo>(
                  builder: (context, to, child) {
                    return to.list.isEmpty ? Center(child: Text('${localText.match_no}')) : ListView.builder(
                      itemCount: to.list.length,
                      itemBuilder: (BuildContext context, int index) {
                        return MatchListItem(
                          userName: to.list[index]['username'],
                          avatarData: to.list[index]['avatar'],
                          description: to.list[index]['respond'] == 0 ? '${localText.match_item_to_desc_cancel}' : '${localText.match_item_to_desc_show}',
                          desciptionColor: to.list[index]['respond'] == 0 ? Colors.red : Colors.green,
                          onTap: () {
                            if (context.read<MatchDataTo>().list[index]['respond'] == 0) {
                              showAlertDialog(
                                context,
                                title: '${localText.match_dialog_cancel_title}',
                                content: '${localText.match_dialog_cancel_content}',
                                defaultActionText: '${localText.no}',
                                destructiveActionText: '${localText.yes}',
                                destructiveActionOnPressed: () {
                                  supabase.from('match').delete().match({
                                    'from': context.read<MyInfo>().id,
                                    'to': to.list[index]['id']
                                  }).then((_) {
                                    to.fetch();
                                    Navigator.pop(context);
                                  });
                                },
                              );
                            }
                            else {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Result(from: myInfo.id, to: to.list[index]['id'])));
                            }
                          },
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}