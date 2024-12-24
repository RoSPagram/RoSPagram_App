import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'supabase_util.dart';

Future<String> getRandomName(BuildContext context) async {
  final currentLang = Localizations.localeOf(context).languageCode;
  final localText = AppLocalizations.of(context)!;
  final res = await supabase.rpc('get_random_adjective');
  return '${res[0][currentLang]}${localText.finger}${Random().nextInt(10000).toString().padLeft(4, '0')}';
}