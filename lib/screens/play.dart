import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:math';
import '../constants.dart';
import '../widgets/profile_image.dart';
import './result.dart';

class Play extends StatefulWidget {
  const Play({super.key, this.userId = '', required this.isRequest});

  final String userId;
  final bool isRequest;

  @override
  State<Play> createState() => _PlayState();
}

class _PlayState extends State<Play> {
  bool isStart = false;
  int handIndex = 0;
  String dummyUserId = '';

  void _showAlertDialog(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Exit'),
        content: const Text('Are you exit this game?'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('No'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  @override
  initState() {
    super.initState();
    isStart = !widget.isRequest;
    dummyUserId = widget.isRequest ? Random().nextInt(10).toString() : widget.userId;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future(() => false);
      },
      child: Scaffold(
        body: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: rankColorGradient(DUMMY_USER_DATA[dummyUserId]['rank']),
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ProfileImage(
                  userName: DUMMY_USER_DATA[dummyUserId]['username'],
                  width: 64,
                  height: 64,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 16),
                  child: Text(
                    '@${DUMMY_USER_DATA[dummyUserId]['username']}',
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.5),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  DUMMY_USER_DATA[dummyUserId]['rank'],
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.5),
                    fontSize: 16,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 32, bottom: 32),
                  child: isStart ? Column(
                    children: [
                      Text(
                        'Choose your hand',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black.withOpacity(0.75),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8, bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  handIndex = 1;
                                });
                              },
                              child: Text(
                                '✊',
                                style: TextStyle(
                                  fontSize: 48,
                                  color: handIndex == 1 ? null : Colors.black.withOpacity(0.5),
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  handIndex = 2;
                                });
                              },
                              child: Text('✌️',
                                style: TextStyle(
                                  fontSize: 48,
                                  color: handIndex == 2 ? null : Colors.black.withOpacity(0.5),
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  handIndex = 3;
                                });
                              },
                              child: Text('🖐️',
                                style: TextStyle(
                                  fontSize: 48,
                                  color: handIndex == 3 ? null : Colors.black.withOpacity(0.5),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: !widget.isRequest ? null : () {
                              setState(() {
                                isStart = false;
                                handIndex = 0;
                              });
                            },
                            child: Column(
                              children: [
                                Icon(
                                  Icons.arrow_back,
                                ),
                                Text('Back'),
                              ],
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: handIndex == 0 ? null : () {
                              Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Result(result: 'win')));
                            },
                            child: Column(
                              children: [
                                Icon(
                                  Icons.check,
                                ),
                                Text('Confirm'),
                              ],
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ) : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isStart = true;
                          });
                        },
                        child: Column(
                          children: [
                            Icon(
                              Icons.flag,
                              size: 64,
                            ),
                            Text('Start Game'),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            dummyUserId = Random().nextInt(10).toString();
                          });
                        },
                        child: Column(
                          children: [
                            Icon(
                              Icons.refresh,
                              size: 64,
                            ),
                            Text('Find Again'),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 64),
                  child: Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          _showAlertDialog(context);
                        },
                        icon: Icon(Icons.cancel),
                        iconSize: 48,
                        color: Colors.black.withOpacity(0.5),
                      ),
                      Text(
                        'Cancel Match',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}