import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expireDate;
  String? _userId;
  Timer? _timer;

  bool get isAuth {
    return token != null;
  }

  String get userId => _userId ?? '';

  String? get token {
    if (_expireDate != null &&
        _expireDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyAO3QFxNRrPONFdZOD0qFwUOsJC-nVoVmg';
    try {
      final res = await http.post(Uri.parse(url),
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final Map<String, dynamic> resData = json.decode(res.body);
      if (resData['error'] != null) {
        throw HttpException(resData['error']['message']);
      }
      _token = resData['idToken'];
      _userId = resData['localId'];
      _expireDate = DateTime.now()
          .add(Duration(seconds: int.parse(resData['expiresIn'])));
      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expireDate': _expireDate?.toIso8601String(),
      });
      await prefs.setString('userData', userData);
    } catch (e) {
      throw e;
    }
  }

  Future<bool> tryAutologin() async {
    final prefs = await SharedPreferences.getInstance();
    final sharedUserData = prefs.getString('userData');
    if(sharedUserData != null) {
      final Map<String, dynamic> userData = json.decode(sharedUserData);
      final expiryDate = DateTime.parse(userData['expireDate']);
      if(expiryDate.isAfter(DateTime.now())) {
        _token = userData['token'];
        _userId = userData['userId'];
        _expireDate = expiryDate;
        notifyListeners();
        return true;
      }
      return false;
    }
    return false;
  }

  Future<void> login(String email, String password) async {
    return await _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> signUp(String email, String password) async {
    return await _authenticate(email, password, 'signUp');
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
    _token = null;
    _userId = null;
    _expireDate = null;
    _timer?.cancel();
    notifyListeners();
  }

  void _autoLogout() {
    _timer?.cancel();
    final timeToExp = _expireDate?.difference(DateTime.now()).inSeconds;
    if (timeToExp != null) {
      _timer = Timer(Duration(seconds: timeToExp), logout);
    }
  }
}
