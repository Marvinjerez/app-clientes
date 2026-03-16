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

    if(!_formKey.currentState!.validate()){
      return;
    }

    setState(() {
      loading = true;
    });

    bool success = await authService.login(
      usuarioController.text,
      passwordController.text
    );

    setState(() {
      loading = false;
    });

    if(success){

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ListaClientes()
        ),
      );

    }else{

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Usuario o contraseña incorrectos"),
        ),
      );

    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Login"),
      ),

      body: Center(

        child: SingleChildScrollView(

          child: Padding(
            padding: const EdgeInsets.all(20),

            child: Form(
              key: _formKey,

              child: Column(

                children: [

                  const Icon(
                    Icons.lock,
                    size: 80,
                    color: Colors.blue,
                  ),

                  const SizedBox(height: 30),

                  TextFormField(
                    controller: usuarioController,
                    decoration: const InputDecoration(
                      labelText: "Usuario",
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if(value == null || value.isEmpty){
                        return "Ingrese el usuario";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Contraseña",
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if(value == null || value.isEmpty){
                        return "Ingrese la contraseña";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 30),

                  loading
                      ? const CircularProgressIndicator()
                      : SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: login,
                            child: const Text(
                              "Ingresar",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        )

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

