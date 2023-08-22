import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/my_info.dart';
import '../widgets/rank_header.dart';
import '../widgets/rank_list_item.dart';

class Rank extends StatefulWidget {
  const Rank({super.key});

  State<Rank> createState() => _RankState();
}

class _RankState extends State<Rank> {

  static const List<String> dummyUserName = ['user1', 'user2', 'user3', 'user4', 'user5', 'user6', 'user7', 'user8', 'user9', 'UserName'];
  static const List<String> dummyUserRank = ['Master', 'Master', 'Diamond', 'Diamond', 'Diamond', 'Diamond', 'Platinum', 'Platinum', 'Platinum', 'Platinum'];
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RankHeader(
          index: 10,
          userName: context.watch<MyInfo>().name,
          userRank: 'Platinum',
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
        Expanded(
          child: ListView.builder(
            itemCount: dummyUserName.length,
            itemBuilder: (BuildContext context, int index) {
              return RankListItem(
                index: index + 1,
                userName: dummyUserName[index],
                userRank: dummyUserRank[index],
              );
            },
          ),
        ),
      ],
    );
  }
}