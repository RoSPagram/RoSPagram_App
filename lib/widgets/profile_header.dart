import 'package:flutter/material.dart';
import './profile_image.dart';

class ProfileHeader extends StatefulWidget {
  const ProfileHeader({super.key, required this.profileImgUrl, required this.userName, required this.userRank});

  final String profileImgUrl;
  final String userName;
  final String userRank;

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {

  List<Color> rankColorGradient(String userRank) {
    switch(userRank) {
      case 'Bronze':
        return [Color(0xFFCD7F32), Color(0xFFE6BF98)];
      case 'Silver':
        return [Color(0xFFC0C0C0), Color(0xFFDFDFDF)];
      case 'Gold':
        return [Color(0xFFFFD700), Color(0xFFFFEB7F)];
      case 'Platinum':
        return [Color(0xFFA0B2C6), Color(0xFFCFD8E2)];
      case 'Diamond':
        return [Color(0xFFB9F2FF), Color(0xFFDCF8FF)];
      case 'Master':
        return [Color(0xFFE0B0FF), Color(0xFFEFD7FF)];
      default:
        return [Color(0xFF70A1B6), Color(0xFFD4E2E9)];
    }
  }

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