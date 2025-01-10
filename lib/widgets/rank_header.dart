import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../constants.dart';
import './profile_avatar.dart';
import '../providers/my_info.dart';
import '../providers/ranking_data.dart';

class RankHeader extends StatelessWidget {
  const RankHeader({super.key, required this.onTap});

  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    final localText = AppLocalizations.of(context)!;
    return Consumer2<RankingData, MyInfo>(
      builder: (context, rankingData, myInfo, child) {
        final top = getTopPercentage(rankingData.rankedUsersCount, myInfo.index);
        final userRank = getUserRank(top);
        return Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: rankColorGradient(userRank),
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(64), bottomRight: Radius.circular(64)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 5.0,
                  spreadRadius: 0.0,
                  offset: const Offset(0, 1),
                )
              ]
          ),
          child: child,
        );
      },
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: this.onTap,
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(64), bottomRight: Radius.circular(64)),
          child: Padding(
            padding: EdgeInsets.only(top: 16, bottom: 16, right: 8, left: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  flex: 1,
                  child: Consumer<MyInfo>(
                    builder: (context, myInfo, child) {
                      return Text(
                        myInfo.index == 0 ? '---' : '#${myInfo.index}',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.5),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      );
                    },
                  ),
                ),
                Flexible(
                    flex: 1,
                    child: Column(
                      children: [
                        Consumer<MyInfo>(
                          builder: (context, myInfo, child) {
                            return ProfileAvatar(
                              avatarData: jsonDecode(myInfo.avatarData),
                              width: 32,
                              height: 32,
                            );
                          },
                        ),
                        Consumer<MyInfo>(
                          builder: (context, myInfo, child) {
                            return Text(
                              '${myInfo.username}',
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.75),
                              ),
                            );
                          },
                        ),
                        Consumer2<RankingData, MyInfo>(
                          builder: (context, rankingData, myInfo, child) {
                            final top = getTopPercentage(rankingData.rankedUsersCount, myInfo.index);
                            final userRank = getUserRank(top);
                            return Text(
                              getRankNameFromCode(userRank),
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.5),
                              ),
                            );
                          },
                        ),
                      ],
                    )
                ),
                Flexible(
                  flex: 1,
                  child: Column(
                    children: [
                      Text(
                        localText.top,
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.5),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Consumer2<RankingData, MyInfo>(
                        builder: (context, rankingData, myInfo, child) {
                          final top = getTopPercentage(rankingData.rankedUsersCount, myInfo.index);
                          return Text(
                            top == 0 ? '---' : '${top.toStringAsFixed(2)}%',
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.5),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}