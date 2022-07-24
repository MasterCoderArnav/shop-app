import 'dart:convert';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shop/model/http_exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

const params = {
  'key': 'AIzaSyDLsFXEEsRss38yoCu2b2VoVYpfWIzaw6Q',
};

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiry;
  String? _userId;
  Timer? _authTimer;

  bool get isAuth {
    return _token != null;
  }

  String? get token {
    if (_token != null && _expiry != null && _expiry!.isAfter(DateTime.now())) {
      return _token;
    } else {
      return null;
    }
  }

  String? get userID {
    return _userId;
  }

  Future<void> signUp({required String email, required String password}) async {
    try {
      final authUri = Uri.https(
          'identitytoolkit.googleapis.com', '/v1/accounts:signUp', params);
      final response = await http.post(
        authUri,
        body: json.encode(
          {
            "email": email,
            "password": password,
            "returnSecureToken": true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(message: responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiry = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      print(json.decode(response.body));
      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userID': _userId,
        'expiryDate': _expiry!.toIso8601String()
      });
      prefs.setString('userData', userData);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logIn({required String email, required String password}) async {
    try {
      final authUri = Uri.https('identitytoolkit.googleapis.com',
          '/v1/accounts:signInWithPassword', params);
      final response = await http.post(
        authUri,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(message: responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiry = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      print(json.decode(response.body));
      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userID': _userId,
        'expiryDate': _expiry!.toIso8601String()
      });
      prefs.setString('userData', userData);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logOut() async {
    _expiry = null;
    _token = null;
    _userId = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    notifyListeners();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final ttl = _expiry!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: ttl), logOut);
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('userData')) {
      final extractedData =
          json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
      final expiryData = DateTime.parse(extractedData['expiryDate'] as String);
      if (expiryData.isBefore(DateTime.now())) {
        return false;
      } else {
        _token = extractedData['token'] as String;
        _expiry = DateTime.parse(extractedData['expiryDate'] as String);
        _userId = extractedData['userID'] as String;
        _autoLogout();
        notifyListeners();
        return true;
      }
    } else {
      return false;
    }
  }
}
