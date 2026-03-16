import 'dart:convert';
import 'package:app_clientes/config/api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CrearCliente extends StatefulWidget {
  static const String ROUTE = "/crear";

  @override
  State<CrearCliente> createState() => _CrearClienteState();
}

class _CrearClienteState extends State<CrearCliente> {
  final _formKey = GlobalKey<FormState>();

  final dpiController = TextEditingController();
  final nombreController = TextEditingController();
  final emailController = TextEditingController();
  final telefonoController = TextEditingController();

  Map? clienteEditar;
  bool loading = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)!.settings.arguments as Map?;
      if (args != null) {
        setState(() {
          clienteEditar = args;
          dpiController.text = clienteEditar!["Dpi"] ?? "";
          nombreController.text = clienteEditar!["Nombre"] ?? "";
          emailController.text = clienteEditar!["Email"] ?? "";
          telefonoController.text = clienteEditar!["Telefono"] ?? "";
        });
      }
    });
  }

  Future guardarCliente() async {
    setState(() => loading = true);

    try {
      final response = await http
          .post(
            Uri.parse("${Api.baseUrl}/clientes"),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              "dpi": dpiController.text,
              "nombre": nombreController.text,
              "email": emailController.text,
              "telefono": telefonoController.text
            }),
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Cliente guardado correctamente"),
            backgroundColor: Color.fromARGB(255, 105, 207, 235),
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error del servidor (${response.statusCode})"),
            backgroundColor: Colors.redAccent,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No se pudo conectar con la API"),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        ),
      );
    } finally {
      setState(() => loading = false);
    }
  }

  Future actualizarCliente(int id) async {
    setState(() => loading = true);

    try {
      final response = await http
          .put(
            Uri.parse("${Api.baseUrl}/clientes/$id"),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              "dpi": dpiController.text,
              "nombre": nombreController.text,
              "email": emailController.text,
              "telefono": telefonoController.text
            }),
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Cliente actualizado correctamente"),
            backgroundColor: Color.fromARGB(255, 105, 207, 235),
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error del servidor (${response.statusCode})"),
            backgroundColor: Colors.redAccent,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No se pudo conectar con la API"),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        ),
      );
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(clienteEditar == null ? "Crear cliente" : "Editar cliente"),
        backgroundColor: const Color.fromARGB(255, 105, 207, 235),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // DPI
                TextFormField(
                  controller: dpiController,
                  validator: (value) =>
                      (value == null || value.isEmpty) ? "Campo obligatorio" : null,
                  decoration: InputDecoration(
                    labelText: "DPI",
                    prefixIcon: const Icon(Icons.badge),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
                const SizedBox(height: 15),

                // Nombre
                TextFormField(
                  controller: nombreController,
                  validator: (value) =>
                      (value == null || value.isEmpty) ? "Campo obligatorio" : null,
                  decoration: InputDecoration(
                    labelText: "Nombre",
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
                const SizedBox(height: 15),

                // Email
                TextFormField(
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Campo obligatorio";
                    if (!value.contains("@")) return "Ingrese un email válido";
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "Email",
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
                const SizedBox(height: 15),

                // Teléfono
                TextFormField(
                  controller: telefonoController,
                  validator: (value) =>
                      (value == null || value.isEmpty) ? "Campo obligatorio" : null,
                  decoration: InputDecoration(
                    labelText: "Teléfono",
                    prefixIcon: const Icon(Icons.phone),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
                const SizedBox(height: 25),

                // Botón Guardar / Actualizar con animación
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: loading
                      ? const CircularProgressIndicator(color: Color.fromARGB(255, 105, 207, 235))
                      : SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                if (clienteEditar == null) {
                                  guardarCliente();
                                } else {
                                  actualizarCliente(clienteEditar!["ID"]);
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 105, 207, 235),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 3,
                            ),
                            child: Text(
                              clienteEditar == null ? "Guardar" : "Actualizar",
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}