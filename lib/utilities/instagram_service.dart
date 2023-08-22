import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants.dart';

class InstagramService {
  factory InstagramService() => InstagramService._internal();
  InstagramService._internal();

  Future<String> getUserToken(String? authCode) async {
    final uri = Uri.parse('https://api.instagram.com/oauth/access_token');
    final res = await http.post(
      uri,
      body: {
        'client_id': INSTAGRAM_API_CLIENT_ID,
        'client_secret': INSTAGRAM_API_APP_SECRET,
        'grant_type': 'authorization_code',
        'redirect_uri': INSTAGRAM_API_REDIRECT_URL,
        'code': authCode
      }
    );
    final resData = jsonDecode(res.body);
    final shortLivedToken = resData['access_token'];
    return shortLivedToken;
  }
  
  Future<dynamic> getUserInfo(String token) async {
    final uri = Uri.parse('https://graph.instagram.com/me?fields=id,username&access_token=$token');
    final res = await http.get(uri);
    return jsonDecode(res.body);
  }
}