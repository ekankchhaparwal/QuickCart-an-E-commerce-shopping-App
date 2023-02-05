import 'package:flutter/cupertino.dart';
import 'dart:convert';
import '../models/http_exception.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  late String _token;
  late DateTime expiryDate;
  late String _userId;
  Future<void> signup(String email, String password) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyB3CSvGTDl75ibkdEzZnmNLvpLnW79_RnM');
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            "returnSecureToken": true,
          }));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> logIn(String email, String password) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyB3CSvGTDl75ibkdEzZnmNLvpLnW79_RnM');
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            "returnSecureToken": true,
          }));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      print(responseData);
    } catch (error) {
      rethrow;
    }
  }
}
