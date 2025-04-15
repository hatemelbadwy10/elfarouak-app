import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefServices {
  SharedPreferences? _prefs;

  SharedPrefServices() {
    init();
  }

  init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  reloadLocalStorage() async {
    await _prefs!.reload();
  }

  saveString(String key, String value) async {
    _prefs!.setString(key, value);
  }

  setStringList(String key, List<String> value) async {
    _prefs!.setStringList(key, value);
  }

  saveBoolean(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  saveInLocalStorageAsInt(String key, int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
  }

  Future<bool> getBoolean(String? key) async {
    return await Future.value(_prefs!.getBool(key!) ?? false);
  }

  getString(String? key) async {
    return await Future.value(_prefs!.getString(key!));
  }

  getStringList(String? key) async {
    return _prefs!.getStringList(key!);
  }

  Future<int> getInt(String? key) async {
    await _prefs!.reload();
    int data = await Future.value(_prefs!.getInt(key!) ?? 0);
    return data;
  }

  Future<List> getList(String? key) async {
    String data = await Future.value(_prefs!.getString(key!));
    return jsonDecode(data);
  }

  Future<bool> containKey(String? key) async {
    bool data = await Future.value(_prefs!.containsKey(key!));
    return data;
  }

  removeFromLocalStorage({@required String? key}) async {
    var data = _prefs!.remove(key!);
    return data;
  }

  clearLocalStorage() async {
    final email = _prefs!.getString('email');
    final password =_prefs!.getString('password');
    await _prefs!.clear();
    await reloadLocalStorage();
    _prefs!.setString('email', email??'');
    _prefs!.setString('password', password??'');
  }
}
