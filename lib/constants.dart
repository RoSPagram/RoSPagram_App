import 'package:flutter/material.dart';

// Instagram api
const String INSTAGRAM_API_CLIENT_ID = "";
const String INSTAGRAM_API_APP_SECRET = "";
const String INSTAGRAM_API_REDIRECT_URL = "";
const String INSTAGRAM_API_SCOPE = "user_profile";
const String INSTAGRAM_API_RESPONSE_TYPE = "code";
const String INSTAGRAM_API_URL = "https://api.instagram.com/oauth/authorize?client_id=$INSTAGRAM_API_CLIENT_ID&redirect_uri=$INSTAGRAM_API_REDIRECT_URL&scope=$INSTAGRAM_API_SCOPE&response_type=$INSTAGRAM_API_RESPONSE_TYPE";

//Dummy user data
const Map<String, dynamic> DUMMY_USER_DATA = {
  '0': {'username': 'instagram', 'rank': 'Master'},
  '1': {'username': 'cristiano', 'rank': 'Diamond'},
  '2': {'username': 'leomessi', 'rank': 'Platinum'},
  '3': {'username': 'selenagomez', 'rank': 'Gold'},
  '4': {'username': 'kyliejenner', 'rank': 'Gold'},
  '5': {'username': 'therock', 'rank': 'Silver'},
  '6': {'username': 'arianagrande', 'rank': 'Silver'},
  '7': {'username': 'kimkardashian', 'rank': 'Bronze'},
  '8': {'username': 'beyonce', 'rank': 'Bronze'},
  '9': {'username': 'khloekardashian', 'rank': 'Unranked'},
};

// Gradient colors by rank
List<Color> rankColorGradient(String userRank) {
  switch(userRank) {
    case 'Bronze':
      return const [Color(0xFFCD7F32), Color(0xFFE6BF98)];
    case 'Silver':
      return const [Color(0xFFC0C0C0), Color(0xFFDFDFDF)];
    case 'Gold':
      return const [Color(0xFFFFD700), Color(0xFFFFEB7F)];
    case 'Platinum':
      return const [Color(0xFFA0B2C6), Color(0xFFCFD8E2)];
    case 'Diamond':
      return const [Color(0xFFB9F2FF), Color(0xFFDCF8FF)];
    case 'Master':
      return const [Color(0xFFE0B0FF), Color(0xFFEFD7FF)];
    default:
      return const [Color(0xFF70A1B6), Color(0xFFD4E2E9)];
  }
}