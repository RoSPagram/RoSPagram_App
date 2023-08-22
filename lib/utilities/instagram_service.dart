import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants.dart';

class InstagramService {
  factory InstagramService() => InstagramService._internal();
  InstagramService._internal();

  Future<String> getUserToken(String? authCode) async {
    Uri uri = Uri.parse('https://api.instagram.com/oauth/access_token');
    http.Response res = await http.post(
      uri,
      body: {
        'client_id': INSTAGRAM_API_CLIENT_ID,
        'client_secret': INSTAGRAM_API_APP_SECRET,
        'grant_type': 'authorization_code',
        'redirect_uri': INSTAGRAM_API_REDIRECT_URL,
        'code': authCode,
      }
    );
    print(res.body);
    dynamic resData = jsonDecode(res.body);
    String shortLivedToken = resData['access_token'];

    uri = Uri.parse('https://graph.instagram.com/access_token?grant_type=ig_exchange_token&client_secret=$INSTAGRAM_API_APP_SECRET&access_token=$shortLivedToken');
    res = await http.get(uri);
    print(res.body);
    resData = jsonDecode(res.body);
    String longLivedToken = resData['access_token'];

    return longLivedToken;
  }
  
  Future<dynamic> getUserInfo(String token) async {
    final uri = Uri.parse('https://graph.instagram.com/me?fields=id,username&access_token=$token');
    final res = await http.get(uri);
    return jsonDecode(res.body);
  }
}