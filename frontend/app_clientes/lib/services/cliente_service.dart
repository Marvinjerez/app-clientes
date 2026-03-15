import 'dart:convert';
import 'package:http/http.dart' as http;

class ClienteService {

  final String baseUrl = "http://10.0.2.2:8080/api/v1/clientes";

  Future<List<dynamic>> getClientes() async {

    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Error cargando clientes");
    }
  }
}