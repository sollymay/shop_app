import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  Future<void> signup(String email, String password) async {
    const params = {
      'key': 'AIzaSyDYGX1acwiScjR2GvuxetYCZVOEHFIQtFA',
    };
    var url = Uri.https(
        "identitytoolkit.googleapis.com", "/v1/accounts:signUp", params);
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> login(String email, String password) async {
    const params = {
      'key': 'AIzaSyDYGX1acwiScjR2GvuxetYCZVOEHFIQtFA',
    };
    var url = Uri.https("identitytoolkit.googleapis.com",
        "/v1/accounts:signInWithPassword", params);
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
    } catch (error) {
      throw error;
    }
  }
}
