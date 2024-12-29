import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../screens/play.dart';
import '../providers/token_data.dart';
import '../utilities/alert_dialog.dart';

class TokenView extends StatefulWidget {
  const TokenView({Key? key}) : super(key: key);

  @override
  State<TokenView> createState() => _TokenViewState();
}

class _TokenViewState extends State<TokenView> {
  Timer? _timer;
  DateTime? _prevTime;
  Duration? remaining;

  @override
  void initState() {
    super.initState();
    setState(() {
      context.read<TokenData>().syncServerTime();
      _startTimer();
    });
  }

  void _updateRemainingTime(Timer? timer) {
    if (timer == null) return;
    // 매초 콜백: 현재 시간과 prevTime 차이 계산
    final now = DateTime.now();
    final elapsed = now.difference(_prevTime!);
    _prevTime = now; // prevTime 업데이트

    // 시간 경과 업데이트
    context.read<TokenData>().updateCurrentTime(elapsed);

    setState(() {
      // remaining 값 갱신
      remaining = context.read<TokenData>().timeUntilNextToken();
      if (remaining == null) {
        // 남은 시간이 null이면 타이머 종료
        _timer?.cancel();
        _timer = null;
      }
      else if (remaining == Duration.zero) {
        context.read<TokenData>().rechargeTokensIfNeeded();
      }
    });
  }

  void _startTimer() {
    // 타이머 시작 전 현재 시간 기록
    _prevTime = DateTime.now();
    _timer = Timer.periodic(Duration(seconds: 1), _updateRemainingTime);
  }

  Future<void> _useToken() async {
    bool success = await context.read<TokenData>().useToken();
    Navigator.pop(context); // Close alert dialog
    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.token_view_msg_no)),
      );
      return;
    }
    remaining = context.read<TokenData>().timeUntilNextToken();
    if (remaining != null && _timer == null) {
      _startTimer();
    }
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Play(isRequest: true))
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Text tokenWidget(int index) {
    return Text(
      context.read<TokenData>().count > index ? '🪙' : '⚪',
      style: TextStyle(
        fontSize: 24,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localText = AppLocalizations.of(context)!;
    return Container(
      padding: EdgeInsets.only(top: 8, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                tokenWidget(0),
                tokenWidget(1),
                tokenWidget(2),
                tokenWidget(3),
                tokenWidget(4),
              ],
            ),
          ),
          if (remaining != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('⚡', style: TextStyle(fontSize: 18)),
                Text(
                  '${remaining!.inMinutes.toString().padLeft(2, '0')}:${(remaining!.inSeconds % 60).toString().padLeft(2, '0')}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
          ElevatedButton(
            onPressed: () {
              showAlertDialog(
                context,
                title: '${localText.play_btn_dialog_title}',
                content: '${localText.play_btn_dialog_content}\n🪙 -1',
                defaultActionText: '${localText.no}',
                destructiveActionText: '${localText.yes}',
                destructiveActionOnPressed: _useToken,
              );
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.only(left: 48, right: 48),
              backgroundColor: Colors.deepOrange,
              foregroundColor: Colors.white,
            ),
            child: Column(
              children: [
                Text(
                  '${localText.play_btn_text}',
                  style: TextStyle(
                    fontSize: 32,
                  ),
                ),
                Text(
                  '🪙 -1',
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}