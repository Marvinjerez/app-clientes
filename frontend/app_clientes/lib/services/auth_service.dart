import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {

  final String baseUrl = "http://10.0.2.2:8080/api/v1";

  Future<bool> login(String usuario, String password) async {

    final url = Uri.parse("$baseUrl/login");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json"
      },
      body: jsonEncode({
        "usuario": usuario,
        "password": password
      }),
    );

    if(response.statusCode == 200){

      final data = jsonDecode(response.body);
      final token = data["token"];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", token);

      return true;

    }else{

      return false;

    }
  }

  Future<String?> getToken() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");

  }
}