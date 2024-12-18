import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../utilities/firebase_util.dart';
import '../providers/my_info.dart';
import '../providers/match_data_from.dart';
import '../providers/match_data_to.dart';
import '../providers/ranking_data.dart';
import './home.dart';
import './match.dart';
import './rank.dart';
import './social.dart';
import './result.dart';

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
    FirebaseMessaging.onMessage.listen((message) async {
      showFlutterNotification(message);
      switch (message.data['type']) {
        case 'match_from':
          context.read<MatchDataFrom>().fetch();
          break;
        case 'match_to':
          Navigator.push(context, MaterialPageRoute(builder: (context) => Result(from: context.read<MyInfo>().id, to: message.data['user_id'])));
          break;
      }
    });

    void _handleMessageFromBackground(RemoteMessage message) {
      switch (message.data['type']) {
        case 'match_from':
          context.read<MatchDataFrom>().fetch();
          setState(() {
            _selectedIndex = 1;
          });
          break;
        case 'match_to':
          setState(() {
            _selectedIndex = 1;
          });
          context.read<MatchDataTo>().fetch(() {
            context.read<MatchDataTo>().list.forEach((matchDataTo) {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Result(from: context.read<MyInfo>().id, to: matchDataTo['id'])));
            });
          });
          break;
      }
    }

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageFromBackground);
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) _handleMessageFromBackground(message);
    });
  }

  @override
  Widget build(BuildContext context) {
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