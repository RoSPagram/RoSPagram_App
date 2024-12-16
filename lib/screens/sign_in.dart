import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:ntp/ntp.dart';
import 'package:intl/intl.dart';
import '../providers/my_info.dart';
import '../utilities/shared_prefs.dart';
import '../utilities/instagram_service.dart';
import '../utilities/supabase_util.dart';
import '../utilities/username_generator.dart';
import './auth_webview.dart';
import './main_screen.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  Future<bool> _fetch(BuildContext context) async {
    // String? oldToken = SharedPrefs.instance.getString('user_token');
    // if (oldToken == null) return false;
    //
    // final newToken = await InstagramService().refreshUserToken(oldToken);
    // final userProfile = await InstagramService().getUserInfo(newToken);
    // if (userProfile['id'] == null) return false;
    //
    // final String? userImgUrl = await InstagramService().getUserProfileImgUrl(userProfile['username']);

    String? storedUUID = SharedPrefs.instance.getString('uuid');
    if (storedUUID == null) return false;

    // final userData = await supabase.rpc('get_user_data', params: {'user_id': userProfile['id']});
    final userData = await supabase.rpc('get_user_data', params: {'user_id': storedUUID});
    if (userData.length == 0) return false;

    // await supabase.from('users').update({
    //   'username': userProfile['username'],
    //   'img_url': userImgUrl ?? userData[0]['img_url'],
    // }).eq('id', userProfile['id']);

    // context.read<MyInfo>().id = userProfile['id'];
    // context.read<MyInfo>().username = userProfile['username'];
    // context.read<MyInfo>().img_url = userImgUrl ?? userData[0]['img_url'];
    NTP.now().then((time) async {
      final date = DateFormat('yyyy-MM-dd').format(time);
      if (userData[0]['last_login'] == date) return;
      await supabase.rpc('set_last_login', params: {'user_id': storedUUID});
    });

    context.read<MyInfo>().id = userData[0]['id'];
    context.read<MyInfo>().username = userData[0]['username'];
    context.read<MyInfo>().img_url = userData[0]['img_url'];
    context.read<MyInfo>().index = userData[0]['index'];
    context.read<MyInfo>().win = userData[0]['win'];
    context.read<MyInfo>().loss = userData[0]['loss'];
    context.read<MyInfo>().draw = userData[0]['draw'];
    context.read<MyInfo>().notifyListeners();

    return true;
  }

  @override
  Widget build(BuildContext context) {
    Text loadingText = Text(
      'Loading...',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 24,
      ),
    );

    FilledButton signInButton = FilledButton(
      style: FilledButton.styleFrom(backgroundColor: Color(0xff000000)),
      child: Text('Sign in'),
      onPressed: () {
        // Navigator.push(context, MaterialPageRoute(builder: (context) => AuthWebView()));
      },
    );

    FilledButton guestButton = FilledButton(
      style: FilledButton.styleFrom(backgroundColor: Color(0xffdfdfdf), foregroundColor: Color(0xff000000)),
      child: Text('Start as Guest'),
      onPressed: () async {
        final newUUID = Uuid().v4();
        final newUserName = getRandomName();
        //https://www.dicebear.com/styles/thumbs/
        final newImgUrl = 'https://api.dicebear.com/9.x/thumbs/png?seed=$newUUID&scale=75';
        context.read<MyInfo>().id = newUUID;
        context.read<MyInfo>().username = newUserName;
        context.read<MyInfo>().img_url = newImgUrl;

        SharedPrefs.instance.setString('uuid', newUUID);

        await supabase.from('users').insert({
          'id': newUUID,
          'username': newUserName,
          'img_url': newImgUrl,
          'fcm_token': SharedPrefs.instance.getString('fcm_token')
        });

        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainScreen()), (route) => false);
      },
    );

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Text(
                    'Ro',
                    style: TextStyle(fontSize: 48, fontWeight: FontWeight.w900),
                  ),
                  Text(
                    'ck ✊',
                    style: TextStyle(fontSize: 48, fontWeight: FontWeight.w300),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'S',
                    style: TextStyle(fontSize: 48, fontWeight: FontWeight.w900),
                  ),
                  Text(
                    'cissors ✌️',
                    style: TextStyle(fontSize: 48, fontWeight: FontWeight.w300),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Pa',
                    style: TextStyle(fontSize: 48, fontWeight: FontWeight.w900),
                  ),
                  Text(
                    'per 🖐️',
                    style: TextStyle(fontSize: 48, fontWeight: FontWeight.w300),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.only(top: 64),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '✉️ tele',
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.w300),
                    ),
                    Text(
                      'gram',
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 128),
                child: FutureBuilder(
                  future: _fetch(context),
                  builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                    if (snapshot.hasData) {
                      if(snapshot.data ?? false) {
                        Future.microtask(() => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainScreen()), (route) => false));
                        return loadingText;
                      }
                      else return guestButton;
                      // else return signInButton;
                    }
                    else return loadingText;
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