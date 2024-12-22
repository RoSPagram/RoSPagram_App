import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ranking_data.dart';
import '../constants.dart';
import './profile_image.dart';
import '../utilities/avatar_util.dart';
import '../widgets/profile_avatar.dart';

class RankListItem extends StatelessWidget {
  const RankListItem({
    super.key,
    required this.index,
    required this.avatarData,
    required this.userName,
    required this.onTap,
  });

  final int index;
  final String? avatarData;
  final String userName;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    final top = getTopPercentage(context.watch<RankingData>().rankedUsersCount, this.index);
    final userRank = getUserRank(top);
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: rankColorGradient(userRank),
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 5.0,
              spreadRadius: 0.0,
              offset: const Offset(0, 1),
            )
          ]
      ),
      child: Material(
        child: InkWell(
          onTap: this.onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.only(top: 16, bottom: 16, right: 8, left: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '#${this.index}',
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.5),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Column(
                  children: [
                    // ProfileImage(
                    //   url: this.imgUrl,
                    //   width: 32,
                    //   height: 32,
                    // ),
                    ProfileAvatar(
                      avatarData: avatarData,
                      width: 48,
                      height: 48,
                    ),
                    Text(
                      '@${this.userName}',
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.75),
                      ),
                    ),
                  ],
                ),
                Text(
                  getRankNameFromCode(userRank),
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
        ),
        color: Colors.transparent,
      ),
    );
  }
}