import 'package:flutter/material.dart';
import '../widgets/social_friend_list_item.dart';
import '../utilities/supabase_util.dart';
import '../screens/user_profile.dart';

class Social extends StatelessWidget {
  const Social({super.key});

  Future<List<dynamic>> _fetch() async {
    final List<dynamic> usersData = await supabase.from('top_ten').select('id, username, img_url, rank');
    return usersData;
  }

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
          FutureBuilder(
            future: _fetch(),
            builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.hasData) {
                return Expanded(
                  child: TabBarView(
                    children: [
                      GridView.builder(
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                        itemCount: snapshot.data?.length,
                        itemBuilder: (BuildContext context, int index) {
                          return SocialFriendListItem(
                            userName: snapshot.data?[index]['username'],
                            imgUrl: snapshot.data?[index]['img_url'],
                            userRank: snapshot.data?[index]['rank'],
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UserProfile(userId: snapshot.data?[index]['id']),
                                ),
                              );
                            },
                          );
                        },
                      ),
                      GridView.builder(
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.9,
                        ),
                        itemCount: snapshot.data?.length,
                        itemBuilder: (BuildContext context, int index) {
                          return SocialFriendListItem(
                            isRequest: true,
                            userName: snapshot.data?[index]['username'],
                            imgUrl: snapshot.data?[index]['img_url'],
                            userRank: snapshot.data?[index]['rank'],
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UserProfile(userId: snapshot.data?[index]['id']),
                                ),
                              );
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
                  child: Text('Loading...'),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
