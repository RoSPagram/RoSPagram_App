import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import '../constants.dart';
import '../utilities/instagram_service.dart';

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
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onNavigationRequest: (NavigationRequest request) {
          if(request.url.startsWith('https://localhost/')) {
            final String code = Uri.parse(request.url).queryParameters['code'] ?? '';
            instagramService.getUserToken(code);
          }
          return NavigationDecision.navigate;
        }
      ))
      ..loadRequest(Uri.parse(Constants.url));
    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WebViewWidget(controller: _controller,),
      ),
    );
  }
}