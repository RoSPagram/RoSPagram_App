import 'package:flutter/material.dart';
import './profile_image.dart';
import '../constants.dart';

class ProfileHeader extends StatefulWidget {
  const ProfileHeader({super.key, required this.profileImgUrl, required this.userName, required this.userRank});

  final String profileImgUrl;
  final String userName;
  final String userRank;

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(top: 32, bottom: 32),
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: rankColorGradient(widget.userRank),
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
      child: Center(
        child: Column(
          children: [
            ProfileImage(
              imgUrl: widget.profileImgUrl,
              width: 64,
              height: 64,
            ),
            Padding(
              padding: EdgeInsets.only(top: 8, bottom: 8),
              child: Text(
                widget.userName,
                style: TextStyle(
                  color: Colors.black.withOpacity(0.5),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              widget.userRank,
              style: TextStyle(
                color: Colors.black.withOpacity(0.5),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}