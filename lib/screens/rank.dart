import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../screens/user_profile.dart';
import '../providers/my_info.dart';
import '../providers/ranking_data.dart';
import '../widgets/rank_header.dart';
import '../widgets/rank_list_item.dart';
import '../utilities/supabase_util.dart';
import '../utilities/username_generator.dart';

class Rank extends StatelessWidget {
  const Rank({super.key});

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
        context.watch<RankingData>().list.isEmpty ? Center(child: Text('No ranked users')) : Expanded(
          child: ListView.builder(
            itemCount: context.watch<RankingData>().list.length,
            itemBuilder: (BuildContext context, int index) {
              return RankListItem(
                index: context.watch<RankingData>().list[index]['index'],
                avatarData: context.watch<RankingData>().list[index]['avatar'],
                userName: context.watch<RankingData>().list[index]['username'],
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserProfile(userId: context.read<RankingData>().list[index]['id']),
                      )
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}