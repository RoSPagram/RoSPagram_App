import 'package:flutter/material.dart';
import '../widgets/social_friend_list_item.dart';
import '../constants.dart';

class Social extends StatelessWidget {
  const Social({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            indicatorColor: Colors.black,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            tabs: <Tab>[
              Tab(text: 'Friends'),
              Tab(text: 'Request'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: DUMMY_USER_DATA.length,
                  itemBuilder: (BuildContext context, int index) {
                    return SocialFriendListItem(
                      userName: DUMMY_USER_DATA[index.toString()]['username'],
                      userRank: DUMMY_USER_DATA[index.toString()]['rank'],
                    );
                  },
                ),
                GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: DUMMY_USER_DATA.length,
                  itemBuilder: (BuildContext context, int index) {
                    return SocialFriendListItem(
                      isRequest: true,
                      userName: DUMMY_USER_DATA[index.toString()]['username'],
                      userRank: DUMMY_USER_DATA[index.toString()]['rank'],
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
