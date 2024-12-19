import 'package:ntp/ntp.dart';
import 'supabase_util.dart';

class TokenManager {
  static const int MAX_TOKENS = 5;
  static const Duration RECHARGE_INTERVAL = Duration(minutes: 10, milliseconds: 500);

  final String userId;

  int _tokenCount = 0;
  DateTime? _lastUpdated;
  DateTime? _currentTime;

  int get tokenCount => _tokenCount;
  DateTime? get lastUpdated => _lastUpdated;
  DateTime? get currentTime => _currentTime;

  TokenManager({required this.userId});

  /// 현재 시간을 duration 만큼 업데이트
  void updateCurrentTime(Duration duration) {
    _currentTime = _currentTime?.add(duration);
  }

  /// 현재 시간을 서버 시간으로 동기화
  Future<void> syncServerTime() async {
    _currentTime = await NTP.now();
  }

  /// 초기 데이터 로딩
  Future<void> initialize() async {
    // NTP를 통한 서버 시간 가져오기
    await syncServerTime();

    final response = await supabase.from('user_tokens').select().eq('id', userId);

    if (response.length == 0) {
      // 해당 유저 정보가 없으면 기본 값으로 삽입
      _tokenCount = MAX_TOKENS;
      _lastUpdated = _currentTime;
      await supabase.from('user_tokens').insert({
        'id': userId,
        'count': _tokenCount,
        'last_updated': _lastUpdated!.toIso8601String()
      });
    } else {
      final data = response[0];
      _tokenCount = data['count'] as int;
      _lastUpdated = DateTime.parse(data['last_updated'] as String);
    }

    await rechargeTokensIfNeeded();
  }

  /// 토큰 충전 로직
  Future<void> rechargeTokensIfNeeded() async {
    if (_currentTime == null || _lastUpdated == null) return;

    await syncServerTime();
    final diff = _currentTime!.difference(_lastUpdated!);
    if (diff.inMinutes >= 10 && _tokenCount < MAX_TOKENS) {
      _rechargeTokens(diff);
    }
  }

  void _rechargeTokens(Duration diff) {
    int tokensToAdd = diff.inMinutes ~/ 10;
    int newTokenCount = _tokenCount + tokensToAdd;
    if (newTokenCount > MAX_TOKENS) {
      newTokenCount = MAX_TOKENS;
    }

    if (newTokenCount != _tokenCount) {
      _tokenCount = newTokenCount;
      _lastUpdated = _lastUpdated!.add(Duration(minutes: tokensToAdd * 10));

      supabase.from('user_tokens').update({
        'count': _tokenCount,
        'last_updated': _lastUpdated!.toIso8601String()
      }).eq('id', userId).then((_) {});
    }
  }

  /// 토큰 사용
  Future<bool> useToken() async {
    // await syncServerTime();
    // 사용 전에 토큰 충전 기회가 있는지 체크 (optional)
    await rechargeTokensIfNeeded();

    if (_tokenCount > 0) {
      if (tokenCount == 5) _lastUpdated = _currentTime!;
      _tokenCount -= 1;
      await supabase.from('user_tokens').update({
        'count': _tokenCount,
        'last_updated': _lastUpdated!.toIso8601String()
      }).eq('id', userId);
      return true;
    } else {
      return false;
    }
  }

  /// 다음 토큰 충전까지 남은 시간 계산
  Duration? timeUntilNextToken() {
    if (_tokenCount >= MAX_TOKENS || _currentTime == null || _lastUpdated == null) {
      return null;
    }

    final nextRechargeTime = _lastUpdated!.add(RECHARGE_INTERVAL);
    final remaining = nextRechargeTime.difference(_currentTime!);
    return remaining.isNegative ? Duration.zero : remaining;
  }
}