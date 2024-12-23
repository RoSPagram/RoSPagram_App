import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../utilities/firebase_util.dart';
import '../providers/my_info.dart';
import '../providers/match_data_from.dart';
import '../providers/match_data_to.dart';
import '../providers/ranking_data.dart';
import './home.dart';
import './match.dart';
import './rank.dart';
import './shop.dart';
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
    const Shop(),
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
      // showFlutterNotification(message);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Column(
          children: [
            Text('${message.notification?.title}',style: TextStyle(fontWeight: FontWeight.bold)),
            Text('${message.notification?.body}'),
          ],
        )),
      );
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
    int matchFromLen = context.watch<MatchDataFrom>().list.length;
    int matchToLen = context.watch<MatchDataTo>().list.length;
    final localText = AppLocalizations.of(context)!;
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '${localText.main_screen_navbar_home}',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                Icon(Icons.flag),
                if (matchFromLen != 0 || matchToLen != 0)
                Positioned(
                  top: 0,
                  right: 0,
                  child: SizedBox(
                    width: 10,
                    height: 10,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                )
              ],
            ),
            label: '${localText.main_screen_navbar_match}',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.stacked_bar_chart),
            label: '${localText.main_screen_navbar_rank}',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_basket_rounded),
            label: '${localText.main_screen_navbar_shop}',
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