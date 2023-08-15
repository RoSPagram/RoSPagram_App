import 'package:flutter/material.dart';
import './profile_image.dart';

class MatchListItem extends StatelessWidget {
  const MatchListItem({super.key, required this.profileImgUrl, required this.userName, required this.description});

  final String profileImgUrl;
  final String userName;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 3.0,
            spreadRadius: 0.0,
            offset: const Offset(0, 1),
          )
        ],
      ),
      child: Material(
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ProfileImage(
                  imgUrl: 'https://picsum.photos/200',
                  width: 48,
                  height: 48,
                ),
                Flexible(
                  fit: FlexFit.tight,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: Text(
                          '@${this.userName}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        this.description,
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ],
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