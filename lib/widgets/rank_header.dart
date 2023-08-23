import 'package:flutter/material.dart';
import '../constants.dart';
import './profile_image.dart';
import '../screens/user_profile.dart';

class RankHeader extends StatelessWidget {
  const RankHeader({super.key, required this.index, required this.userName, required this.userRank});

  final int index;
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
          child: Padding(
            padding: EdgeInsets.only(top: 16, bottom: 16, right: 8, left: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  flex: 1,
                  child: Text(
                    '#${this.index}',
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.5),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                Flexible(
                    flex: 1,
                    child: Column(
                      children: [
                        ProfileImage(
                          userName: this.userName,
                          width: 32,
                          height: 32,
                        ),
                        Text(
                          '@${this.userName}',
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.75),
                          ),
                        ),
                        Text(
                          this.userRank,
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ),
                      ],
                    )
                ),
                Flexible(
                  flex: 1,
                  child: Column(
                    children: [
                      Text(
                        'TOP',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.5),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '10%',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.5),
                        ),
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