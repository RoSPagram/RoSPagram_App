import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/match_list_item.dart';
import '../utilities/supabase_util.dart';
import '../utilities/alert_dialog.dart';
import '../screens/play.dart';
import '../screens/result.dart';
import '../providers/my_info.dart';

class Match extends StatefulWidget {
  const Match({super.key});

  @override
  State<Match> createState() => _MatchState();
}

class _MatchState extends State<Match> {
  Future<List<dynamic>> _fetch(BuildContext context, String type) async {
    final List<dynamic> matchData = await supabase.rpc('get_match_${type}', params: {'user_id': context.read<MyInfo>().id});
    return matchData;
  }

  @override
  Widget build(BuildContext context) {
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
          const TabBar(
            indicatorColor: Colors.black,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            tabs: <Tab>[
              Tab(text: 'From'),
              Tab(text: 'To'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                FutureBuilder(
                  future: _fetch(context, 'from'),
                  builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
                    if (snapshot.hasData) {
                      final List<dynamic>? matchDataFrom = snapshot.data;
                      if (matchDataFrom?.length == 0) return Center(child: Text('No matches'));
                      return ListView.builder(
                        itemCount: matchDataFrom?.length,
                        itemBuilder: (BuildContext context, int index) {
                          return MatchListItem(
                            userName: matchDataFrom?[index]['username'],
                            imgUrl: matchDataFrom?[index]['img_url'],
                            description: 'Touch to Accept',
                            desciptionColor: Colors.red,
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Play(userId: matchDataFrom?[index]['id'], isRequest: false)));
                            },
                          );
                        },
                      );
                    }
                    else return Center(
                      child: Text('Loading...'),
                    );
                  },
                ),
                FutureBuilder(
                  future: _fetch(context, 'to'),
                  builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
                    if (snapshot.hasData) {
                      final List<dynamic>? matchDataTo = snapshot.data;
                      if (matchDataTo?.length == 0) return Center(child: Text('No Matches'));
                      return ListView.builder(
                        itemCount: matchDataTo?.length,
                        itemBuilder: (BuildContext context, int index) {
                          return MatchListItem(
                            userName: matchDataTo?[index]['username'],
                            imgUrl: matchDataTo?[index]['img_url'],
                            description: matchDataTo?[index]['respond'] == 0 ? 'Touch to Cancel' : 'Touch to show result',
                            desciptionColor: matchDataTo?[index]['respond'] == 0 ? Colors.red : Colors.green,
                            onTap: () {
                              if (matchDataTo?[index]['respond'] == 0) {
                                showAlertDialog(
                                  context,
                                  title: 'Cancel Match',
                                  content: 'Are you cancel this game?',
                                  defaultActionText: 'No',
                                  destructiveActionText: 'Yes',
                                  destructiveActionOnPressed: () {
                                    supabase.from('match').delete().match({
                                      'from': context.read<MyInfo>().id,
                                      'to': matchDataTo?[index]['id']
                                    }).then((_) {
                                      setState(() {});
                                      Navigator.pop(context);
                                    });
                                  },
                                );
                              }
                              else {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => Result(from: context.read<MyInfo>().id, to: matchDataTo?[index]['id'])));
                              }
                            },
                          );
                        },
                      );
                    }
                    else return Center(
                      child: Text('Loading...'),
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