import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/my_info.dart';
import '../utilities/shared_prefs.dart';
import '../utilities/instagram_service.dart';
import '../utilities/supabase_util.dart';
import './auth_webview.dart';
import './main_screen.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  Future<bool> _fetch(BuildContext context) async {
    String? oldToken = SharedPrefs.instance.getString('user_token');
    if (oldToken == null) return false;

    final newToken = await InstagramService().refreshUserToken(oldToken);
    final userProfile = await InstagramService().getUserInfo(newToken);
    if (userProfile['id'] == null) return false;

    final String? userImgUrl = await InstagramService().getUserProfileImgUrl(userProfile['username']);
    final userData = await supabase.rpc('get_user_data', params: {'user_id': userProfile['id']});
    if (userData.length == 0) return false;

    await supabase.from('users').update({
      'username': userProfile['username'],
      'img_url': userImgUrl ?? userData[0]['img_url'],
    }).eq('id', userProfile['id']);

    context.read<MyInfo>().id = userProfile['id'];
    context.read<MyInfo>().username = userProfile['username'];
    context.read<MyInfo>().img_url = userImgUrl ?? userData[0]['img_url'];
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
      child: Text('Sign in with Instagram'),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => AuthWebView()));
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
                      else return signInButton;
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