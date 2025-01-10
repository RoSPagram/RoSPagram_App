import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utilities/ad_util.dart';
import '../screens/user_profile.dart';
import '../providers/my_info.dart';
import '../providers/ranking_data.dart';
import '../widgets/rank_header.dart';
import '../widgets/rank_list_item.dart';

class Rank extends StatelessWidget {
  const Rank({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RankHeader(
          onTap: () {
            requestRewardedInterstitialAd();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UserProfile(userId: context.read<MyInfo>().id),
                )
            );
          },
        ),
        // ElevatedButton(
        //   onPressed: () async {
        //     final newUUID = Uuid().v4();
        //     final newUserName = await getRandomName(context);
        //     await supabase.from('users').insert({
        //       'id': newUUID,
        //       'username': newUserName,
        //     });
        //     context.read<RankingData>().fetchTopten();
        //   },
        //   child: Text('CREATE_TEST_USER'),
        // ),
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
        Consumer<RankingData>(
          builder: (context, rankingData, child) {
            return rankingData.list.isEmpty ? Center(child: Text('No ranked users')) : Expanded(
              child: ListView.builder(
                itemCount: rankingData.list.length,
                itemBuilder: (BuildContext context, int index) {
                  return RankListItem(
                    index: rankingData.list[index]['index'],
                    avatarData: rankingData.list[index]['avatar'],
                    userName: rankingData.list[index]['username'],
                    onTap: () {
                      requestRewardedInterstitialAd();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserProfile(userId: rankingData.list[index]['id']),
                          )
                      );
                    },
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}