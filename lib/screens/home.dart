import 'package:flutter/material.dart';
import '../widgets/profile_header.dart';
import '../widgets/win_loss_record.dart';

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
          userRank: 'Unranked',
        ),
        WinLossRecord(
          padding: EdgeInsets.all(16),
        ),
      ],
    );
  }
}