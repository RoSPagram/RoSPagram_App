import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    final myInfo = context.read<MyInfo>();
    final from = context.read<MatchDataFrom>();
    final to = context.read<MatchDataTo>();

    int matchFromLen = context.watch<MatchDataFrom>().list.length;
    int matchToLen = context.watch<MatchDataTo>().list.length;

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              '🚩 Game Request',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              supabase.rpc('create_test_match', params: {'user_id': myInfo.id}).then((_) {
                from.fetch();
              });
            },
            child: Text('CREATE_TEST_MATCH'),
          ),
          ElevatedButton(
            onPressed: () {
              supabase.from('match').delete().not('respond', 'eq', 0).then((_) {
                from.fetch();
              });
            },
            child: Text('CLEAR_FINISH_MATCHES'),
          ),
          TabBar(
            indicatorColor: Colors.black,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            tabs: <Tab>[
              Tab(
                text: 'From',
                icon: matchFromLen > 0 ? CounterBadge(value: matchFromLen) : SizedBox.shrink(),
              ),
              Tab(
                text: 'To',
                icon: matchToLen > 0 ? CounterBadge(value: matchToLen) : SizedBox.shrink(),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                context.watch<MatchDataFrom>().list.isEmpty ? Center(child: Text('No Matches')) : ListView.builder(
                  itemCount: context.watch<MatchDataFrom>().list.length,
                  itemBuilder: (BuildContext context, int index) {
                    return MatchListItem(
                      userName: context.watch<MatchDataFrom>().list[index]['username'],
                      imgUrl: context.watch<MatchDataFrom>().list[index]['img_url'],
                      description: 'Touch to Accept',
                      desciptionColor: Colors.red,
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Play(userId: from.list[index]['id'], isRequest: false)));
                      },
                    );
                  },
                ),
                context.watch<MatchDataTo>().list.isEmpty ? Center(child: Text('No Matches')) : ListView.builder(
                  itemCount: context.watch<MatchDataTo>().list.length,
                  itemBuilder: (BuildContext context, int index) {
                    return MatchListItem(
                      userName: context.watch<MatchDataTo>().list[index]['username'],
                      imgUrl: context.watch<MatchDataTo>().list[index]['img_url'],
                      description: context.watch<MatchDataTo>().list[index]['respond'] == 0 ? 'Touch to Cancel' : 'Touch to show result',
                      desciptionColor: context.watch<MatchDataTo>().list[index]['respond'] == 0 ? Colors.red : Colors.green,
                      onTap: () {
                        if (context.read<MatchDataTo>().list[index]['respond'] == 0) {
                          showAlertDialog(
                            context,
                            title: 'Cancel Match',
                            content: 'Are you cancel this game?',
                            defaultActionText: 'No',
                            destructiveActionText: 'Yes',
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}