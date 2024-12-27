import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'supabase_util.dart';

Future<String> getRandomName(BuildContext context) async {
  final currentLang = Localizations.localeOf(context).languageCode;
  final localText = AppLocalizations.of(context)!;

  bool isNameExist = true;
  String name;

  do {
    final res = await supabase.rpc('get_random_adjective');
    name = '${res[0][currentLang]}${localText.finger}${Random().nextInt(10000).toString().padLeft(4, '0')}';
    isNameExist = await supabase.rpc('username_exist', params: {'name': name});
  }
  while(isNameExist);

  return name; 
}