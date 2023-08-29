import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/user_profile.dart';
import '../utilities/supabase_util.dart';
import '../providers/my_info.dart';
import '../widgets/rank_header.dart';
import '../widgets/rank_list_item.dart';

class Rank extends StatelessWidget {
  const Rank({super.key});

  Future<List<dynamic>> _fetch() async {
    final List<dynamic> ranking = await supabase.from('top_ten').select('index, id, username, img_url, rank');
    return ranking;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RankHeader(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UserProfile(userId: context.read<MyInfo>().id),
                )
            );
          },
        ),
        Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            '🏆 TOP 10',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
        FutureBuilder(
          future: _fetch(),
          builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.hasData) {
              return Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (BuildContext context, int index) {
                    return RankListItem(
                      index: index + 1,
                      imgUrl: snapshot.data?[index]['img_url'],
                      userName: snapshot.data?[index]['username'],
                      userRank: snapshot.data?[index]['rank'],
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UserProfile(userId: snapshot.data?[index]['id']),
                            )
                        );
                      },
                    );
                  },
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
    );
  }
}