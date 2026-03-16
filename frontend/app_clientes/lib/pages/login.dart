import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'lista_clientes.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  static const String ROUTE = "/login";

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final usuarioController = TextEditingController();
  final passwordController = TextEditingController();

  final AuthService authService = AuthService();

  bool loading = false;
  final _formKey = GlobalKey<FormState>();

  void login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    bool success = await authService.login(
      usuarioController.text,
      passwordController.text,
    );

    setState(() => loading = false);

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ListaClientes()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Usuario o contraseña incorrectos"),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("Login"),
        backgroundColor: const Color.fromARGB(255, 105, 207, 235),
        elevation: 4,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Icono de login grande
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 105, 207, 235).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(24),
                    child: const Icon(
                      Icons.lock,
                      size: 80,
                      color: Color.fromARGB(255, 105, 207, 235),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Usuario
                  TextFormField(
                    controller: usuarioController,
                    decoration: InputDecoration(
                      labelText: "Usuario",
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) =>
                        (value == null || value.isEmpty) ? "Ingrese el usuario" : null,
                  ),
                  const SizedBox(height: 20),

                  // Contraseña
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Contraseña",
                      prefixIcon: const Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) =>
                        (value == null || value.isEmpty) ? "Ingrese la contraseña" : null,
                  ),
                  const SizedBox(height: 30),

                  // Botón de login con animación de carga
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: loading
                        ? const CircularProgressIndicator(
                            color: Color.fromARGB(255, 105, 207, 235),
                          )
                        : SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(255, 105, 207, 235),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 3,
                              ),
                              child: const Text(
                                "Ingresar",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}