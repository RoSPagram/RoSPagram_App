import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/my_info.dart';
import '../widgets/rank_header.dart';
import '../widgets/rank_list_item.dart';
import '../constants.dart';

class Rank extends StatelessWidget {
  const Rank({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RankHeader(
          index: 10,
          userName: context.watch<MyInfo>().username,
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
            itemCount: DUMMY_USER_DATA.length,
            itemBuilder: (BuildContext context, int index) {
              return RankListItem(
                index: index + 1,
                userName: DUMMY_USER_DATA[index.toString()]['username'],
                userRank: DUMMY_USER_DATA[index.toString()]['rank'],
              );
            },
          ),
        ),
      ],
    );
  }
}