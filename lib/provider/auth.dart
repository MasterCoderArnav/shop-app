import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shop/model/http_exceptions.dart';

const params = {
  'key': 'AIzaSyDLsFXEEsRss38yoCu2b2VoVYpfWIzaw6Q',
};

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiry;
  String? _userId;

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
      notifyListeners();
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
      notifyListeners();
    } on Exception catch (e) {
      rethrow;
    }
  }
}
