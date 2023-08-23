import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/profile_header.dart';
import '../widgets/win_loss_record.dart';
import '../providers/my_info.dart';
import './play.dart';

class Home extends StatelessWidget {
  const Home({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfileHeader(
          userName: context.watch<MyInfo>().name,
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
        ),
        Text('Your ID : ${context.watch<MyInfo>().id}'),
      ],
    );
  }
}