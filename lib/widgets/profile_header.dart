import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './profile_avatar.dart';
import './win_loss_record.dart';
import '../constants.dart';
import '../providers/my_info.dart';
import '../providers/ranking_data.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.onTap});

  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
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
          child: Center(
            child: Container(
              padding: EdgeInsets.only(top: 32, bottom: 8),
              child: Column(
                children: [
                  Consumer<MyInfo>(
                    builder: (context, myInfo, child) {
                      return ProfileAvatar(
                        avatarData: jsonDecode(myInfo.avatarData),
                        width: 100,
                        height: 100,
                      );
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8, bottom: 8),
                    child: Consumer<MyInfo>(
                      builder: (context, myInfo, child) {
                        return Text(
                          '${myInfo.username}',
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.5),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                  Consumer2<RankingData, MyInfo>(
                    builder: (context, rankingData, myInfo, child) {
                      final top = getTopPercentage(rankingData.rankedUsersCount, myInfo.index);
                      final userRank = getUserRank(top);
                      return Text(
                        getRankNameFromCode(userRank),
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.5),
                          fontSize: 16,
                        ),
                      );
                    },
                  ),
                  Consumer<MyInfo>(
                    builder: (context, myInfo, child) {
                      return WinLossRecord(
                        win: myInfo.win,
                        loss: myInfo.loss,
                        draw: myInfo.draw,
                        padding: EdgeInsets.only(top: 8, left: 16, right: 16),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}