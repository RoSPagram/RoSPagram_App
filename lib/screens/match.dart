import 'package:flutter/material.dart';
import '../widgets/match_list_item.dart';

class Match extends StatelessWidget {
  const Match({super.key});

  static const List<String> dummyUserName = ['user', 'user123', 'user123456', 'user123456789', 'user123456789101112', 'WWWWWWWWWWWWWWWWWWWWWWWWWWWWWW', 'user', 'user', 'user', 'user', 'user'];

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