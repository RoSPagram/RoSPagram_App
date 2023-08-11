import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import '../constants.dart';
import '../utilities/instagram_service.dart';
import './main_screen.dart';

class AuthWebView extends StatefulWidget {
  const AuthWebView({super.key});

  @override
  State<AuthWebView> createState() => _AuthWebViewState();
}

class _AuthWebViewState extends State<AuthWebView> {
  late final WebViewController _controller;
  final InstagramService instagramService = InstagramService();

  @override
  initState() {
    super.initState();
    final WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    _controller
      ..setNavigationDelegate(NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) async {
            if(request.url.startsWith('https://localhost/')) {
              final code = Uri.parse(request.url).queryParameters['code'];
              final token = await instagramService.getUserToken(code);
              final userInfo = await instagramService.getUserInfo(token);
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainScreen(userId: userInfo['id'], userName: userInfo['username'])), (route) => false);
            }
            return NavigationDecision.navigate;
          }
      ))
      ..loadRequest(Uri.parse(Constants.url));
    return Scaffold(
      body: SafeArea(
        child: WebViewWidget(controller: _controller,),
      ),
    );
  }
}