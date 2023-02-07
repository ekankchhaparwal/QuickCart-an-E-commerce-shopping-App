import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import '../models/http_exception.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _expiryTime;
  bool showSnackBar = false;
  bool get isAuth {
    return Token != null;
  }

  String? get Token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId.toString();
  }

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
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      _autoLogout();
      notifyListeners();
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
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      _autoLogout();

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  void logOut() {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_expiryTime != null) {
      _expiryTime!.cancel();
      _expiryTime = null;
    }
    showSnackBar = true;
    notifyListeners();
  }

  void changeBoolean() {
    showSnackBar = !showSnackBar;
  }

  void _autoLogout() {
    if (_expiryTime != null) {
      _expiryTime!.cancel();
    }
    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _expiryTime = Timer(Duration(seconds: timeToExpiry), logOut);
  }
}
