import 'dart:convert';
import 'package:flutter/material.dart';
import 'profile_avatar.dart';

class UserGridItem extends StatelessWidget {
  const UserGridItem({
    super.key,
    required this.userName,
    required this.avatarData,
    required this.onTap,
  });

  final String userName;
  final String avatarData;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
          // gradient: LinearGradient(
          //   colors: rankColorGradient(userRank),
          //   begin: Alignment.topCenter,
          //   end: Alignment.bottomCenter,
          // ),
        color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 5.0,
              spreadRadius: 0.0,
              offset: const Offset(0, 1),
            )
          ]
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: EdgeInsets.all(8),
                child: ProfileAvatar(
                  avatarData: jsonDecode(avatarData),
                  width: 96,
                  height: 96,
                ),
              ),
              Text(
                userName,
                style: TextStyle(
                  color: Colors.black.withValues(alpha: 0.75),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}