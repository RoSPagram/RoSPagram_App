import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:provider/provider.dart';
// import 'package:webview_flutter_android/webview_flutter_android.dart';
// import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import '../constants.dart';
import '../utilities/shared_prefs.dart';
import '../utilities/instagram_service.dart';
import './main_screen.dart';
import '../providers/my_info.dart';

class AuthWebView extends StatelessWidget {
  AuthWebView({super.key});

  final WebViewController _controller = WebViewController();

  @override
  Widget build(BuildContext context) {
    _controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) async {
            if(request.url.startsWith('https://localhost/')) {
              final code = Uri.parse(request.url).queryParameters['code'];
              final token = await InstagramService().getUserToken(code);
              final userProfile = await InstagramService().getUserInfo(token);
              SharedPrefs.instance.setString('user_token', token);
              // userId: userProfile['id'], userName: userProfile['username']
              context.read<MyInfo>().id = userProfile['id'];
              context.read<MyInfo>().name = userProfile['username'];
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainScreen()), (route) => false);
            }
            return NavigationDecision.navigate;
          },
      ))
      ..loadRequest(Uri.parse(INSTAGRAM_API_URL));
    return Scaffold(
      body: SafeArea(
        child: WebViewWidget(controller: _controller,),
      ),
    );
  }
}