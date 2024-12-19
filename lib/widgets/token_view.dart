import 'dart:async';
import 'package:flutter/material.dart';
import '../screens/play.dart';
import '../utilities/supabase_util.dart';
import '../utilities/token_manager.dart';
import '../utilities/alert_dialog.dart';

class TokenView extends StatefulWidget {
  final String userId;
  const TokenView({Key? key, required this.userId}) : super(key: key);

  @override
  State<TokenView> createState() => _TokenViewState();
}

class _TokenViewState extends State<TokenView> {
  late TokenManager tokenManager;

  bool _isLoading = true;
  Timer? _timer;
  DateTime? _prevTime;
  Duration? remaining;

  @override
  void initState() {
    super.initState();
    tokenManager = TokenManager(userId: widget.userId);
    _initData();
  }

  Future<void> _initData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await tokenManager.initialize();
    } catch (e) {
      debugPrint('Error initializing token data: $e');
    } finally {
      setState(() {
        _isLoading = false;
        remaining = tokenManager.timeUntilNextToken();
        if (remaining != null) _startTimer();
      });
    }
  }

  void _startTimer() {
    // 타이머 시작 전 현재 시간 기록
    _prevTime = DateTime.now();

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      // 매초 콜백: 현재 시간과 prevTime 차이 계산
      final now = DateTime.now();
      final elapsed = now.difference(_prevTime!);
      _prevTime = now; // prevTime 업데이트

      // tokenManager에 시간 경과 업데이트
      tokenManager.updateCurrentTime(elapsed);

      setState(() {
        // remaining 값 갱신
        remaining = tokenManager.timeUntilNextToken();
        if (remaining == null) {
          // 남은 시간이 null이면 타이머 종료
          _timer?.cancel();
          _timer = null;
        }
        else if (remaining == Duration.zero) {
          tokenManager.rechargeTokensIfNeeded();
        }
      });
    });
  }

  Future<void> _useToken() async {
    bool success = await tokenManager.useToken();
    Navigator.pop(context); // Close alert dialog
    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No tokens!')),
      );
      return;
    }
    setState(() {
      remaining = tokenManager.timeUntilNextToken();
      if (remaining != null && _timer == null) {
        _startTimer();
      }
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Play(isRequest: true))
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Text tokenWidget(int num) {
    return Text(
      tokenManager.tokenCount > num ? '🪙' : '⚪',
      style: TextStyle(
        fontSize: 24,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 8, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _isLoading ? Center(child: CircularProgressIndicator()) : Center(
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
                Text('⚡', style: TextStyle(fontSize: 16)),
                Text(
                  '${remaining!.inMinutes.toString().padLeft(2, '0')}:${(remaining!.inSeconds % 60).toString().padLeft(2, '0')}',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ElevatedButton(
            onPressed: () {
              if (_isLoading) return;
              showAlertDialog(
                context,
                title: 'Play',
                content: 'Start with a token?\n🪙 -1',
                defaultActionText: 'No',
                destructiveActionText: 'Yes',
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
                  'Play',
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
                Text(
                  'with a random user',
                  style: TextStyle(
                    fontSize: 18,
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