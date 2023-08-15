import 'package:flutter/material.dart';
import './profile_image.dart';
import '../constants.dart';
import '../screens/user_profile.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.profileImgUrl, required this.userName, required this.userRank});

  final String profileImgUrl;
  final String userName;
  final String userRank;

  @override
  Widget build(BuildContext context) {
    void _onTap() {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => UserProfile(userName: this.userName, userRank: this.userRank)
          )
      );
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: rankColorGradient(this.userRank),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _onTap,
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(64), bottomRight: Radius.circular(64)),
          child: Center(
            child: Container(
              padding: EdgeInsets.only(top: 32, bottom: 32),
              child: Column(
                children: [
                  ProfileImage(
                    imgUrl: this.profileImgUrl,
                    width: 64,
                    height: 64,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8, bottom: 8),
                    child: Text(
                      this.userName,
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    this.userRank,
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.5),
                      fontSize: 16,
                    ),
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