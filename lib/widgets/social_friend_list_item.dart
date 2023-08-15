import 'package:flutter/material.dart';
import '../constants.dart';
import './profile_image.dart';

class SocialFriendListItem extends StatelessWidget {
  const SocialFriendListItem({super.key, required this.profileImgUrl, required this.userName, required this.userRank, this.isRequest = false});

  final String profileImgUrl;
  final String userName;
  final String userRank;
  final bool isRequest;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: rankColorGradient(this.userRank),
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
          onTap: () {},
          borderRadius: BorderRadius.circular(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: EdgeInsets.all(8),
                child: ProfileImage(
                  imgUrl: this.profileImgUrl,
                  width: 48,
                  height: 48,
                ),
              ),
              Text(
                '@${this.userName}',
                style: TextStyle(
                  color: Colors.black.withOpacity(0.75),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),

              this.isRequest ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: const Icon(Icons.check),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Icon(Icons.close),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                  ),
                ],
              ) : SizedBox(),
            ],
          ),
        ),
        color: Colors.transparent,
      ),
    );
  }
}