import 'package:flutter/material.dart';
import 'package:refd_app/config/local_storage/local_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {
  static SharedPreferences? _securedStorage;

  static Future getInstance() async {
    _securedStorage ??= await SharedPreferences.getInstance();
    debugPrint("shared preferences is created");
    return _securedStorage;
  }

  /// Setters
  /// Set Language
  static Future<bool> setLanguage(String language) async {
    return await _securedStorage!.setString(LocalKeys.language, language);
  }

  /// Set Access Token
  static Future<bool> setUserToken(String token) async {
    return await _securedStorage!.setString(LocalKeys.userToken, token);
  }

  /// Set User Map
  static Future<bool> setUserMap(String userMap) async {
    return await _securedStorage!.setString(LocalKeys.userMap, userMap);
  }

  /// Set Is Light
  static Future<bool> setIsLight(bool isLight) async {
    return await _securedStorage!.setBool(LocalKeys.isLight, isLight);
  }

  /// Set Email
  static Future<bool> setEmail(String email) async {
    return await _securedStorage!.setString(LocalKeys.email, email);
  }

  /// Set Password
  static Future<bool> setPassword(String password) async {
    return await _securedStorage!.setString(LocalKeys.password, password);
  }

  /// Getters
  /// Get Language
  static Future<String?> getLanguage() async {
    return _securedStorage!.getString(LocalKeys.language);
  }

  /// Get Access Token
  static Future<String?> getUserToken() async {
    return _securedStorage!.getString(LocalKeys.userToken);
  }

  /// Get User Map
  static Future<String?> getUserMap() async {
    return _securedStorage!.getString(LocalKeys.userMap);
  }

  /// Get Is Light
  static Future<bool?> getIsLight() async {
    return _securedStorage!.getBool(LocalKeys.isLight);
  }

  /// Get Email
  static Future<String?> getEmail() async {
    return _securedStorage!.getString(LocalKeys.email);
  }

  /// Get Password
  static Future<String?> getPassword() async {
    return _securedStorage!.getString(LocalKeys.password);
  }

  static clearData() {
    _securedStorage!.remove(LocalKeys.userToken);
    _securedStorage!.remove(LocalKeys.userMap);
  }
}
