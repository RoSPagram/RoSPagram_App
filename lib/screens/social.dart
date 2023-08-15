import 'package:flutter/material.dart';
import '../widgets/social_friend_list_item.dart';

class Social extends StatefulWidget {
  const Social({super.key});

  @override
  State<Social> createState() => _SocialState();
}

class _SocialState extends State<Social> {
  static const List<String> dummyUserName = ['user1', 'user2', 'user3', 'user4', 'user5', 'user6', 'user7', 'user8', 'user9', 'WWWWWWWWWWWWWWWWWWWWWWWWWWWWWW'];
  static const List<String> dummyUserRank = ['Master', 'Master', 'Diamond', 'Diamond', 'Diamond', 'Diamond', 'Platinum', 'Platinum', 'Platinum', 'Platinum'];

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
                  itemCount: dummyUserName.length,
                  itemBuilder: (BuildContext context, int index) {
                    return SocialFriendListItem(
                      profileImgUrl: 'https://picsum.photos/200',
                      userName: dummyUserName[index],
                      userRank: dummyUserRank[index],
                    );
                  },
                ),
                GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: dummyUserName.length,
                  itemBuilder: (BuildContext context, int index) {
                    return SocialFriendListItem(
                      isRequest: true,
                      profileImgUrl: 'https://picsum.photos/200',
                      userName: dummyUserName[index],
                      userRank: dummyUserRank[index],
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
