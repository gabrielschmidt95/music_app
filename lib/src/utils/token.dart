import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/token.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<Token> fetchToken({bool force = false}) async {
  final prefs = await SharedPreferences.getInstance();

  if (!force) {
    final tokenString = prefs.getString('token') ?? "";
    if (tokenString != "") {
      var getTokenData = json.decode(tokenString) as Map<String, dynamic>;
      return Token.fromJSON(getTokenData);
    }
  }
  print("Fetching new token");

  final response = await http.post(
    Uri.https(dotenv.get('OAUTH_DOMAIN'), "/oauth/token"),
    body: {
      "client_id": dotenv.get('OAUTH_CLIENT_ID'),
      "client_secret": dotenv.get('OAUTH_CLIENT_SECRET'),
      "audience": dotenv.get('OAUTH_AUDIENCE'),
      "grant_type": "client_credentials"
    },
  );
  if (response.statusCode == 200) {
    var getTokenData = json.decode(response.body) as Map<String, dynamic>;
    var token = Token.fromJSON(getTokenData);

    await prefs.setString('token', response.body);

    return token;
  } else {
    throw Exception('Failed to load users');
  }
}
