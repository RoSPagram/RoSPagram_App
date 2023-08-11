import 'package:http/http.dart' as http;
import '../constants.dart';

class InstagramService {
  Future<void> getUserToken(String authCode) async {
    final uri = Uri.parse('https://api.instagram.com/oauth/access_token');
    final res = await http.post(
      uri,
      body: {
        'client_id': Constants.clientId,
        'client_secret': Constants.appSecret,
        'grant_type': 'authorization_code',
        'redirect_uri': Constants.redirectUrl,
        'code': authCode
      }
    );
    print(res.body);
  }
}