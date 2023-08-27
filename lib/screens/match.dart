import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../widgets/match_list_item.dart';
import '../utilities/supabase_util.dart';
import '../screens/play.dart';

class Match extends StatelessWidget {
  const Match({super.key});

  void _showAlertDialog(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Cancel Match'),
        content: const Text('Are you cancel this game?'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('No'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  Future<List<dynamic>> _fetch() async {
    final List<dynamic> topTen = await supabase.from('top_ten').select('username, img_url, rank');
    return topTen;
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
          FutureBuilder(
            future: _fetch(),
            builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.hasData) {
                return Expanded(
                  child: TabBarView(
                    children: [
                      ListView.builder(
                        itemCount: snapshot.data?.length,
                        itemBuilder: (BuildContext context, int index) {
                          return MatchListItem(
                            userName: snapshot.data?[index]['username'],
                            imgUrl: snapshot.data?[index]['img_url'],
                            description: 'Touch to Accept',
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Play(userId: snapshot.data?[index]['id'], isRequest: false)));
                            },
                          );
                        },
                      ),
                      ListView.builder(
                        itemCount: snapshot.data?.length,
                        itemBuilder: (BuildContext context, int index) {
                          return MatchListItem(
                            userName: snapshot.data?[index]['username'],
                            imgUrl: snapshot.data?[index]['img_url'],
                            description: 'Touch to Cancel',
                            onTap: () {
                              _showAlertDialog(context);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                );
              }
              else {
                return Center(
                  child: Text(
                    'Loading...',
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}