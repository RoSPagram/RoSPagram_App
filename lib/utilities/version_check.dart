import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'supabase_util.dart';

Future<String?> checkAppVersion(BuildContext context) async {
  try {
    final packageInfo = await PackageInfo.fromPlatform();
    final currentVersion = packageInfo.version;

    final response = await supabase.from('app_config').select().limit(1).single();

    final requiredVersion = response['required_version'];
    final storeUrl = response[Platform.isAndroid ? 'play_store_url' : 'app_store_url'];

    if (isUpdateRequired(currentVersion, requiredVersion)) {
      return storeUrl; // 업데이트 필요
    }
    return null; // 업데이트 불필요
  } catch (e) {
    print('Error checking app version: $e');
    return null; // 예외 발생 시 업데이트 불필요로 처리
  }
}

bool isUpdateRequired(String current, String required) {
  final currentParts = current.split('.').map(int.parse).toList();
  final requiredParts = required.split('.').map(int.parse).toList();

  for (int i = 0; i < requiredParts.length; i++) {
    if (i >= currentParts.length || currentParts[i] < requiredParts[i]) {
      return true;
    }
  }
  return false;
}
