import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../widgets/match_list_item.dart';
import '../screens/play.dart';

class Match extends StatelessWidget {
  const Match({super.key});

  static const List<String> dummyUserName = ['user', 'user123', 'user123456', 'user123456789', 'user123456789101112', 'WWWWWWWWWWWWWWWWWWWWWWWWWWWWWW', 'user', 'user', 'user', 'user', 'user'];

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
                ListView.builder(
                  itemCount: dummyUserName.length,
                  itemBuilder: (BuildContext context, int index) {
                    return MatchListItem(
                      profileImgUrl: 'https://picsum.photos/200',
                      userName: dummyUserName[index],
                      description: 'Touch to Accept',
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Play(isRequest: false)));
                      },
                    );
                  },
                ),
                ListView.builder(
                  itemCount: dummyUserName.length,
                  itemBuilder: (BuildContext context, int index) {
                    return MatchListItem(
                      profileImgUrl: 'https://picsum.photos/200',
                      userName: dummyUserName[index],
                      description: 'Touch to Cancel',
                      onTap: () {
                        _showAlertDialog(context);
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