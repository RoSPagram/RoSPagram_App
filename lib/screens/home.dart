import 'package:flutter/material.dart';
import '../widgets/profile_header.dart';
import '../widgets/win_loss_record.dart';
import './play.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfileHeader(
          profileImgUrl: 'https://picsum.photos/200',
          userName: 'UserName',
          userRank: 'Diamond',
        ),
        WinLossRecord(
          padding: EdgeInsets.all(16),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Play(isRequest: true))
            );
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(32),
            primary: Colors.deepOrange,
          ),
          child: Column(
            children: [
              Text(
                'Start game',
                style: TextStyle(
                  fontSize: 32,
                ),
              ),
              Text(
                '👤',
                style: TextStyle(
                  fontSize: 32,
                ),
              ),
              Text(
                'with a random user',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}