import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:chat_app/global/environment.dart';
import 'package:chat_app/models/login_response.dart';
import 'package:chat_app/models/usuario.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthService with ChangeNotifier {
  //Usuario
  Usuario usuario;
  bool _autenticando = false;
  bool _registrando = false;
  final _storage = new FlutterSecureStorage();

  bool get autenticando => this._autenticando;
  bool get registrando => this._registrando;

  set registrando(bool valor) {
    this._registrando = valor;
    notifyListeners();
  }

  set autenticando(bool valor) {
    this._autenticando = valor;
    notifyListeners();
  }

  //getters de token
  static Future<String> getToken() async {
    final _storage = new FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token;
  }

  static Future<void> deleteToken() async {
    final _storage = new FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }

  Future<bool> login(String email, String password) async {
    this.autenticando = true;
    final data = {'email': email, 'password': password};
    final res = await http.post('${Environment.apiUrl}/login/login',
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});

    this.autenticando = false;
    if (res.statusCode == 200) {
      final loginReponse = loginResponseFromJson(res.body);
      this.usuario = loginReponse.usuario;
      await this.guardarToken(loginReponse.token);
      return true;
    } else {
      return false;
    }
  }

  Future register(String nombre, String email, String password) async {
    this.registrando = true;
    final data = {'nombre': nombre, 'email': email, 'password': password};
    final res = await http.post('${Environment.apiUrl}/login/new',
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});
    this.autenticando = false;
    if (res.statusCode == 200) {
      final loginReponse = loginResponseFromJson(res.body);
      this.usuario = loginReponse.usuario;
      await this.guardarToken(loginReponse.token);
      return true;
    } else {
      final resBody = jsonDecode(res.body);
      return resBody['msg'];
    }
  }

  Future guardarToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  Future logout() async {
    return await _storage.delete(key: 'token');
  }

  Future<bool> isLoggedIn() async {
    final token = await this._storage.read(key: 'token');
    final res = await http.get('${Environment.apiUrl}/login/renew',
        headers: {'Content-Type': 'application/json', 'x-token': token});
    if (res.statusCode == 200) {
      final loginReponse = loginResponseFromJson(res.body);
      this.usuario = loginReponse.usuario;
      await this.guardarToken(loginReponse.token);
      return true;
    } else {
      this.logout();
      return false;
    }
  }
}
