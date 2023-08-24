import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../widgets/match_list_item.dart';
import '../screens/play.dart';
import '../constants.dart';

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
                  itemCount: DUMMY_USER_DATA.length,
                  itemBuilder: (BuildContext context, int index) {
                    return MatchListItem(
                      userName: DUMMY_USER_DATA[index.toString()]['username'],
                      description: 'Touch to Accept',
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Play(userId: index.toString(), isRequest: false)));
                      },
                    );
                  },
                ),
                ListView.builder(
                  itemCount: DUMMY_USER_DATA.length,
                  itemBuilder: (BuildContext context, int index) {
                    return MatchListItem(
                      userName: DUMMY_USER_DATA[index.toString()]['username'],
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