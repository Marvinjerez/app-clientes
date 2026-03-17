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
  bool visible = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() => visible = true);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)!.settings.arguments as Map?;
      if (args != null) {
        clienteEditar = args;
        dpiController.text = clienteEditar!["Dpi"] ?? "";
        nombreController.text = clienteEditar!["Nombre"] ?? "";
        emailController.text = clienteEditar!["Email"] ?? "";
        telefonoController.text = clienteEditar!["Telefono"] ?? "";
        setState(() {});
      }
    });
  }

  Future guardarCliente() async {
    setState(() => loading = true);
    final response = await http.post(
      Uri.parse("${Api.baseUrl}/clientes"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "dpi": dpiController.text,
        "nombre": nombreController.text,
        "email": emailController.text,
        "telefono": telefonoController.text
      }),
    );
    setState(() => loading = false);
    if (response.statusCode == 200) {
      Navigator.pop(context, true);
    }
  }

  Future actualizarCliente(int id) async {
    setState(() => loading = true);
    final response = await http.put(
      Uri.parse("${Api.baseUrl}/clientes/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "dpi": dpiController.text,
        "nombre": nombreController.text,
        "email": emailController.text,
        "telefono": telefonoController.text
      }),
    );
    setState(() => loading = false);
    if (response.statusCode == 200) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF6DD5FA),
                  Color(0xFF2980B9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 800),
                  opacity: visible ? 1 : 0,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 800),
                    transform: Matrix4.translationValues(0, visible ? 0 : 50, 0),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Container(
                        padding: const EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 15,
                              offset: const Offset(0, 10),
                            )
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Hero(
                                tag: "fabCliente",
                                child: Icon(
                                  clienteEditar == null
                                      ? Icons.person_add
                                      : Icons.edit,
                                  size: 70,
                                  color: const Color(0xFF2980B9),
                                ),
                              ),
                              const SizedBox(height: 15),
                              Text(
                                clienteEditar == null
                                    ? "Nuevo Cliente"
                                    : "Editar Cliente",
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 20),
                              _input("DPI", Icons.badge, dpiController),
                              const SizedBox(height: 15),
                              _input("Nombre", Icons.person, nombreController),
                              const SizedBox(height: 15),
                              _input("Email", Icons.email, emailController,
                                  email: true),
                              const SizedBox(height: 15),
                              _input("Teléfono", Icons.phone, telefonoController),
                              const SizedBox(height: 25),
                              ElevatedButton(
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
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(20),
                                  backgroundColor: const Color(0xFF2980B9),
                                ),
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  child: loading
                                      ? const SizedBox(
                                          key: ValueKey("loading"),
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                              color: Colors.white),
                                        )
                                      : const Icon(
                                          Icons.check,
                                          key: ValueKey("icon"),
                                          color: Colors.white,
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _input(String label, IconData icon, TextEditingController controller,
      {bool email = false}) {
    return TextFormField(
      controller: controller,
      validator: (value) {
        if (value == null || value.isEmpty) return "Campo obligatorio";
        if (email && !value.contains("@")) return "Email inválido";
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}