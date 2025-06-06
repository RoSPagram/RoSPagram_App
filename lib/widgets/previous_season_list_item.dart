import 'dart:convert';
import 'package:flutter/material.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/win_loss_record.dart';

class PreviousSeasonListItem extends StatelessWidget {
  const PreviousSeasonListItem({
    super.key,
    required this.index,
    required this.avatarData,
    required this.userName,
    required this.win,
    required this.loss,
    required this.draw,
  });

  final int index;
  final String avatarData;
  final String userName;
  final int win, loss, draw;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 5.0,
              spreadRadius: 0.0,
              offset: const Offset(0, 1),
            )
          ]
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 4, right: 8),
                  child: index == 1 || index == 2 || index == 3 ? Text(
                    index == 1 ? '🥇' : index == 2 ? '🥈' : index == 3 ? '🥉' : '#$index',
                    style: TextStyle(
                      fontSize: 32,
                    ),
                  ) : Text(
                    '#$index',
                    style: TextStyle(
                      color: Colors.black.withValues(alpha: 0.5),
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 16),
                            child: ProfileAvatar(
                              avatarData: jsonDecode(avatarData),
                              width: 64,
                              height: 64,
                            ),
                          ),
                          Expanded(
                              child: Center(
                                child: Text(
                                  userName,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              )
                          ),
                        ],
                      ),
                      WinLossRecord(win: win, loss: loss, draw: draw, padding: EdgeInsets.only(top: 8),),
                    ],
                  ),
                ),
              ],
            ),
          ],
        )
      ),
    );
  }
}