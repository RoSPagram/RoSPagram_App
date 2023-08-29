import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:provider/provider.dart';
// import 'package:webview_flutter_android/webview_flutter_android.dart';
// import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import '../constants.dart';
import '../utilities/shared_prefs.dart';
import '../utilities/instagram_service.dart';
import '../utilities/supabase_util.dart';
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
              String? userImgUrl = await InstagramService().getUserProfileImgUrl(userProfile['username']);
              if (userImgUrl == null) userImgUrl = 'https://i.ibb.co/Cv5LdCb/img-profile-default.jpg';
              final userData = await supabase.rpc('get_user_data', params: {'user_id': userProfile['id']});

              SharedPrefs.instance.setString('user_token', token);

              if (userData.length == 0) {
                await supabase.from('users').insert({
                  'id': userProfile['id'],
                  'username': userProfile['username'],
                  'img_url': userImgUrl
                });
              }

              context.read<MyInfo>().id = userProfile['id'];
              context.read<MyInfo>().username = userProfile['username'];
              context.read<MyInfo>().img_url = userImgUrl;
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