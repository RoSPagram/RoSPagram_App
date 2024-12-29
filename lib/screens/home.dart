import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/profile_header.dart';
import '../widgets/token_view.dart';
import '../providers/my_info.dart';
import './user_profile.dart';

class Home extends StatelessWidget {
  const Home({super.key});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ProfileHeader(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserProfile(userId: context.read<MyInfo>().id),
                  )
              );
            },
          ),
          TokenView(),
          // Text('Your ID : ${context.watch<MyInfo>().id}'),
        ],
      ),
    );
  }
}