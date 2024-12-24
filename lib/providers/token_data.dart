import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ntp/ntp.dart';
import '../utilities/supabase_util.dart';
import 'my_info.dart';

class TokenData extends ChangeNotifier {
  TokenData({required this.context});

  static const int MAX_TOKENS = 5;
  static const Duration RECHARGE_INTERVAL = Duration(minutes: 10, milliseconds: 500);

  final BuildContext context;
  int count = 0;
  DateTime? lastUpdated;
  DateTime? currentTime;

  @override
  void notifyListeners() {
    super.notifyListeners();
  }

  /// 현재 시간을 duration 만큼 업데이트
  void updateCurrentTime(Duration duration) {
    currentTime = currentTime?.add(duration);
  }

  /// 현재 시간을 서버 시간으로 동기화
  Future<void> syncServerTime() async {
    currentTime = await NTP.now();
  }

  /// 초기 데이터 로딩
  Future<void> fetch() async {
    // NTP를 통한 서버 시간 가져오기
    await syncServerTime();

    final response = await supabase.from('user_tokens').select().eq('id', context.read<MyInfo>().id);

    if (response.length == 0) {
      // 해당 유저 정보가 없으면 기본 값으로 삽입
      count = MAX_TOKENS;
      lastUpdated = currentTime;
      await supabase.from('user_tokens').insert({
        'id': context.read<MyInfo>().id,
        'count': count,
        'last_updated': lastUpdated!.toIso8601String()
      });
    } else {
      final data = response[0];
      count = data['count'] as int;
      lastUpdated = DateTime.parse(data['last_updated'] as String);
    }

    await rechargeTokensIfNeeded();
  }

  /// 토큰 충전 로직
  Future<void> rechargeTokensIfNeeded() async {
    if (currentTime == null || lastUpdated == null) return;

    await syncServerTime();
    final diff = currentTime!.difference(lastUpdated!);
    if (diff.inMinutes >= 10 && count < MAX_TOKENS) {
      _rechargeTokens(diff);
    }
  }

  void _rechargeTokens(Duration diff) {
    int tokensToAdd = diff.inMinutes ~/ 10;
    int newTokenCount = count + tokensToAdd;
    if (newTokenCount > MAX_TOKENS) {
      newTokenCount = MAX_TOKENS;
    }

    if (newTokenCount != count) {
      count = newTokenCount;
      lastUpdated = lastUpdated!.add(Duration(minutes: tokensToAdd * 10));

      supabase.from('user_tokens').update({
        'count': count,
        'last_updated': lastUpdated!.toIso8601String()
      }).eq('id', context.read<MyInfo>().id).then((_) {});
    }
  }

  /// 토큰 사용
  Future<bool> useToken() async {
    // await syncServerTime();
    // 사용 전에 토큰 충전 기회가 있는지 체크 (optional)
    await rechargeTokensIfNeeded();

    if (count > 0) {
      if (count == 5) lastUpdated = currentTime!;
      count -= 1;
      await supabase.from('user_tokens').update({
        'count': count,
        'last_updated': lastUpdated!.toIso8601String()
      }).eq('id', context.read<MyInfo>().id);
      return true;
    } else {
      return false;
    }
  }

  /// 다음 토큰 충전까지 남은 시간 계산
  Duration? timeUntilNextToken() {
    if (count >= MAX_TOKENS || currentTime == null || lastUpdated == null) {
      return null;
    }

    final nextRechargeTime = lastUpdated!.add(RECHARGE_INTERVAL);
    final remaining = nextRechargeTime.difference(currentTime!);
    return remaining.isNegative ? Duration.zero : remaining;
  }
}