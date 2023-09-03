import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../widgets/profile_image.dart';
import '../utilities/supabase_util.dart';
import '../utilities/alert_dialog.dart';
import '../providers/my_info.dart';
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
  bool fetchData = true;
  int handIndex = 0;
  int userIndex = 0;

  Future<List<dynamic>> _fetchRandomUsers() async {
    final List<dynamic> usersData = await supabase.rpc('find_users_to_match', params: {'sender_id': context.read<MyInfo>().id});
    return usersData;
  }

  Future<List<dynamic>> _fetchUser(String userId) async {
    final List<dynamic> userData = await supabase.rpc('get_user_data', params: {'user_id': userId});
    return userData;
  }

  @override
  initState() {
    super.initState();
    isStart = !widget.isRequest;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future(() => false);
      },
      child: Scaffold(
        body: SafeArea(
          child: FutureBuilder(
            future: fetchData ? widget.isRequest ? _fetchRandomUsers() : _fetchUser(widget.userId) : null,
            builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.hasData) {
                final userData = snapshot.data?[userIndex];
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: rankColorGradient(userData['rank']),
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ProfileImage(
                        url: userData['img_url'],
                        width: 64,
                        height: 64,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16, bottom: 16),
                        child: Text(
                          '@${userData['username']}',
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.5),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        getRankNameFromCode(userData['rank']),
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
                                        fetchData = false;
                                      });
                                    },
                                    child: Text('✊',
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
                                        fetchData = false;
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
                                        fetchData = false;
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
                                      fetchData = false;
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
                                    if (widget.isRequest) {
                                      supabase.from('match').insert({
                                        'from': context.read<MyInfo>().id,
                                        'to': userData['id'],
                                        'send': handIndex
                                      }).then((_) => Navigator.pop(context)).onError((error, stackTrace) {
                                        showAlertDialog(
                                          context,
                                          title: 'Already in Progress',
                                          content: 'You are already playing with this user',
                                          defaultActionText: 'Cancel',
                                          destructiveActionText: 'Find others',
                                          destructiveActionOnPressed: () {
                                            setState(() {
                                              isStart = false;
                                              handIndex = 0;
                                              fetchData = false;
                                            });
                                            Navigator.pop(context);
                                          },
                                        );
                                      });
                                    }
                                    else {
                                      supabase.from('match').update({
                                        'respond': handIndex,
                                      }).match({'from': widget.userId, 'to': context.read<MyInfo>().id})
                                      .then((_) {
                                        Navigator.pop(context);
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => Result(from: widget.userId, to: context.read<MyInfo>().id)));
                                      });
                                    }
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
                                  fetchData = false;
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
                                  userIndex = ++userIndex < snapshot.data!.length ? userIndex : 0;
                                  fetchData = userIndex == 0 ? true : false;
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
                                showAlertDialog(
                                  context,
                                  title: 'Exit',
                                  content: 'Are you exit this game?',
                                  defaultActionText: 'No',
                                  destructiveActionText: 'Yes',
                                  destructiveActionOnPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                );
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
                );
              }
              else {
                return Center(
                  child: Text('Loading...'),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}