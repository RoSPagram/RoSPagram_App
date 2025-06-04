import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ntp/ntp.dart';
import 'package:rospagram/l10n/app_localizations.dart';

class SeasonTimer extends StatefulWidget {
  const SeasonTimer({super.key});

  @override
  State<SeasonTimer> createState() => _SeasonTimerState();
}

class _SeasonTimerState extends State<SeasonTimer> {
  Timer? _timer;
  DateTime? _serverTime;
  Duration? _remainingTime;

  @override
  void initState() {
    super.initState();
    _initializeTime();
  }

  Future<void> _initializeTime() async {
    try {
      _serverTime = await NTP.now();
      _startTimer();
    } catch (e) {
      // 에러 처리: NTP 시간 가져오기 실패 시 로컬 시간 사용 또는 에러 메시지 표시
      _serverTime = DateTime.now();
      _startTimer();
      print('NTP 시간 가져오기 실패: $e, 로컬 시간 사용');
    }
  }

  DateTime _getNextMonthFirstDay(DateTime currentTime) {
    // 현재 시간 기준으로 다음달 1일 0시 0분 0초를 UTC 기준으로 계산
    DateTime nextMonth = DateTime.utc(currentTime.year, currentTime.month + 1, 1);
    return DateTime.utc(nextMonth.year, nextMonth.month, 1, 0, 0, 0);
  }

  void _updateRemainingTime(Timer timer) {
    if (_serverTime == null) return;

    setState(() {
      final nextMonthFirstDay = _getNextMonthFirstDay(_serverTime!);
      _remainingTime = nextMonthFirstDay.difference(_serverTime!);

      if (_remainingTime!.isNegative) {
        // 남은 시간이 음수이면 다음달 1일이 이미 지났으므로, 다시 계산
        _serverTime = _serverTime!.toUtc().add(Duration(seconds: 1)); // 서버 시간 1초 증가 (UTC 기준)
        _remainingTime = _getNextMonthFirstDay(_serverTime!).difference(_serverTime!);
      } else if (_remainingTime == Duration.zero) {
        _timer?.cancel();
        _timer = null;
      } else {
        _serverTime = _serverTime!.toUtc().add(Duration(seconds: 1)); // 서버 시간 1초 증가 (UTC 기준)
      }
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), _updateRemainingTime);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Color _getTextColor(Duration remaining) {
    if (remaining.inDays < 1) {
      return Colors.red; // 1일 미만
    } else if (remaining.inDays < 3) {
      return Colors.deepOrangeAccent; // 3일 미만
    } else if (remaining.inDays < 7) {
      return Colors.amber.shade700; // 7일 미만
    } else if (remaining.inDays < 14) {
      return Colors.teal; // 14일 미만
    } else {
      return Colors.blueAccent;
    }
  }

  String _formatDuration(AppLocalizations localText, Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String days = duration.inDays.toString();
    String hours = twoDigits(duration.inHours.remainder(24));
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$days${localText.season_timer_days} $hours${localText.season_timer_hours} $minutes${localText.season_timer_minutes} $seconds${localText.season_timer_seconds}';
  }

  @override
  Widget build(BuildContext context) {
    final localText = AppLocalizations.of(context)!;
    return _remainingTime == null ? SizedBox.shrink() : Container(
      padding: EdgeInsets.all(4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            localText.season_timer_until, // 이 부분은 l10n에 추가해야 합니다.
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 16,),
          Text(
            _formatDuration(localText, _remainingTime!),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: _getTextColor(_remainingTime!),
            ),
          ),
        ],
      ),
    );
  }
}
