import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {

  final String baseUrl = "http://10.0.2.2:8080/api/v1";

  // 🔐 LOGIN
  Future<bool> login(String usuario, String password) async {

    final url = Uri.parse("$baseUrl/login");

    try {

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "usuario": usuario,
          "password": password
        }),
      );

      if(response.statusCode == 200){

        final data = jsonDecode(response.body);
        final token = data["token"];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", token);

        return true;

      }

      return false;

    } catch (e) {
      return false;
    }
  }

  // 📝 REGISTER
  Future<bool> register(String usuario, String email, String password) async {

    final url = Uri.parse("$baseUrl/usuarios");

    try {

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "usuario": usuario,
          "email": email,
          "password": password
        }),
      );

      return response.statusCode == 200 || response.statusCode == 201;

    } catch (e) {
      return false;
    }
  }

  // 🔍 VALIDAR SESIÓN
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token") != null;
  }

  // 🚪 LOGOUT REAL
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");
  }

  // 🔑 TOKEN
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }
}