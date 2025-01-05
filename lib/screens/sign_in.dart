import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:ntp/ntp.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../providers/my_info.dart';
import '../utilities/avatar_util.dart';
import '../utilities/shared_prefs.dart';
import '../utilities/supabase_util.dart';
import '../utilities/username_generator.dart';
import './main_screen.dart';

LinearProgressIndicator loadingIndicator = LinearProgressIndicator(
  color: Colors.black12,
);

class StartButton extends StatefulWidget {
  const StartButton({super.key});

  @override
  State<StartButton> createState() => _StarButtonState();
}

class _StarButtonState extends State<StartButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final localText = AppLocalizations.of(context)!;
    return _isLoading ? loadingIndicator : FilledButton(
      style: FilledButton.styleFrom(backgroundColor: Color(0xff000000), foregroundColor: Color(0xffffffff)),
      child: Text('${localText.sign_in_start}'),
      onPressed: () async {
        setState(() {
          _isLoading = true;
        });
        final newUUID = Uuid().v4();
        final newUserName = await getRandomName(context);
        Avatar avatar = new Avatar();
        avatar.applyRandom();
        context.read<MyInfo>().id = newUUID;
        context.read<MyInfo>().username = newUserName;
        context.read<MyInfo>().avatarData = jsonEncode(avatar.toJSON());
        context.read<MyInfo>().fcm_token = SharedPrefs.instance.getString('fcm_token')!;

        SharedPrefs.instance.setString('uuid', newUUID);

        final time = await NTP.now();
        final date = DateFormat('yyyy-MM-dd').format(time);

        await supabase.from('users').insert({
          'id': newUUID,
          'username': newUserName,
          'avatar': context.read<MyInfo>().avatarData,
          'fcm_token': context.read<MyInfo>().fcm_token,
          'last_login': date,
          'lang': Localizations.localeOf(context).languageCode,
        });

        context.read<MyInfo>().notifyListeners();

        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainScreen()), (route) => false);
      },
    );
  }
}

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  Future<bool> _fetch(BuildContext context) async {

    String? storedUUID = SharedPrefs.instance.getString('uuid');
    if (storedUUID == null) return false;
    final userData = await supabase.rpc('get_user_data', params: {'user_id': storedUUID});
    if (userData.length == 0) return false;

    final Map<String, dynamic> updates = {};

    String? fcmToken = SharedPrefs.instance.getString('fcm_token');
    if (userData[0]['fcm_token'] == null || userData[0]['fcm_token'] != fcmToken) {
      updates['fcm_token'] = fcmToken;
    }

    if (userData[0]['avatar'] == null) {
      Avatar avatar = new Avatar();
      avatar.applyRandom();
      updates['avatar'] = jsonEncode(avatar.toJSON());
    }

    final currentLang = Localizations.localeOf(context).languageCode;
    if (userData[0]['lang'] != currentLang) {
      updates['lang'] = currentLang;
    }

    final time = await NTP.now();
    final date = DateFormat('yyyy-MM-dd').format(time);
    if (userData[0]['last_login'] != date) {
      updates['last_login'] = date;
    }

    if (updates.isNotEmpty) {
      supabase.from('users').update(updates).eq('id', storedUUID).then((_) {});
    }

    context.read<MyInfo>().id = userData[0]['id'];
    context.read<MyInfo>().username = userData[0]['username'];
    context.read<MyInfo>().avatarData = userData[0]['avatar'] ?? updates['avatar'];
    context.read<MyInfo>().index = userData[0]['index'];
    context.read<MyInfo>().win = userData[0]['win'];
    context.read<MyInfo>().loss = userData[0]['loss'];
    context.read<MyInfo>().draw = userData[0]['draw'];
    context.read<MyInfo>().fcm_token = userData[0]['fcm_token'] ?? fcmToken;
    context.read<MyInfo>().notifyListeners();

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final localText = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                localText.sign_in_title,
                style: TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              Container(
                padding: EdgeInsets.only(top: 32),
                child: SvgPicture.asset(
                  'assets/default_avatar.svg',
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 32),
                child: FutureBuilder(
                  future: _fetch(context),
                  builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                    if (snapshot.hasData) {
                      if(snapshot.data ?? false) {
                        Future.microtask(() => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainScreen()), (route) => false));
                        return loadingIndicator;
                      }
                      else return StartButton();
                      // else return signInButton;
                    }
                    else return loadingIndicator;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}