import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../providers/my_info.dart';
import '../providers/match_data_from.dart';
import '../providers/match_data_to.dart';
import '../providers/ranking_data.dart';
import './home.dart';
import './match.dart';
import './rank.dart';
import './social.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    const Home(),
    const Match(),
    const Rank(),
    const Social(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  initState() {
    super.initState();
    context.read<MatchDataFrom>().fetch();
    context.read<MatchDataTo>().fetch();
    context.read<RankingData>().fetch();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      switch (message.data['type']) {
        case 'match_from':
          context.read<MatchDataFrom>().fetch();
          break;
        case 'match_to':
          context.read<MatchDataTo>().fetch();
          context.read<MyInfo>().fetch();
          context.read<RankingData>().fetch();
          break;
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const<BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flag),
            label: 'Match',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.stacked_bar_chart),
            label: 'Rank',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.groups),
            label: 'Social',
          )
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}