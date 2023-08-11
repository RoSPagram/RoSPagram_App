import 'package:flutter/material.dart';
import './auth_webview.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});
  @override
  Widget build(BuildContext context) {
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
                child: FilledButton(
                  style: FilledButton.styleFrom(backgroundColor: Color(0xff000000)),
                  child: Text('Sign in with Instagram'),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const AuthWebView()));
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}