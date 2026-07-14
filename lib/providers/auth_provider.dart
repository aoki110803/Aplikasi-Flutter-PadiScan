import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../services/storage_service.dart';

class AuthProvider with ChangeNotifier {
  final _storage = StorageService();
  String? _token;
  String? _userName;
  String? _userEmail;
  bool    _isLoading    = false;
  String? _errorMessage;

  String? get token        => _token;
  String? get userName     => _userName;
  String? get userEmail    => _userEmail;
  bool    get isLoading    => _isLoading;
  bool    get isAuth       => _token != null;
  String? get errorMessage => _errorMessage;

  Future<void> checkSession() async {
    _token = await _storage.getToken();
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true); _errorMessage = null;
    try {
      final res = await http.post(Uri.parse(ApiConfig.login),
        headers: {'Content-Type':'application/json','Accept':'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200 && data['token'] != null) {
        _token     = data['token'];
        _userName  = data['user']?['name'] ?? '';
        _userEmail = data['user']?['email'] ?? '';
        await _storage.saveToken(_token!);
        _setLoading(false); return true;
      }
      _errorMessage = data['message'] ?? 'Login gagal';
    } catch (_) { _errorMessage = 'Tidak dapat terhubung ke server'; }
    _setLoading(false); return false;
  }

  Future<bool> register(String name, String email, String password) async {
    _setLoading(true); _errorMessage = null;
    try {
      final res = await http.post(Uri.parse(ApiConfig.register),
        headers: {'Content-Type':'application/json','Accept':'application/json'},
        body: jsonEncode({'name': name, 'email': email,
          'password': password, 'password_confirmation': password}),
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 201 && data['token'] != null) {
        _token     = data['token'];
        _userName  = data['user']?['name'] ?? '';
        _userEmail = data['user']?['email'] ?? '';
        await _storage.saveToken(_token!);
        _setLoading(false); return true;
      }
      _errorMessage = data['message'] ?? 'Registrasi gagal';
    } catch (_) { _errorMessage = 'Tidak dapat terhubung ke server'; }
    _setLoading(false); return false;
  }

  // Update nama dan/atau password. newPassword bisa null jika tidak diganti.
  Future<bool> updateProfile({
    String? name,
    String? currentPassword,
    String? newPassword,
  }) async {
    _setLoading(true); _errorMessage = null;
    try {
      final body = <String, dynamic>{};
      if (name != null && name.isNotEmpty) body['name'] = name;
      if (newPassword != null && newPassword.isNotEmpty) {
        body['current_password']      = currentPassword;
        body['new_password']          = newPassword;
        body['new_password_confirmation'] = newPassword;
      }
  
      final res = await http.put(Uri.parse(ApiConfig.profile),
        headers: {
          'Content-Type':  'application/json',
          'Accept':        'application/json',
          'Authorization': 'Bearer $_token',
        },
        body: jsonEncode(body),
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        _userName = data['user']?['name'] ?? _userName;
        _setLoading(false); notifyListeners();
        return true;
      }
      _errorMessage = data['message'] ?? 'Gagal memperbarui profil';
    } catch (_) { _errorMessage = 'Tidak dapat terhubung ke server'; }
    _setLoading(false); return false;
  }


  Future<void> logout() async {
    try { await http.post(Uri.parse(ApiConfig.logout),
      headers: {'Authorization':'Bearer $_token','Accept':'application/json'}); }
    catch (_) {}
    _token = _userName = _userEmail = null;
    await _storage.deleteToken();
    notifyListeners();
  }

  void _setLoading(bool v) { _isLoading = v; notifyListeners(); }
}
