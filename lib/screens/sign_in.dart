import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/my_info.dart';
import '../utilities/shared_prefs.dart';
import '../utilities/instagram_service.dart';
import './auth_webview.dart';
import './main_screen.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool showSignInButton = false;

  @override
  Widget build(BuildContext context) {
    String? oldToken = SharedPrefs.instance.getString('user_token');
    if (oldToken != null) {
      InstagramService().refreshUserToken(oldToken).then((newToken) {
        InstagramService().getUserInfo(newToken).then((userProfile) {
          if (userProfile['error'] == null) {
            context.read<MyInfo>().id = userProfile['id'];
            context.read<MyInfo>().name = userProfile['username'];
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainScreen()), (route) => false);
          }
          else setState(() {
            showSignInButton = true;
          });
        });
      });
    }
    else setState(() {
      showSignInButton = true;
    });
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
                child: showSignInButton ? FilledButton(
                  style: FilledButton.styleFrom(backgroundColor: Color(0xff000000)),
                  child: Text('Sign in with Instagram'),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AuthWebView()));
                  },
                ) :
                Text(
                  'Loading...',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}