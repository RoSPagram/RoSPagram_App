import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:rospagram/l10n/app_localizations.dart';
import '../screens/play.dart';
import '../widgets/user_grid_item.dart';
import '../utilities/supabase_util.dart';
import '../utilities/alert_dialog.dart';
import '../utilities/ad_util.dart';
import '../providers/my_info.dart';
import '../providers/token_data.dart';

class RandomMatchList extends StatefulWidget {
  const RandomMatchList({super.key});

  @override
  State<RandomMatchList> createState() => _RandomMatchListState();
}

class _RandomMatchListState extends State<RandomMatchList> {
  List<dynamic> list = [];
  bool isLoaded = false;
  int _countdown = 0; // 카운트다운 시간
  Timer? _timer; // 타이머 인스턴스

  Future<List<dynamic>> fetchRandomUsers() async {
    final List<dynamic> usersData = await supabase.rpc('find_users_to_match', params: {'sender_id': context.read<MyInfo>().id});
    return usersData;
  }

  void afterLoaded(List<dynamic> data) {
    setState(() {
      list = data;
      isLoaded = true;
    });
  }

  void _startCountdown() {
    _timer?.cancel();
    setState(() {
      _countdown = 10; // 10초 카운트다운 시작
    });
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 0) {
          _countdown--;
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    fetchRandomUsers().then(afterLoaded);
  }

  @override
  void dispose() {
    _timer?.cancel(); // 위젯이 dispose될 때 타이머 취소
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localText = AppLocalizations.of(context)!;

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  localText.random_match_title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),
              Expanded(
                child: isLoaded ? GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: list.length,
                  itemBuilder: (BuildContext context, int index) {
                    return UserGridItem(
                      userName: list[index]['username'],
                      avatarData: list[index]['avatar'],
                      onTap: () {
                        showAlertDialog(
                          context,
                          title: list[index]['username'],
                          content: '${localText.random_match_dialog_content}?',
                          defaultActionText: localText.no,
                          destructiveActionText: localText.yes,
                          destructiveActionOnPressed: () async {
                            await context.read<TokenData>().useToken();
                            Navigator.pop(context);
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Play(userId: list[index]['id'], isRequest: true)));
                          },
                        );
                      },
                    );
                  },
                ) : Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(
                      color: Colors.black12,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            if (_countdown > 0) return;
                            if (!isLoaded) return;
                            isLoaded = false;
                            fetchRandomUsers().then(afterLoaded);
                            _startCountdown(); // 버튼 클릭 시 카운트다운 시작
                          },
                          icon: Icon(Icons.refresh),
                          iconSize: 48,
                          color: _countdown > 0 ? Colors.black12 : Colors.lightBlue,
                        ),
                        IgnorePointer(
                          ignoring: true, // 카운트다운 중일 때만 터치 이벤트 무시
                          child: Opacity(
                            opacity: _countdown > 0 ? 1.0 : 0.0,
                            child: Text(
                              '$_countdown',
                              style: TextStyle(
                                fontSize: 24, // 아이콘 크기에 맞춰 폰트 크기 조정
                                fontWeight: FontWeight.bold,
                                color: Colors.lightBlue,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        showAlertDialog(
                          context,
                          title: localText.play_dialog_exit_title,
                          content: localText.play_dialog_exit_content,
                          defaultActionText: localText.no,
                          destructiveActionText: localText.yes,
                          destructiveActionOnPressed: () {
                            requestRewardedInterstitialAd();
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                        );
                      },
                      icon: Icon(Icons.cancel),
                      iconSize: 48,
                      color: Colors.deepOrangeAccent,
                    ),
                  ],
                ),
              ),
              // Text(
              //   '${localText.cancel}',
              //   style: TextStyle(
              //     color: Colors.black.withValues(alpha: 0.5),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
