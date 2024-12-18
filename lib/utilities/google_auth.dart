import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:googleapis_auth/auth_io.dart';

Future<String> getAccessToken() async {
  // 서비스 계정 키 파일 로드
  final serviceAccount = await rootBundle.loadString('env/service-account-key.json');
  final Map<String, dynamic> key = json.decode(serviceAccount);

  // 서비스 계정 인증 정보 생성
  final accountCredentials = ServiceAccountCredentials.fromJson(key);

  // 요청할 OAuth 2.0 범위 정의
  const scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

  // 인증 클라이언트 생성
  final authClient = await clientViaServiceAccount(accountCredentials, scopes);

  // 액세스 토큰 반환
  return authClient.credentials.accessToken.data;
}
