import 'package:flutter/material.dart';
import '../constants.dart';
import './profile_image.dart';

class RankListItem extends StatefulWidget {
  const RankListItem({super.key, required this.index, required this.userName, required this.userRank});

  final int index;
  final String userName;
  final String userRank;

  @override
  State<RankListItem> createState() => _RankListItemState();
}

class _RankListItemState extends State<RankListItem> {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: rankColorGradient(widget.userRank),
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
          child: Padding(
            padding: EdgeInsets.only(top: 16, bottom: 16, right: 8, left: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '#${widget.index}',
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.5),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Column(
                  children: [
                    ProfileImage(
                      imgUrl: 'https://picsum.photos/200',
                      width: 32,
                      height: 32,
                    ),
                    Text(
                      '@${widget.userName}',
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.75),
                      ),
                    ),
                  ],
                ),
                Text(
                  widget.userRank,
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